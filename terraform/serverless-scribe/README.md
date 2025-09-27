# ServerlessScribe: A Serverless Personal Blog on AWS


[![AWS](https://img.shields.io/badge/AWS-Serverless-orange?style=flat&logo=amazon-aws)](https://aws.amazon.com/serverless/)
[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
[![Python](https://img.shields.io/badge/Python-3.12-blue?style=flat&logo=python)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

ServerlessScribe is a fully serverless personal blogging platform built on AWS, designed for freelance writers to share articles, engage with readers through comments, and manage content securely without managing servers. It leverages AWS's serverless ecosystem for scalability, cost-efficiency, and high availability. Static content is hosted on Amazon S3 for fast delivery, while dynamic features like comments and authenticated post management are powered by AWS Lambda, Amazon DynamoDB, Amazon API Gateway, and Amazon Cognito.

This project serves as an excellent portfolio piece for AWS certifications or job applications, demonstrating expertise in serverless architecture, Infrastructure as Code (IaC) with Terraform, secure authentication, and full-stack development with Python and JavaScript.

Key highlights:

- **Serverless First**: No EC2 instances or managed servers—pay only for what you use.
- **Secure by Design**: Role-based access control (RBAC) with Cognito, restricting account creation and content management to owners.
- **Dynamic yet Static**: Posts are stored in DynamoDB and rendered as static HTML on S3 for optimal performance.
- **Production-Ready**: Includes best practices for security, monitoring, and deployment.

## Features

### Public Features

- **Blog Post Grid View**: Home page displays all published posts in a responsive grid layout, with cards showing title, author, and publish date. Clicking a card navigates to the full post.
- **Post Viewing**: Individual post pages with content, metadata, and a comments section.
- **Comments System**: Readers can submit and view comments without authentication (public engagement).
- **Responsive Design**: Mobile-friendly UI with CSS grid for post listings.

### Authenticated Features

- **User Authentication**: Secure signup (admin-only) and login via Amazon Cognito.
- **Admin Dashboard**: Paginated list of posts with CRUD operations (Create, Read, Update, Delete).
- **Post Management**: Create new posts, edit existing ones, or delete them. Changes automatically generate and upload static HTML to S3.
- **User Management**: Owners (in 'Admins' group) can create new user accounts (e.g., for additional authors) via the dashboard.
- **RBAC**: Authors can manage their own posts; owners have full access, including user creation.

### Technical Features

- **Infrastructure as Code**: Fully provisioned with Terraform for reproducible deployments.
- **API Security**: Cognito JWT authorizer on protected API endpoints.
- **Data Persistence**: DynamoDB for posts and comments (pay-per-request billing).
- **Static Hosting**: S3 with website hosting enabled, public read policy.
- **Frontend**: Vanilla HTML/CSS/JS for simplicity and performance—no heavy frameworks.
- **Extensibility**: Easy to add features like email notifications (SES) or moderation (Comprehend).

## Architecture

The architecture follows AWS Well-Architected Framework principles: serverless, secure, resilient, and cost-optimized.

![Architecture Diagram](https://via.placeholder.com/800x400?text=Architecture+Diagram)

- **Frontend**: Static files (HTML, CSS, JS) hosted on S3. Public access for viewing; admin pages handle auth client-side.
- **Backend APIs**:
  - **Authentication**: Cognito User Pools for sign-in/signup. Lambda handles admin user creation.
  - **Posts API**: CRUD operations via API Gateway → Lambda → DynamoDB/S3.
  - **Comments API**: Public POST/GET via API Gateway → Lambda → DynamoDB.
- **Data Flow**:
  1. Public user browses S3-hosted site, views posts/comments via API calls.
  2. Admin logs in (Cognito), manages posts/users via protected APIs.
  3. Post changes trigger Lambda to update DynamoDB and regenerate S3 files.
- **Security**: IAM roles for Lambda, Cognito authorizers, no client-side secrets.
- **Monitoring**: Integrate CloudWatch Logs/Metrics (not in base Terraform; add as extension).
- **Scalability**: All services auto-scale; S3 handles global traffic via CloudFront (optional).

## Prerequisites

- **AWS Account**: Free tier eligible for low usage. Sign up at [aws.amazon.com](https://aws.amazon.com).
- **AWS CLI**: Installed and configured (`aws configure`).
- **Terraform**: Version 1.5+ installed ([download here](https://www.terraform.io/downloads.html)).
- **Python 3.12+**: For Lambda code (if modifying locally).
- **Node.js** (optional): For local JS testing.
- **Git**: To clone the repository.

Ensure your AWS IAM user has permissions for: Cognito, DynamoDB, S3, Lambda, API Gateway, IAM.

## Installation and Deployment

### Step 1: Clone the Repository

```bash
git clone git@github.com:davidshare/AWS-Projects.git
cd terraform/serverless-scribe
```

### Step 2: Configure Terraform

Edit `terraform/variables.tf` or create a terraform.tfvars file:

```
region      = "us-east-1"
bucket_name = "your-unique-bucket-name"  # Must be globally unique
```

### Step 3: Deploy with Terraform

```
cd terraform
terraform init
terraform plan  # Review changes
terraform apply --auto-approve
```

This provisions all resources. Note outputs like website_endpoint (S3 site URL), api_endpoint (API Gateway), user_pool_id, and app_client_id.
Update frontend JS files (auth.js, etc.) with apiBase and clientId from outputs.

### Step 4: Upload Frontend to S3

aws s3 sync ../frontend s3://your-unique-bucket-name --acl public-read

### Step 5: Create Initial Owner Account

Use AWS CLI (replace with your values):

```
aws cognito-idp admin-create-user --user-pool-id <user_pool_id> --username owner@example.com --user-attributes Name=email,Value=owner@example.com
aws cognito-idp admin-set-user-password --user-pool-id <user_pool_id> --username owner@example.com --password YourStrongPassword123! --permanent
aws cognito-idp admin-add-user-to-group --user-pool-id <user_pool_id> --username owner@example.com --group-name Admins
```

### Step 6: Access the Blog

Public Site: `http://<bucket_name>.s3-website-<region>.amazonaws.com/index.html`
Admin Dashboard: `/admin.html` (login with owner credentials)

### Usage

#### Public Users

- Visit the home page to see a grid of posts.
- Click a post card to view full content and comments.
- Submit comments via the form (no login required).

Authenticated Users (Authors/Owners)

- Log in on /admin.html.
- View paginated post list in a table.
- Create posts via form—automatically publishes to S3.
- Edit/Delete posts with buttons.
- Owners: Create new users via the "Manage Users" form (sends invite email).

#### API Endpoints (for Reference)

- `POST /auth/login`: Authenticate user.
- `POST /users:` Create user (admin-only).
- `GET/POST/PUT/DELETE/posts/{post_id}`: Post CRUD.
- `GET/POST /comments/{post_id}`: Comments.

### Local Development

- Lambda Testing: Use AWS SAM CLI (sam local invoke) or test in AWS Console.
- Frontend: Serve locally with python -m http.server and test JS in browser.
- Terraform: Use terraform validate and terraform fmt.

### Testing

- Unit Tests: Add Python tests for Lambda (e.g., pytest in a tests/ dir—not included; implement as extension).
- Integration Tests: Use Postman for API endpoints.
- E2E Tests: Manual: Create post, verify S3 file, add comment, check DynamoDB.
- Security Scans: Run terraform plan with tfsec or Checkov.

### Monitoring and Maintenance

- Logs: CloudWatch Logs for Lambda/API Gateway.
- Metrics: Enable CloudWatch alarms for errors/throttling.
- Costs: Monitor via AWS Cost Explorer—expect < $1/month for low traffic.
- Updates: Rerun terraform apply for changes; sync frontend as needed.
- Cleanup: terraform destroy to remove all resources.

### Troubleshooting

- Cognito Errors: Verify app client settings; check email for invites.
- API 403: Ensure Cognito authorizer is configured; token expired?
- S3 Access Denied: Check bucket policy.
- Lambda Failures: Inspect CloudWatch Logs for tracebacks.

For issues, open a GitHub issue with logs/screenshots.

### Contributing
Contributions welcome! Fork the repo, create a feature branch, and submit a PR. Follow code style (PEP8 for Python, ESLint for JS). Add tests for new features.

### License
This project is licensed under the MIT License. See LICENSE for details.