# TaskFlow Reminders - Serverless Task Notification System

## Project Overview

TaskFlow Reminders is a production-ready serverless application built on AWS that provides automated task reminder notifications. The system accepts task submissions via REST API and delivers scheduled email reminders to team members, eliminating manual follow-up processes and reducing missed deadlines.

## Architecture

The system implements an event-driven serverless architecture using AWS services:

```
API Gateway (REST API) → AWS Lambda → Amazon SQS → AWS Lambda → Amazon SNS → Email Delivery
                                      ↑
                              EventBridge (Scheduled)
```

### Core Components

- **API Gateway**: RESTful API endpoint for task submission
- **AWS Lambda**: Serverless compute for business logic execution
- **Amazon SQS**: Message queue for reliable task processing and decoupling
- **Amazon SNS**: Pub/Sub messaging for email notification delivery
- **EventBridge**: Scheduled event triggering for daily reminders
- **IAM**: Identity and access management with least-privilege principles

## Technical Implementation

### Infrastructure as Code

The entire infrastructure is defined using Terraform, ensuring reproducible deployments and version-controlled configuration management.

### Data Flow

1. **Task Ingestion**: REST API receives task data and validates input
2. **Message Queuing**: Validated tasks are stored in SQS for reliable processing
3. **Scheduled Processing**: EventBridge triggers daily processing at 9:00 AM UTC
4. **Email Generation**: Lambda processes queued messages and formats notifications
5. **Notification Delivery**: SNS delivers formatted emails to specified recipients

## Prerequisites

- AWS Account with appropriate IAM permissions
- Terraform 1.7.5 or later
- AWS CLI configured with credentials
- Python 3.12 (for local development and testing)

## Deployment

### Initial Setup

1. Clone the repository:

```bash
git clone https://github.com/your-username/serverless-tasks-alerts.git
cd serverless-tasks-alerts
```

2. Configure environment variables in `terraform/terraform.tfvars`:

```hcl
team_emails = ["developer1@company.com", "developer2@company.com", "manager@company.com"]
project_name = "serverless-tasks-alerts"
```

### Infrastructure Deployment

1. Initialize Terraform:

```bash
cd terraform
terraform init
```

2. Review deployment plan:

```bash
terraform plan
```

3. Deploy infrastructure:

```bash
terraform apply
```

### Post-Deployment

After successful deployment, Terraform will output:

- API Gateway endpoint URL
- SQS queue URL for monitoring
- SNS topic ARN for notification management

## API Usage

### Task Submission

Submit tasks via POST request to the deployed API endpoint:

```bash
curl -X POST https://{api-gateway-id}.execute-api.{region}.amazonaws.com/prod/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Complete API documentation",
    "assigned_to": "developer@company.com",
    "due_date": "2024-01-20",
    "priority": "high",
    "description": "Document all endpoint specifications and request/response formats"
  }'
```

### Request Schema

| Field       | Type   | Required | Description    | Validation                    |
| ----------- | ------ | -------- | -------------- | ----------------------------- |
| title       | string | Yes      | Task title     | 1-255 characters              |
| assigned_to | string | Yes      | Assignee email | Valid email format            |
| due_date    | string | No       | Due date       | YYYY-MM-DD format             |
| priority    | string | No       | Task priority  | low, medium, high, urgent     |
| description | string | No       | Task details   | Optional extended description |

### Response Schema

Successful task submission returns:

```json
{
  "status": "success",
  "task_id": "uuid-generated-task-id",
  "message": "Task successfully queued for reminder"
}
```

## Email Notification Format

Recipients receive formatted daily reminders:

```
Subject: Daily Task Reminder - Monday, January 15, 2024

Hello!

Here are your pending tasks for today:

1. [HIGH] Complete API documentation - Due Today
   Documentation for all endpoint specifications

2. [MEDIUM] Code review for PR #45 - Due Tomorrow
   Review authentication middleware implementation

3. [LOW] Team meeting preparation - Due in 3 days

Total Tasks: 3

Best regards,
TaskFlow Reminders System
```

## Project Structure

```.
├── api
│   ├── api-handler.py
│   └── task-processor.py
├── readme.md
└── terraform
    ├── api-gateway.tf
    ├── events.tf
    ├── iam.tf
    ├── lambda.tf
    ├── lambda_zips
    │   ├── api-handler.zip
    │   └── task-processor.zip
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── secrets.tfvars
    ├── sns.tf
    ├── sqs.tf
    ├── terraform.tfvars
    └── variables.tf

```

## Lambda Functions

### API Handler (`api-handler.py`)

- Handles HTTP requests from API Gateway
- Validates input data and generates unique task IDs
- Interfaces with SQS for message queuing
- Returns appropriate HTTP status codes and error messages

### Task Processor (`task-processor.py`)

- Processes messages from SQS queue
- Groups tasks by assignee for batch processing
- Formats email content with priority indicators and due date calculations
- Interfaces with SNS for email delivery
- Implements error handling and retry logic

## Configuration

### Environment Variables

- `SQS_QUEUE_URL`: SQS queue URL for task submission
- `SNS_TOPIC_ARN`: SNS topic ARN for email notifications

### Scheduling

Modify the cron expression in `terraform/events.tf` to adjust reminder timing:

```hcl
schedule_expression = "cron(0 9 * * ? *)"  # 9:00 AM daily
```

## Monitoring and Logging

- **CloudWatch Logs**: Comprehensive logging for all Lambda executions
- **SQS Metrics**: Queue depth, message age, and processing statistics
- **SNS Delivery Metrics**: Email delivery success rates and failures
- **API Gateway Metrics**: Request counts, latency, and error rates

## Cost Optimization

The architecture is designed for cost efficiency:

- Pay-per-use pricing model across all services
- Minimal Lambda execution time through efficient processing
- SQS message retention configured for optimal storage costs
- Estimated monthly cost: $3-5 for typical usage patterns

## Security Considerations

- IAM roles follow principle of least privilege
- SQS policies restrict access to authorized services
- SNS topic policies enforce secure email delivery
- Input validation prevents injection attacks
- Secure handling of email addresses and task data

## Troubleshooting

### Common Issues

1. **Email Delivery Failures**

   - Verify SNS subscription confirmations
   - Check CloudWatch logs for SNS errors
   - Validate recipient email addresses

2. **Task Processing Delays**

   - Monitor SQS queue depth and message age
   - Check Lambda function concurrency limits
   - Verify EventBridge rule execution

3. **API Gateway Errors**
   - Review API Gateway access logs
   - Check Lambda function permissions
   - Validate request payload format

### Debugging

Enable detailed logging by checking CloudWatch Log Groups:

- `/aws/lambda/serverless-tasks-alerts-api-handler`
- `/aws/lambda/serverless-tasks-alerts-task-processor`

## Maintenance

### Regular Tasks

- Monitor CloudWatch metrics for abnormal patterns
- Review SQS dead letter queue for failed messages
- Update Terraform and AWS provider versions
- Rotate IAM credentials and access keys

### Scaling Considerations

The architecture automatically scales with increased load. For high-volume scenarios:

- Adjust SQS visibility timeout
- Increase Lambda function memory allocation
- Implement API Gateway caching
- Consider SQS batch processing optimizations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Implement changes with comprehensive tests
4. Submit a pull request with detailed description

## License

This project is licensed under the MIT License. See LICENSE file for details.

## Support

For technical support or questions:

- Create an issue in the GitHub repository
- Review AWS service documentation
- Consult Terraform provider documentation

---

**Built with AWS Serverless Technologies**
