# Terraform Mini Project – AWS Production Infrastructure

## Project Overview

This project uses Terraform to provision AWS infrastructure for hosting a web application on an EC2 instance. It follows Infrastructure as Code (IaC) practices to create and manage AWS resources automatically.

The project creates a custom VPC, public subnet, Internet Gateway, route table, security group, network interface, Elastic IP, and EC2 instance. A shell script (`facebook.sh`) is used as EC2 user data to configure the application during instance launch.

## Architecture

```text
                    Internet
                        |
                 Elastic IP (EIP)
                        |
                 EC2 Instance
                 (PROD_SERVER)
                        |
                Network Interface
                  (10.81.3.33)
                        |
                  Security Group
                   (PROD_SG)
                        |
                  Public Subnet
                  (10.81.3.0/24)
                        |
                   Route Table
                    (PROD_RT)
                        |
                 Internet Gateway
                    (PROD_IGW)
                        |
                    Custom VPC
                  (10.81.0.0/16)
```

## AWS Resources Created

- **VPC:** Creates a custom VPC with CIDR block `10.81.0.0/16`.
- **Internet Gateway:** Provides an internet gateway for the VPC.
- **Route Table:** Adds a default route (`0.0.0.0/0`) through the Internet Gateway.
- **Public Subnet:** Creates a subnet with CIDR block `10.81.3.0/24`.
- **Route Table Association:** Associates the route table with the public subnet.
- **Security Group:** Allows inbound SSH (22), HTTP (80), and HTTPS (443) traffic.
- **Network Interface:** Creates a network interface with private IP `10.81.3.33`.
- **Elastic IP:** Assigns a public IPv4 address to the network interface.
- **EC2 Instance:** Launches a `t2.micro` instance to host the web application.
- **User Data:** Executes `facebook.sh` during instance initialization.

## Technologies Used

- AWS
- Terraform
- Amazon EC2
- Amazon VPC
- Internet Gateway
- Security Groups
- Elastic IP
- Linux
- Shell Scripting
- Git and GitHub

## Project Files

```text
Terraform-Mini-Project/
└── 15-OCT-26/
    ├── main.tf
    ├── facebook.sh
    ├── README.md
    └── .gitignore
```

## Prerequisites

Before running this project, ensure you have:

- An AWS account with the required permissions.
- AWS CLI installed and configured.
- Terraform installed.
- An existing EC2 key pair named `karthikkey` in the `us-east-1` region.
- A valid Amazon Linux AMI ID for the selected region.

## Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/karthikpatelmarkhale/Terraform_Mini_Project.git
cd Terraform_Mini_Project/15-OCT-26
```

### 2. Configure AWS Credentials

```bash
aws configure
```

Enter your AWS access key, secret key, default region (`us-east-1`), and preferred output format when prompted. Never commit AWS credentials to GitHub.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Validate the Configuration

```bash
terraform validate
```

### 5. Review the Execution Plan

```bash
terraform plan
```

### 6. Create the Infrastructure

```bash
terraform apply
```

Review the plan and type `yes` when prompted.

### 7. Access the Application

After Terraform completes successfully, retrieve the Elastic IP from the output:

```bash
terraform output fb-eip
```

Open the public IP address in your browser:

```text
http://YOUR_ELASTIC_IP
```

Ensure the `facebook.sh` script installs and starts a web server and writes the application page to the appropriate web root.

## Cleanup

To delete the AWS resources created by Terraform, run:

```bash
terraform destroy
```

Review the destruction plan and confirm when prompted. Ensure you are using the correct Terraform working directory and state file before destroying resources.

## Security Considerations

- SSH (port 22) is currently open to all IPv4 addresses (`0.0.0.0/0`). For better security, restrict SSH access to your own public IP.
- Keep AWS credentials, private keys, Terraform state files, and sensitive variable files out of GitHub.
- Use an appropriate AMI for the selected AWS region.
- Review AWS costs before deploying and remove unused resources after practice.

## Learning Outcomes

- Understanding Infrastructure as Code using Terraform.
- Creating AWS networking resources.
- Configuring public subnet connectivity.
- Attaching a network interface and Elastic IP to an EC2 instance.
- Configuring an EC2 instance using user data.
- Managing the infrastructure lifecycle using Terraform.

## Author

**Karthik Patel**

GitHub: https://github.com/karthikpatelmarkhale
