# Terraform Project: VPC 3-Tier Architecture

## Architecture Overview
![image Architecture diagram for AWS 3-tier architecture](../../images/AWS%203-tier%20architecture.svg)

This Terraform project is designed to deploy a 3-tier architecture on AWS using infrastructure-as-code principles. The architecture includes a 

- **1 AWS keypair**
- **1 DynamoDB table**
- **1 S3 bucket** 
- **1 Virtual Private Cloud (VPC)**
- **2 Public subnets for the frontend**
- **2 Private subnets for the backend application**
- **2 Private subnets for the database tier** 
- **1 Internet Gateway**
- **2 Elastic IPs for the NAT gateways**
- **2 NAT Gateways for each availability zone**
- **2 route tables**
- **2 route tables associations for the subnets, internet gateway, and NAT gateways**

The project is structured to support different environments, such as production and staging, with configurable variables for each environment. It also supports adding more resources using the values file.

## Project Structure
```
├── dynamodb.tf
├── ec2-ssh.tf
├── environments
│   ├── prod
│   │   ├── backend-s3.hcl
│   │   ├── dynamodb.tfvars
│   │   ├── ec2-ssh.tfvars
│   │   ├── elastic-ips.tfvars
│   │   ├── internet-gateway.tfvars
│   │   ├── main.tfvars
│   │   ├── nat-gateway.tfvars
│   │   ├── routes.tfvars
│   │   ├── s3.tfvars
│   │   ├── subnets.tfvars
│   │   ├── terraform.tfvars
│   │   └── vpc.tfvars
│   └── stage
│       ├── backend-s3.hcl
│       ├── dynamodb.tfvars
│       ├── ec2-ssh.tfvars
│       ├── elastic-ips.tfvars
│       ├── internet-gateway.tfvars
│       ├── main.tfvars
│       ├── nat-gateway.tfvars
│       ├── routes.tfvars
│       ├── s3.tfvars
│       ├── subnets.tfvars
│       ├── terraform.tfvars
│       └── vpc.tfvars
├── internet-gateway.tf
├── main.tf
├── nat-gateways.tf
├── output.tf
├── provider.tf
├── README.md
├── routes.tf
├── s3.tf
├── subnets.tf
├── terraform.sh
└── vpc.tf
```

The project directory structure is organized as follows:

- **terraform/VPC-3-their-architecture**: Root directory containing the main Terraform configuration files.
  - **main.tf**: Main Terraform configuration file defining the resources and modules for the 3-tier architecture.
  - **provider.tf**: Terraform provider configuration file specifying the AWS provider and version.
  - **vpc.tf**: Terraform configuration file for creating the Virtual Private Cloud (VPC) and associated resources.
  - **subnets.tf**: Terraform configuration file for creating public and private subnets within the VPC.
  - **nat-gateways.tf**: Terraform configuration file for creating NAT Gateways for outbound internet access from private subnets.
  - **internet-gateway.tf**: Terraform configuration file for creating Internet Gateways for inbound internet access to the vpc.
  - **elastic-ips.tf**: Terraform configuration for creating elastic ips
  - **routes.tf**: Terraform configuration file for defining route tables and route associations.
  - **ec2-ssh.tf**: Terraform configuration file for launching EC2 instances with SSH access.
  - **dynamodb.tf**: Terraform configuration file for provisioning DynamoDB tables.
  - **s3.tf**: Terraform configuration file for creating S3 buckets.
  - **output.tf**: Terraform configuration file for defining output variables.
  - **terraform.sh**: Shell script for initializing and applying Terraform configurations.
  - **environments**: Directory containing environment-specific configurations.
    - **prod**: Subdirectory for production environment configurations.
      - **main.tfvars**: The values file for production environment.
      - **vpc.tfvars**: The values file for VPC configuration in production environment.
      - **subnets.tfvars**: The values file for subnets configuration in production environment.
      - **nat-gateway.tfvars**: The values file for NAT Gateway configuration in production environment.
      - **nat-gateway.tfvars**: The values file for Internet Gateway configuration in production environment.
      - **elastic-ips.tfvars**: The values file for elastic ips
      - **routes.tfvars**: The values file for route configuration in production environment.
      - **security-groups.tfvars**: The values file for security groups configuration in production environment.
      - **ec2-ssh.tfvars**: The values file for EC2 instance configuration in production environment.
      - **dynamodb.tfvars**: the values file for DynamoDB configuration in production environment.
      - **s3.tfvars**: The values file for S3 configuration in production environment.
      - **backend-s3.hcl**: HCL configuration file for Terraform remote backend in production environment.
    - **stage**: Subdirectory for staging environment configurations (similar structure to prod).

## Design Decisions
- **3-Tier Architecture:** The architecture is divided into three tiers: web (public subnet), application (private subnet), and data (private subnet) tiers, providing improved security and scalability.

- **VPC Configuration:** The VPC is designed with public and private subnets across multiple Availability Zones for high availability and fault tolerance.
- **NAT Gateways:** NAT Gateways are deployed in each public subnet to allow instances in private subnets to access the internet while maintaining security.
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
# Todo

To deploy the 3-tier architecture using Terraform:

1. Clone this repository to your local machine 
```bash
  git clone git@github.com:davidshare/AWS-Projects.git
```
2. Navigate to the project directory
```bash
  terraform/VPC-3-their-architecture` directory.
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
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |

## Contributors
[David Essien](https://github.com/davidshare) - Maintainer