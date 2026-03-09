# Scalable Three-Tier AWS Cloud Architecture with Terraform

This project uses modular Terraform to build a reliable, three-tier setup on AWS. It creates a professional environment that stays online even if one data centre fails (Multi-AZ). I focused on network safety by separating the layers into public and private areas and used AWS Secrets Manager to make sure database passwords are never hard-coded or leaked in logs:

  * A custom VPC
  
  * Public and private subnets across two Availability Zones
  
  * An Application Load Balancer (ALB)
  
  * An Auto Scaling Group (ASG) with a Launch Template
  
  * Amazon RDS (MySQL)
  
  * User data automation for EC2 instances
  
  * Multi‑AZ high availability
  
  The goal of this project was to learn how real cloud infrastructure is built, deployed, and debugged.

# 🏗 Architecture Overview

__Components:__

* VPC with 2 AZs

* Public subnets for ALB

* Private subnets for EC2 + RDS

* Internet Gateway + NAT Gateway

* Application Load Balancer

* Auto Scaling Group

* Launch Template installing Apache + connecting to RDS

* RDS MySQL in private subnets

* Security Groups with least‑privilege rules

# 🏗 Architecture Diagram

```text
                                   ┌─────────────────────┐
                                   │ Route 53 (optional) │
                                   └─────────────────────┘
                                              │
                                   ┌──────────▼──────────┐
                                   │   Application LB     │
                                   │   (Public Subnets)   │
                                   └──────────┬───────────┘
                                              │
                        ┌─────────────────────┴─────────────────────┐
                        │                                           │
              ┌─────────▼─────────┐                     ┌──────────▼─────────┐
              │    EC2 Instance    │                     │    EC2 Instance    │
              │ (Auto Scaling Grp) │                     │ (Auto Scaling Grp) │
              │ Private Subnet AZ1 │                     │ Private Subnet AZ2 │
              └─────────┬─────────┘                     └─────────┬──────────┘
                        │                                           │
                        └─────────────────────┬─────────────────────┘
                                              │
                                   ┌──────────▼──────────┐
                                   │      RDS MySQL      │
                                   │   (Private Subnets) │
                                   └─────────────────────┘


VPC:
- 2 Public Subnets (ALB)
- 2 Private Subnets (EC2 + RDS)
- IGW + NAT Gateway
```

## 📂 Project Structure

```text
Highly-available-aws-webapp-terraform/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
│
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── subnets/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── security_groups/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── alb/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── asg/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── rds/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```
## 📦 Module Overview 
-  **vpc/** – Creates the base VPC, CIDR block, and core networking boundaries.
- **subnets/** – Provisions public and private subnets across multiple AZs.
- **security_groups/** – Defines all security groups for ALB, EC2 instances, and RDS.
- **alb/** – Deploys the Application Load Balancer, listeners, and target groups.
- **asg/** – Creates the Auto Scaling Group and Launch Template for EC2 instances.
- **rds/** – Deploys the MySQL RDS instance in private subnets.

# 🧩 Key Features

* Multi‑AZ load balancing

* Auto‑healing EC2 instances

* Automated DB readiness check

* Private RDS with secure access

* Clean, modular Terraform code

* Fully automated deployment

# 🐛 Troubleshooting & What I Learned

The most challenging part of this project was getting the EC2 instances to connect to the RDS database.
Through debugging, I learned how to check:

* DNS resolution

* Port 3306 connectivity

* Security group rules

* MySQL client installation on Amazon Linux 2023

* user_data execution and cloud‑init logs

* RDS authentication and permissions

Fixing this taught me how real AWS debugging works and gave me confidence in troubleshooting cloud infrastructure.

## 🚀 Deployment

1. Initialize Terraform  
   ```
   terraform init
   ```

2. Review the execution plan  
   ```
   terraform plan
   ```

3. Deploy the infrastructure  
   ```
   terraform apply
   ```

4. Destroy when finished  
   ```
   terraform destroy
   ```
# 📝 Project Overview
This project deploys a highly available web application on AWS using Terraform. It follows real-world cloud architecture patterns, including a multi‑AZ VPC, public/private subnet isolation, and an Application Load Balancer. To ensure production-grade security, I integrated AWS Secrets Manager for credential management and implemented Terraform sensitive variable masking to prevent data leaks in deployment logs. The goal is to demonstrate secure, modular infrastructure design and hands‑on cloud engineering skills.

# 📚 Future Improvements

* Add CloudWatch logging and metrics

* Add SSM Parameter Store for secrets

* Add CI/CD pipeline

* Add HTTPS with ACM

* Add Route 53 DNS
