# AWS 3-Tier Architecture with Terraform

## Table of Contents

- [AWS 3-Tier Architecture with Terraform](#aws-3-tier-architecture-with-terraform)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Architecture Overview](#architecture-overview)
  - [Prerequisites](#prerequisites)
  - [Project Structure](#project-structure)
  - [Setup and Deployment](#setup-and-deployment)
  - [Component Details](#component-details)
    - [Networking](#networking)
    - [Compute](#compute)
    - [Database](#database)
    - [Load Balancing](#load-balancing)
    - [Security](#security)
    - [Monitoring and Notifications](#monitoring-and-notifications)
  - [Security Considerations](#security-considerations)
  - [Monitoring and Scaling](#monitoring-and-scaling)
  - [Troubleshooting](#troubleshooting)
  - [Modules Sources](#modules-sources)
  - [Contributing](#contributing)
  - [License](#license)

## Introduction

This project implements a robust 3-tier architecture on AWS using Terraform. It provides a scalable, secure, and highly available infrastructure for web applications. The architecture consists of a web tier, an application tier, and a database tier, each with its own set of AWS resources and security configurations.

## Architecture Overview

The 3-tier architecture is structured as follows:

1. **Web Tier (Public)**

   - Resides in public subnets
   - Consists of EC2 instances in an Auto Scaling Group
   - Fronted by an Application Load Balancer
   - Handles incoming HTTP/HTTPS traffic

2. **Application Tier (Private)**

   - Located in private subnets
   - Comprises EC2 instances in an Auto Scaling Group
   - Accessed through an internal Application Load Balancer
   - Processes business logic and communicates with the database tier

3. **Database Tier (Private)**
   - Situated in private subnets
   - Uses Amazon RDS for MySQL with a primary and a read replica
   - Isolated from direct internet access

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) (version 1.7.5 or later)
- AWS CLI configured with appropriate credentials
- An AWS account with necessary permissions to create the required resources
- Git (for version control)

## Project Structure

The project is organized as follows:

```
.
├── environments/
│ └── stage/
│ ├── autoscaling_groups.tfvars
│ ├── autoscaling_policy.tfvars
│ ├── cloudwatch_metric_alarm.tfvars
│ ├── db_instances.tfvars
│ ├── db_parameter_groups.tfvars
│ ├── db_subnet_groups.tfvars
│ ├── elastic-ips.tfvars
│ ├── iam_role_policies.tfvars
│ ├── iam_roles.tfvars
│ ├── instance_profiles.tfvars
│ ├── internet_gateway.tfvars
│ ├── lauch_templates.tfvars
│ ├── loadbalancer_listeners.tfvars
│ ├── loadbalancer_target_groups.tfvars
│ ├── load_labalancers.tfvars
│ ├── main.tfvars
│ ├── nacl_rules.tfvars
│ ├── nacls.tfvars
│ ├── nat-gateway.tfvars
│ ├── routes.tfvars
│ ├── secretsmanager.tfvars
│ ├── security-group-rules.tfvars
│ ├── security-groups.tfvars
│ ├── sns_topics.tfvars
│ ├── sns_topic_subscriptions.tfvars
│ ├── subnets.tfvars
│ └── vpc.tfvars
├── modules/ (custom modules, if any)
├── autoscaling_groups.tf
├── autoscaling_policy.tf
├── backend-staging.tf
├── cloudwatch_metric_alarm.tf
├── db_instances.tf
├── db_parameter_groups.tf
├── db_subnet_groups.tf
├── elastic-ips.tf
├── iam_role_policies.tf
├── iam_roles.tf
├── instance_profiles.tf
├── internet-gateway.tf
├── launch_templates.tf
├── loadbalancer_listeners.tf
├── loadbalancer_target_groups.tf
├── load_balancer.tf
├── main.tf
├── nacl_rules.tf
├── nacl.tf
├── nat-gateway.tf
├── provider.tf
├── routes.tf
├── secretsmanager.tf
├── security-group-rules.tf
├── security-groups.tf
├── sns_topics.tf
├── sns_topic_subscriptions.tf
├── subnets.tf
├── vpc.tf
└── README.md

```

## Setup and Deployment

Follow these steps to set up and deploy the infrastructure:

1. **Clone the repository:**

```
git clone `git@github.com:davidshare/AWS-Projects.git`
cd `terraform/3-tier-architecture-with-modules`
```

2. **Initialize Terraform:**

```
./terraform.sh init
```

3. **Review and customize the variables in the `environments/stage/*.tfvars` files according to your requirements.**

4. **Plan the Terraform execution:**

```
./terraform.sh `<environment= dev, stage, prod>` plan
```

5. **Apply the Terraform configuration:**

```
./terraform.sh `<environment= dev, stage, prod>` apply
```

6. **Confirm the changes by typing `yes` when prompted.**

## Component Details

### Networking

- **VPC**: A custom VPC with a CIDR block of 10.0.0.0/16
- **Subnets**:
- Public subnets for the web tier
- Private subnets for the application and database tiers
- **Internet Gateway**: For public internet access
- **NAT Gateways**: For outbound internet access from private subnets
- **Route Tables**: Separate route tables for public and private subnets

### Compute

- **Auto Scaling Groups**: For web and application tiers
- **Launch Templates**: Defines the configuration for EC2 instances
- **EC2 Instances**: t2.micro instances for cost-effectiveness

### Database

- **RDS Instances**: MySQL 8.0 with a primary and read replica setup
- **DB Subnet Groups**: Defines which subnets the RDS instances can use
- **DB Parameter Groups**: Custom parameter groups for database optimization

### Load Balancing

- **Application Load Balancers**: For web and application tiers
- **Target Groups**: Associated with the Auto Scaling Groups
- **Listeners**: Configure traffic routing to target groups

### Security

- **Security Groups**: Firewall rules for each tier
- **Network ACLs**: Additional network-level security
- **IAM Roles and Policies**: Least privilege access for EC2 instances

### Monitoring and Notifications

- **CloudWatch Alarms**: For monitoring resource utilization
- **SNS Topics**: For sending notifications

## Security Considerations

- All sensitive data is stored in AWS Secrets Manager
- Security groups are configured with least privilege access
- Network ACLs provide an additional layer of security
- Private subnets are used for application and database tiers
- IAM roles follow the principle of least privilege

## Monitoring and Scaling

- CloudWatch alarms are set up to monitor CPU utilization, latency, and other metrics
- Auto Scaling policies are configured to scale in and out based on demand
- SNS topics are used for sending alerts and notifications

## Troubleshooting

If you encounter issues:

1. Check the Terraform logs for any error messages
2. Verify that your AWS credentials have the necessary permissions
3. Ensure all required variables are properly set in the .tfvars files
4. Check the AWS Console for any manual changes that might conflict with Terraform

For specific issues:

- **Connectivity problems**: Check security group and NACL rules
- **Scaling issues**: Review Auto Scaling group configurations and CloudWatch alarms
- **Database access issues**: Verify RDS security group rules and subnet configurations

## Modules Sources
[Terraform aws modules](https://github.com/davidshare/terraform-aws-modules)

## Contributing

Contributions to this project are welcome. Please follow these steps:

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to your branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
