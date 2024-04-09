# Terraform Project: 3-tier architecture with autoscaling group and loadbalancing
## Architecture Overview
![image Architecture diagram for AWS 3-tier architecture with Autoscaling](../../images/AWS%203-tier%20architecture%20with%20Autoscaling.svg)

This Terraform project is designed to deploy a 3-tier architecture with Autoscaling on AWS using infrastructure-as-code principles. The architecture includes:

- **1 AWS keypair**
- **1 DynamoDB table**
- **1 S3 bucket**
- **Autoscaling groups for the frontend and backend tiers**
- **Elastic Load Balancers for the frontend and backend tiers**
- **listeners and target groups for the loadbalancers**
- **RDS instances**

The project is structured to support different environments, such as production and staging, with configurable variables for each environment. It also supports adding more resources using the values file.

## Project Structure
```
.
├── autoscaling-groups.tf
├── database.tf
├── dynamodb.tf
├── ec2-ssh.tf
├── elastic-loadbalancer.tf
├── environments
│   ├── prod
│   │   ├── autoscaling-groups.tfvars
│   │   ├── backend-s3.hcl
│   │   ├── dynamodb.tfvars
│   │   ├── ec2-ssh.tfvars
│   │   ├── elastic-loadbalancer.tfvars
│   │   ├── main.tfvars
│   │   ├── s3.tfvars
│   │   └── terraform.tfvars
│   └── stage
│       ├── autoscaling-groups.tfvars
│       ├── backend-s3.hcl
│       ├── dynamodb.tfvars
│       ├── ec2-ssh.tfvars
│       ├── elastic-loadbalancer.tfvars
│       ├── main.tfvars
│       ├── s3.tfvars
│       └── terraform.tfvars
├── files
│   ├── deploy-backend.sh
│   └── deploy-frontend.sh
├── main.tf
├── output.tf
├── provider.tf
├── README.md
├── s3.tf
├── security-groups.tf
└── terraform.sh
```

The project directory structure is organized as follows:

- **terraform/Autoscaling-3-tier-architecture**: Root directory containing the main Terraform configuration files.
  - **main.tf**: Main Terraform configuration file defining the resources and modules for the 3-tier architecture with Autoscaling.
  - **provider.tf**: Terraform provider configuration file specifying the AWS provider and version.
  - **autoscaling-groups.tf**: Terraform configuration file for creating Autoscaling Groups for the frontend and backend tiers.
  - **elastic-loadbalancer.tf**: Terraform configuration file for creating Elastic Load Balancers for the frontend and backend tiers.
  - **database.tf**: Terraform configuration file for creating the database tier resources.
  - **ec2-ssh.tf**: Terraform configuration file for launching EC2 instances with SSH access.
  - **dynamodb.tf**: Terraform configuration file for provisioning DynamoDB tables.
  - **s3.tf**: Terraform configuration file for creating S3 buckets.
  - **security-groups.tf**: Terraform configuration file for defining security groups.
  - **output.tf**: Terraform configuration file for defining output variables.
  - **terraform.sh**: Shell script for initializing and applying Terraform configurations.
  - **environments**: Directory containing environment-specific configurations.
    - **prod**: Subdirectory for production environment configurations.
      - **main.tfvars**: The values file for production environment.
      - **autoscaling-groups.tfvars**: The values file for Autoscaling Groups configuration in production environment.
      - **elastic-loadbalancer.tfvars**: The values file for Elastic Load Balancers configuration in production environment.
      - **ec2-ssh.tfvars**: The values file for EC2 instance configuration in production environment.
      - **dynamodb.tfvars**: the values file for DynamoDB configuration in production environment.
      - **s3.tfvars**: The values file for S3 configuration in production environment.
      - **backend-s3.hcl**: HCL configuration file for Terraform remote backend in production environment.
    - **stage**: Subdirectory for staging environment configurations (similar structure to prod).
  - **files**: Directory containing scripts for deploying the frontend and backend applications.

## Design Decisions
- **3-Tier Architecture:** The architecture is divided into three tiers: web (public subnet), application (private subnet), and data (private subnet) tiers, providing improved security and scalability.
- **Autoscaling Groups:** Autoscaling Groups are used for the frontend and backend tiers to automatically scale the infrastructure based on demand.
- **Elastic Load Balancers:** Elastic Load Balancers are used to distribute traffic across the instances in the Autoscaling Groups.
- **State Locking:** DynamoDB is used for locking Terraform state to prevent concurrent modifications and ensure consistency during deployments.
- **State Storage:** Terraform state is stored in an S3 bucket to provide a centralized location for managing state files and enabling collaboration among team members.

# Prerequisites
* An AWS Account with an IAM user capable of creating resources – `AdminstratorAccess`
* A locally configured AWS profile for the above IAM user
* Terraform installation - [steps](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* AWS EC2 key pair - [steps](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
* Environment Variables for AWS CLI - [steps](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

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

To deploy the 3-tier architecture with Autoscaling using Terraform:

1. Clone this repository to your local machine 
```bash
  git clone git@github.com:davidshare/AWS-Projects.git
```
2. Navigate to the project directory
```bash
  terraform/autoscaling-3-their-architecture` directory.
```
3. Update the Terraform variable files (`*.tfvars`) in the `environments` directory with your desired configuration for each environment (e.g., production, staging).
   
4. Run the `terraform.sh` script to initialize Terraform:

```bash
./terraform.sh <environment> init
```

Replace `<environment>` with the name of the environment you want to deploy (e.g., prod, stage).

5. Run the plan command to view the planned changes

```bash
./terraform.sh <environment> plan
```

6. Run the apply command to apply the proposed changes

```bash
./terraform.sh <environment> apply
```

7. Run the destroy command to destroy all resources

```bash
./terraform.sh <environment> destroy
```

## Terraform Resources
| Name          | Type       |
| ------------- |:-------------:|
| [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_autoscaling_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |

## Contributors
[David Essien](https://github.com/davidshare) - Maintainer