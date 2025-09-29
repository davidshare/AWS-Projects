import json
import logging
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
    logger.info(f"Processing {event['httpMethod']} request")
    logger.info(
        {
            "method": event.get("httpMethod"),
            "path": event.get("path"),
            "user": claims.get("cognito:username") if claims else "anonymous",
        }
    )
    print("Received event:", json.dumps(event))

    http_method = event.get("httpMethod", "GET")
    path_parameters = event.get("pathParameters", {}) or {}
    post_id = path_parameters.get("post_id")
    claims = event.get("requestContext", {}).get("authorizer", {}).get("claims", {})

    print(f"Method: {http_method}, Post ID: {post_id}")

    # Handle OPTIONS requests for CORS
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
        if http_method == "POST" and not post_id:
            return add_cors_headers(
                create_post(json.loads(event.get("body", "{}")), claims)
            )
        elif http_method == "GET" and post_id:
            return add_cors_headers(get_post(post_id))
        elif http_method == "GET" and not post_id:
            query_params = event.get("queryStringParameters", {}) or {}
            return add_cors_headers(list_posts(query_params))
        elif http_method == "PUT" and post_id:
            return add_cors_headers(
                update_post(post_id, json.loads(event.get("body", "{}")), claims)
            )
        elif http_method == "DELETE" and post_id:
            return add_cors_headers(delete_post(post_id, claims))
        else:
            return add_cors_headers(
                {
                    "statusCode": 400,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"error": "Invalid request"}),
                }
            )
    except Exception as e:
        print("Error:", str(e))
        return add_cors_headers(
            {
                "statusCode": 500,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": str(e)}),
            }
        )


def create_post(data, claims):
    title = data.get("title", "").strip()
    content = data.get("content", "").strip()

    if not title or len(title) > 200:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Title must be between 1-200 characters"}),
        }

    if not content or len(content) > 10000:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Content must be between 1-10000 characters"}),
        }
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

        # Input validation
        if page < 1:
            page = 1
        if limit < 1 or limit > 100:
            limit = 10

        # Calculate the starting point (simplified - in production use LastEvaluatedKey)
        start_index = (page - 1) * limit

        # For now, we'll scan but with limit - you should implement GSI in production
        response = posts_table.scan(Limit=limit)

        items = response.get("Items", [])

        # Sort by publish_date descending (most recent first)
        items.sort(key=lambda x: x.get("publish_date", ""), reverse=True)

        # Simple client-side pagination (replace with proper DynamoDB pagination in production)
        total_items = len(items)
        start_idx = (page - 1) * limit
        end_idx = start_idx + limit
        paginated_items = items[start_idx:end_idx]

        logger.info(f"Retrieved {len(paginated_items)} posts for page {page}")

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(
                {
                    "posts": paginated_items,
                    "metadata": {
                        "totalPosts": total_items,
                        "totalPages": max(1, (total_items + limit - 1) // limit),
                        "currentPage": page,
                        "postsPerPage": limit,
                    },
                }
            ),
        }
    except ValueError as e:
        logger.warning(f"Invalid pagination parameters: {params}", e)
        return {
            "statusCode": 400,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Invalid page or limit parameter"}),
        }
    except ClientError as e:
        logger.error(f"DynamoDB error: {str(e)}")
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Unable to retrieve posts"}),
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
