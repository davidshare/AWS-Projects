# Terraform Project: VPC 3-Tier Architecture

## Architecture Overview

This Terraform project is designed to deploy a 3-tier architecture on AWS using infrastructure-as-code principles. The architecture includes a 

- **1 Virtual Private Cloud (VPC)**
- **2 public subnets for the frontend**
- **2 private subnets for the backend application**
- **2 private subnets for the database tier** 
- **1 Internet Gateway**
- **NAT Gateways**
- **security groups**
- **EC2 instances**
- **DynamoDB tables**
- **S3 buckets** 

The project is structured to support different environments, such as production and staging, with configurable variables for each environment. It also supports adding more resources using the values file.

## Project Structure

The project directory structure is organized as follows:

- **terraform/VPC-3-their-architecture**: Root directory containing the main Terraform configuration files.
  - **main.tf**: Main Terraform configuration file defining the resources and modules for the 3-tier architecture.
  - **provider.tf**: Terraform provider configuration file specifying the AWS provider and version.
  - **vpc.tf**: Terraform configuration file for creating the Virtual Private Cloud (VPC) and associated resources.
  - **subnets.tf**: Terraform configuration file for creating public and private subnets within the VPC.
  - **nat-gateways.tf**: Terraform configuration file for creating NAT Gateways for outbound internet access from private subnets.
  - **routes.tf**: Terraform configuration file for defining route tables and route associations.
  - **security-groups.tf**: Terraform configuration file for creating security groups to control inbound and outbound traffic.
  - **ec2-ssh.tf**: Terraform configuration file for launching EC2 instances with SSH access.
  - **dynamodb.tf**: Terraform configuration file for provisioning DynamoDB tables.
  - **s3.tf**: Terraform configuration file for creating S3 buckets.
  - **output.tf**: Terraform configuration file for defining output variables.
  - **terraform.sh**: Shell script for initializing and applying Terraform configurations.
  - **environments**: Directory containing environment-specific configurations.
    - **prod**: Subdirectory for production environment configurations.
      - **main.tfvars**: Terraform variables file for production environment.
      - **vpc.tfvars**: Terraform variables file for VPC configuration in production environment.
      - **subnets.tfvars**: Terraform variables file for subnets configuration in production environment.
      - **nat-gateway.tfvars**: Terraform variables file for NAT Gateway configuration in production environment.
      - **routes.tfvars**: Terraform variables file for route configuration in production environment.
      - **security-groups.tfvars**: Terraform variables file for security groups configuration in production environment.
      - **ec2-ssh.tfvars**: Terraform variables file for EC2 instance configuration in production environment.
      - **dynamodb.tfvars**: Terraform variables file for DynamoDB configuration in production environment.
      - **s3.tfvars**: Terraform variables file for S3 configuration in production environment.
      - **backend-s3.hcl**: HCL configuration file for Terraform remote backend in production environment.
    - **stage**: Subdirectory for staging environment configurations (similar structure to prod).

## Design Decisions
- **3-Tier Architecture:** The architecture is divided into three tiers: presentation (public subnet), application (private subnet), and data (private subnet) tiers, providing improved security and scalability.

- **VPC Configuration:** The VPC is designed with public and private subnets across multiple Availability Zones for high availability and fault tolerance.
- **NAT Gateways:** NAT Gateways are deployed in each public subnet to allow instances in private subnets to access the internet while maintaining security.
- **Security Groups:** Security groups are used to control inbound and outbound traffic to EC2 instances, DynamoDB tables, and S3 buckets, ensuring only necessary connections are allowed.
- **DynamoDB and S3:** DynamoDB tables and S3 buckets are provisioned to store and manage data for the application, providing scalable and durable storage solutions.
- **State Locking:** DynamoDB is used for locking Terraform state to prevent concurrent modifications and ensure consistency during deployments.
- **State Storage:** Terraform state is stored in an S3 bucket to provide a centralized location for managing state files and enabling collaboration among team members.


# Prerequisites
* An AWS Account with an IAM user capable of creating resources – `AdminstratorAccess`
* A locally configured AWS profile for the above IAM user
* Terraform installation - [steps](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* AWS EC2 key pair - [steps](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
* Environment Variables for AWS CLI - [steps](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
* tfupdate installation - [steps](https://github.com/antonbabenko/pre-commit-terraform#how-to-install)
* tfsec installation - [steps](https://github.com/antonbabenko/pre-commit-terraform#how-to-install)

## Requirements
| Name          | Version       |
| ------------- |:-------------:|
| terraform     | ~>1.7.5       |
| aws           | ~>5.43.0      |

## Providers
| Name          | Version       |
| ------------- |:-------------:|
| aws           | ~>5.43.0      |

# How to deploy
# Todo

To deploy the 3-tier architecture using Terraform:

1. Clone this repository to your local machine.
2. Navigate to the `terraform/VPC-3-their-architecture` directory.
3. Update the Terraform variable files (`*.tfvars`) in the `environments` directory with your desired configuration for each environment (e.g., production, staging).
4. Run the `terraform.sh` script to initialize Terraform and apply the configurations:

```bash
./terraform.sh apply <environment>
```

Replace <environment> with the name of the environment you want to deploy (e.g., prod, stage).

# How to destroy
# Todo

## Resources
| Name          | Type       |
| ------------- |:-------------:|
| [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_launch_template) | resource |
| [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_db_instance) | resource |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_vpc) | resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_subnet) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_internet_gateway) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_route_table) | resource |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_route_table_association) | resource |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_lb) | resource |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_lb_listener) | resource |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_lb_target_group) | resource |
| [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_autoscaling_group) | resource |
| [aws_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_db_subnet_group) | resource |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_security_group) | resource |

## Contributors
[David Essien](https://github.com/davidshare) - Project Lead & Maintainer