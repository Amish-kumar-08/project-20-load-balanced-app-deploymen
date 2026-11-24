
# Project 20: Load Balanced App Deployment Using AWS and Terraform

## Overview

Deployed a load-balanced web application on AWS using Terraform.

Created two EC2 instances across different Availability Zones and configured an AWS Application Load Balancer (ALB) to distribute incoming HTTP requests between them.

Configured Nginx on both EC2 instances using User Data, created Target Groups, Security Groups, HTTP Listeners, and Health Checks.

Successfully verified that both EC2 instances were healthy and that incoming requests were distributed between both servers through the ALB DNS endpoint.

## Architecture

Internet Users
      |
      v
Application Load Balancer (ALB)
      |
      v
Target Group (HTTP Port 80)
      |
      |----------------------|
      |                      |
      v                      v
   EC2 Instance 1         EC2 Instance 2
   Nginx Web Server       Nginx Web Server
   (ap-south-1a)          (ap-south-1b)

## AWS Resources Created

| Resource | Quantity | Purpose |
|---|---:|---|
| EC2 Instances | 2 | Host the web application |
| Application Load Balancer | 1 | Distribute incoming traffic |
| Target Group | 1 | Manage EC2 targets |
| Target Group Attachments | 2 | Register EC2 instances |
| Security Groups | 2 | Control network traffic |
| HTTP Listener | 1 | Listen on port 80 |
| Health Check | 1 | Monitor instance health |

Existing default VPC and public subnets were reused.

## Technologies Used

- AWS
- Terraform
- Amazon EC2
- Application Load Balancer (ALB)
- Target Groups
- AWS Security Groups
- Amazon Linux 2023
- Nginx
- AWS CLI
- Linux

## Project Structure

```text
project-20-load-balanced-app-deployment/
│
├── main.tf
├── providers.tf
├── outputs.tf
├── user_data.sh
├── README.md
└── .terraform.lock.hcl
```

## Implementation Steps

### 1. Configure AWS Provider

Configured Terraform with the AWS provider and selected the Mumbai region (ap-south-1).

### 2. Configure Security Groups

Created two security groups:

**ALB Security Group**
- Allows incoming HTTP traffic on port 80 from the internet.
- Allows outbound traffic.

**EC2 Security Group**
- Allows incoming HTTP traffic on port 80 only from the ALB security group.
- Allows outbound traffic.

### 3. Create Two EC2 Instances

Provisioned two EC2 instances using Amazon Linux 2023 and the t3.micro instance type.

Deployed the instances in separate Availability Zones:

- ap-south-1a
- ap-south-1b

### 4. Configure Nginx Using User Data

Used a Bash User Data script to automatically:

- Update the operating system.
- Install Nginx.
- Enable and start the Nginx service.
- Create a custom HTML webpage.
- Display the EC2 instance ID on the webpage.

This allows identification of the server handling each request.

### 5. Create Target Group

Created an Application Load Balancer Target Group with:

- Protocol: HTTP
- Port: 80
- Health Check Path: /
- Success Response: HTTP 200
- Health Check Interval: 30 seconds

Registered both EC2 instances as targets.

### 6. Create Application Load Balancer

Created an internet-facing Application Load Balancer across the existing public subnets.

Configured an HTTP listener on port 80 to forward incoming requests to the target group.

### 7. Configure Health Checks

Configured ALB health checks to monitor the availability of both EC2 instances.

Both instances successfully reported Healthy status.

### 8. Test Load Balancing

Accessed the application using the Application Load Balancer DNS endpoint.

Executed multiple HTTP requests using curl to verify traffic distribution between both EC2 instances.

## Deployment Commands

Initialize Terraform:

```bash
terraform init
```

Format Terraform files:

```bash
terraform fmt
```

Validate configuration:

```bash
terraform validate
```

Preview infrastructure:

```bash
terraform plan
```

Deploy infrastructure:

```bash
terraform apply
```

View Terraform outputs:

```bash
terraform output
```

View Terraform-managed resources:

```bash
terraform state list
```

## Verification and Testing

### 1. Check Target Health

```bash
aws elbv2 describe-target-health \
  --target-group-arn "<TARGET_GROUP_ARN>" \
  --output table
```

Result: Both EC2 instances reported Healthy status.

### 2. Access Application Through ALB

```bash
curl http://<LOAD_BALANCER_DNS>
```

The application returned an HTML webpage displaying the EC2 instance ID.

### 3. Verify Traffic Distribution

```bash
for i in {1..10}; do
  curl -s http://<LOAD_BALANCER_DNS> | grep Server
done
```

**Observed Results:**

- Total HTTP requests: 10
- Server 1 responses: 5
- Server 2 responses: 5
- Both EC2 instances successfully handled requests.

This confirmed that the Application Load Balancer distributed traffic between both registered targets.

## Terraform Outputs

| Output | Value |
|---|---|
| EC2 Instance 1 | i-007d4c30b98a2b136 |
| EC2 Instance 2 | i-077aa786866cf1427 |
| Load Balancer DNS | project-20-alb-47288434.ap-south-1.elb.amazonaws.com |
| AWS Region | ap-south-1 |

## Screenshots

### 1. GitHub Repository

![GitHub Repository](screenshots/github-repository.png)

### 2. EC2 Instances Created

![EC2 Instances](screenshots/ec2-instances.png)

### 3. Application Load Balancer

![Application Load Balancer](screenshots/application-load-balancer.png)

### 4. Target Group Health Checks

![Target Group Health](screenshots/target-group-health.png)

### 5. Application Access Through ALB

![Application Output](screenshots/application-output.png)

### 6. Load Balancing Verification

![Load Balancing Test](screenshots/load-balancing-test.png)

### 7. Terraform Deployment Output

![Terraform Output](screenshots/terraform-output.png)

## Cleanup

After completing the project and capturing the required screenshots, destroy the Terraform-managed infrastructure to avoid unnecessary AWS charges.

```bash
terraform destroy
```

Confirm by typing:

```text
yes
```

## Conclusion

Successfully deployed a load-balanced web application using AWS and Terraform.

Demonstrated infrastructure automation, EC2 deployment, Application Load Balancer configuration, Target Group registration, health checks, security group configuration, and traffic distribution across multiple EC2 instances.

The project demonstrates practical knowledge of AWS networking, high availability concepts, and Infrastructure as Code (IaC).

