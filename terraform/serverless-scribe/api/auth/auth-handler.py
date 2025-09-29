import json
import boto3
import os
from botocore.exceptions import ClientError

cognito = boto3.client("cognito-idp")
user_pool_id = os.environ["COGNITO_USER_POOL_ID"]


def lambda_handler(event, context):
    print("Auth event:", json.dumps(event))

    http_method = event.get("httpMethod", "GET")
    path = event.get("rawPath", "")

    if http_method == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Amz-Date, X-Api-Key, X-Amz-Security-Token",
                "Access-Control-Allow-Credentials": "true",
            },
            "body": "",
        }

    try:
        if http_method == "POST" and "/auth/login" in path:
            return login(event.get("body", "{}"))
        elif http_method == "POST" and "/users" in path:
            claims = (
                event.get("requestContext", {}).get("authorizer", {}).get("claims", {})
            )
            return create_user(event.get("body", "{}"), claims)
        else:
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Invalid request"}),
            }
    except Exception as e:
        print("Error:", str(e))
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }


def login(body):
    try:
        data = json.loads(body)
        client_id = data.get("client_id")
        username = data.get("username", "").strip()
        password = data.get("password", "").strip()

        if not client_id or not username or not password:
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Missing required fields"}),
            }

        response = cognito.initiate_auth(
            ClientId=client_id,
            AuthFlow="USER_PASSWORD_AUTH",
            AuthParameters={"USERNAME": username, "PASSWORD": password},
        )

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(
                {
                    "id_token": response["AuthenticationResult"]["IdToken"],
                    "access_token": response["AuthenticationResult"]["AccessToken"],
                    "refresh_token": response["AuthenticationResult"]["RefreshToken"],
                }
            ),
        }
    except ClientError as e:
        error_message = str(e)
        if "NotAuthorizedException" in error_message:
            return {
                "statusCode": 401,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Invalid username or password"}),
            }
        elif "UserNotFoundException" in error_message:
            return {
                "statusCode": 404,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "User not found"}),
            }
        else:
            return {
                "statusCode": 500,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": error_message}),
            }


def create_user(body, claims):
    try:
        # Check if user is admin
        groups = claims.get("cognito:groups", [])
        if "Admins" not in groups:
            return {
                "statusCode": 403,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Unauthorized - Admin access required"}),
            }

        data = json.loads(body)
        username = data.get("username", "").strip()
        email = data.get("email", "").strip()
        group = data.get("group", "").strip()

        if not username or not email:
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Missing required fields"}),
            }

        # Create user
        response = cognito.admin_create_user(
            UserPoolId=user_pool_id,
            Username=username,
            UserAttributes=[
                {"Name": "email", "Value": email},
                {"Name": "email_verified", "Value": "True"},
            ],
            MessageAction="SUPPRESS",  # Don't send welcome email for demo
            TemporaryPassword="TempPassword123!",  # User will need to change this
        )

        # Set permanent password
        cognito.admin_set_user_password(
            UserPoolId=user_pool_id,
            Username=username,
            Password="Password123!",  # In production, generate a secure temp password
            Permanent=True,
        )

        # Add to group if specified
        if group:
            cognito.admin_add_user_to_group(
                UserPoolId=user_pool_id, Username=username, GroupName=group
            )

        return {
            "statusCode": 201,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "User created successfully"}),
        }
    except ClientError as e:
        error_message = str(e)
        if "UsernameExistsException" in error_message:
            return {
                "statusCode": 409,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "User already exists"}),
            }
        else:
            return {
                "statusCode": 500,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": error_message}),
            }
