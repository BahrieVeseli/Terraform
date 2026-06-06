# Master Project 1 - AWS Infrastructure

<img width="1652" height="896" alt="image" src="https://github.com/user-attachments/assets/dc728841-6dae-454b-84cc-941a3db93659" />


This repository contains the Terraform code to provision the AWS infrastructure for Master Project 1. The project was completed by Gentrit, Erza, and Bahrie.

## Architecture Overview
The code automates the creation of a secure, production-ready environment for hosting a static web application. Key resources provisioned include:

- A custom VPC (10.0.0.0/16) in the eu-central-1 region.
- 6 Subnets distributed across 3 Availability Zones (3 Public, 3 Private).
- An Internet Gateway for public access and 1 NAT Gateway to allow outbound internet access for the private subnets.
- An Application Load Balancer (ALB) deployed in the public subnets.
- An Auto Scaling Group (ASG) managing EC2 instances (Amazon Linux 2023) located in the private subnets.
- A User Data script that installs Apache and automatically clones the web application from GitHub on boot.
- Security Groups implementing least privilege (EC2 instances only accept inbound traffic from the ALB).

## Usage
To run this code, you must have your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` configured in your terminal environment.

1. Initialize Terraform and download the required AWS provider:
   ```bash
   terraform init
 View the execution plan to see the resources that will be created:

```Bash
terraform plan
```
Provision the infrastructure:

```Bash
terraform apply
```
Once the apply process is complete, the terminal will output the DNS name of the Load Balancer. Open that link in your browser to view the live application.

### Cleanup
Services like the NAT Gateway and ALB incur hourly charges. To destroy the entire infrastructure and avoid unnecessary costs after testing is complete, run:

``` Bash
terraform destroy

```
