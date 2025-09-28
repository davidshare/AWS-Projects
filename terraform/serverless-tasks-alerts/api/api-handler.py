import json
import boto3
import uuid
import os
from datetime import datetime

sqs = boto3.client('sqs')

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))
    
    try:
        # Parse the request body
        if 'body' in event:
            body = json.loads(event['body'])
        else:
            body = event
        
        # Validate required fields
        required_fields = ['title', 'assigned_to']
        for field in required_fields:
            if field not in body:
                return error_response(f"Missing required field: {field}")
        
        # Create task object
        task_data = {
            'task_id': str(uuid.uuid4()),
            'title': body['title'],
            'assigned_to': body['assigned_to'],
            'due_date': body.get('due_date', ''),
            'priority': body.get('priority', 'medium'),
            'description': body.get('description', ''),
            'created_at': datetime.utcnow().isoformat(),
            'status': 'pending'
        }
        
        # Send to SQS queue
        response = sqs.send_message(
            QueueUrl=os.environ['SQS_QUEUE_URL'],
            MessageBody=json.dumps(task_data)
        )
        
        print(f"Task queued: {task_data['task_id']}")
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'status': 'success',
                'task_id': task_data['task_id'],
                'message': 'Task successfully queued for reminder'
            })
        }
        
    except Exception as e:
        print(f"Error processing request: {str(e)}")
        return error_response(f"Internal server error: {str(e)}")

def error_response(message):
    return {
        'statusCode': 400,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({
            'status': 'error',
            'message': message
        })
    }