import json
import logging
import boto3
import uuid
from datetime import datetime
from botocore.exceptions import ClientError
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_COMMENTS_TABLE"])
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def add_cors_headers(response):
    """Add CORS headers to response"""
    headers = response.get("headers", {})
    headers.update(
        {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Amz-Date, X-Api-Key, X-Amz-Security-Token",
        }
    )
    response["headers"] = headers
    return response


def lambda_handler(event, context):
    print("=== COMMENTS LAMBDA INVOCATION ===")
    print("Full event:", json.dumps(event))

    http_method = event.get("httpMethod", "GET")
    path_parameters = event.get("pathParameters", {}) or {}
    post_id = path_parameters.get("post_id")

    print(f"Method: {http_method}, Post ID: {post_id}, Path Params: {path_parameters}")

    # Handle OPTIONS requests for CORS
    if http_method == "OPTIONS":
        print("Handling OPTIONS request")
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
        if http_method == "GET" and post_id:
            print(f"Getting comments for post: {post_id}")
            return add_cors_headers(get_comments(post_id))
        elif http_method == "POST":
            print("Adding new comment")
            body = event.get("body", "{}")
            print(f"Request body: {body}")
            return add_cors_headers(add_comment(body))
        else:
            print(f"Invalid request: {http_method} {post_id}")
            return add_cors_headers(
                {
                    "statusCode": 400,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"error": "Invalid request"}),
                }
            )
    except Exception as e:
        print("Error in comments handler:", str(e))
        import traceback

        print("Traceback:", traceback.format_exc())
        return add_cors_headers(
            {
                "statusCode": 500,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": str(e)}),
            }
        )


def get_comments(post_id):
    try:
        response = table.query(
            KeyConditionExpression="post_id = :pid",
            ExpressionAttributeValues={":pid": post_id},
        )
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(response.get("Items", [])),
        }
    except ClientError as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }


def add_comment(body):
    try:
        data = json.loads(body)
        post_id = data.get("post_id")
        author = data.get("author", "").strip()
        text = data.get("text", "").strip()

        if not post_id or not author or not text:
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Missing required fields"}),
            }

        comment_id = str(uuid.uuid4())

        table.put_item(
            Item={
                "post_id": post_id,
                "comment_id": comment_id,
                "author": author,
                "text": text,
                "timestamp": datetime.utcnow().isoformat(),
            }
        )
        return {
            "statusCode": 201,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "Comment added", "comment_id": comment_id}),
        }
    except ClientError as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }
