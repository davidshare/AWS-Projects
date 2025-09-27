import json
import boto3
import html
import os
import uuid
from datetime import datetime
from botocore.exceptions import ClientError

dynamodb = boto3.resource("dynamodb")
s3 = boto3.client("s3")
posts_table = dynamodb.Table(os.environ["DYNAMODB_POSTS_TABLE"])
bucket = os.environ["S3_BUCKET"]


def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    http_method = event.get("httpMethod", "GET")
    path_parameters = event.get("pathParameters", {}) or {}
    post_id = path_parameters.get("post_id")
    claims = event.get("requestContext", {}).get("authorizer", {}).get("claims", {})

    print(f"Method: {http_method}, Post ID: {post_id}")

    try:
        if http_method == "POST" and not post_id:
            return create_post(json.loads(event.get("body", "{}")), claims)
        elif http_method == "GET" and post_id:
            return get_post(post_id)
        elif http_method == "GET" and not post_id:
            query_params = event.get("queryStringParameters", {}) or {}
            return list_posts(query_params)
        elif http_method == "PUT" and post_id:
            return update_post(post_id, json.loads(event.get("body", "{}")), claims)
        elif http_method == "DELETE" and post_id:
            return delete_post(post_id, claims)
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


def create_post(data, claims):
    if not claims.get("cognito:username"):
        return {
            "statusCode": 403,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Authentication required"}),
        }

    post_id = str(uuid.uuid4())
    slug = data.get("title", "").lower().replace(" ", "-")
    item = {
        "post_id": post_id,
        "title": data.get("title", ""),
        "slug": slug,
        "content": data.get("content", ""),
        "author": claims["cognito:username"],
        "publish_date": datetime.utcnow().isoformat(),
        "status": "published",
    }

    try:
        posts_table.put_item(Item=item)
        generate_and_upload_html(post_id, item)
        return {
            "statusCode": 201,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"post_id": post_id, "slug": slug}),
        }
    except ClientError as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }


def get_post(post_id):
    try:
        response = posts_table.get_item(Key={"post_id": post_id})
        item = response.get("Item")
        if not item:
            return {
                "statusCode": 404,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Post not found"}),
            }
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(item),
        }
    except ClientError as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }


def list_posts(params):
    try:
        page = int(params.get("page", 1))
        limit = int(params.get("limit", 10))

        response = posts_table.scan(Limit=limit)
        items = response.get("Items", [])

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(items),
        }
    except ClientError as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }


def update_post(post_id, data, claims):
    if not claims.get("cognito:username"):
        return {
            "statusCode": 403,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Authentication required"}),
        }

    try:
        response = posts_table.get_item(Key={"post_id": post_id})
        item = response.get("Item")
        if not item:
            return {
                "statusCode": 404,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Post not found"}),
            }

        # Check authorization
        if item["author"] != claims["cognito:username"] and "Admins" not in claims.get(
            "cognito:groups", []
        ):
            return {
                "statusCode": 403,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Unauthorized"}),
            }

        update_expr = "SET title = :t, content = :c"
        expr_values = {
            ":t": data.get("title", item["title"]),
            ":c": data.get("content", item["content"]),
        }

        # Update slug if title changed
        if "title" in data:
            new_slug = data["title"].lower().replace(" ", "-")
            update_expr += ", slug = :s"
            expr_values[":s"] = new_slug

        posts_table.update_item(
            Key={"post_id": post_id},
            UpdateExpression=update_expr,
            ExpressionAttributeValues=expr_values,
        )

        # Regenerate HTML
        updated_item = {**item, **data}
        if "title" in data:
            updated_item["slug"] = new_slug
        generate_and_upload_html(post_id, updated_item)

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "Post updated"}),
        }
    except ClientError as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }


def delete_post(post_id, claims):
    if not claims.get("cognito:username"):
        return {
            "statusCode": 403,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Authentication required"}),
        }

    try:
        response = posts_table.get_item(Key={"post_id": post_id})
        item = response.get("Item")
        if not item:
            return {
                "statusCode": 404,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Post not found"}),
            }

        if item["author"] != claims["cognito:username"] and "Admins" not in claims.get(
            "cognito:groups", []
        ):
            return {
                "statusCode": 403,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Unauthorized"}),
            }

        posts_table.delete_item(Key={"post_id": post_id})

        # Delete HTML file from S3
        try:
            s3.delete_object(Bucket=bucket, Key=f"posts/{item['slug']}.html")
        except ClientError:
            pass  # Ignore if file doesn't exist

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "Post deleted"}),
        }
    except ClientError as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }


def generate_and_upload_html(post_id, item):
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>{html.escape(item["title"])}</title>
        <link rel="stylesheet" href="/css/styles.css">
    </head>
    <body>
        <div class="container">
            <h1>{html.escape(item["title"])}</h1>
            <p>By {html.escape(item["author"])} on {item["publish_date"]}</p>
            <div class="post-content">{html.escape(item["content"])}</div>
            <div id="comments-section">
                <h3>Comments</h3>
                <div id="comments-list"></div>
            </div>
            <form id="comment-form">
                <input type="text" id="author" placeholder="Your Name" required>
                <textarea id="comment" placeholder="Your Comment" required></textarea>
                <button type="submit">Submit Comment</button>
            </form>
        </div>
        <script>
            const postId = '{post_id}';
            const apiBase = '{os.environ.get("API_BASE_URL", "")}';
        </script>
        <script src="/js/comments.js"></script>
    </body>
    </html>
    """

    s3.put_object(
        Bucket=bucket,
        Key=f"posts/{item['slug']}.html",
        Body=html_content,
        ContentType="text/html",
        ACL="public-read",
    )
