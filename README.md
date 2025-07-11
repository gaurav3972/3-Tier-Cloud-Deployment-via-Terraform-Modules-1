# 🚀3-Tier-Cloud-Deployment-via-Terraform-Modules

## 📘 Introduction

This project showcases how to build and deploy a **three-tier cloud infrastructure** on **Amazon Web Services (AWS)** using **Terraform modules**. It adopts best practices of Infrastructure as Code (IaC) to ensure the infrastructure is **modular**, **scalable**, and **secure**.

---
![](https://github.com/gaurav3972/3-Tier-Cloud-Deployment-via-Terraform-Modules-1/blob/main/Photos/terraform%20main.png)
## 📊 Project Summary/Overview

This architecture implements the widely used **three-tier design pattern**, separating resources into the **Web Tier**, **Application Tier**, and **Database Tier**. Each tier is:

- Deployed in a **separate subnet** to maintain isolation
- Secured with **custom security groups** provisioned by Terraform
- Managed through **modular, reusable Terraform configurations**
---
## 🏗️ Architecture Blueprint

### 1️⃣ Web Layer
- Hosted within **public subnets**
- Runs EC2 instances configured with web servers like **Apache** or **Nginx**
- Open to the internet via **HTTP, HTTPS**, and **SSH** for administrative access

### 2️⃣ Application Layer
- Deployed in **private subnets** for internal use
- Contains EC2 instances that handle backend logic (e.g., services written in **Node.js**, **Python**, etc.)
- Communicates **only** with the Web and Database layers
- **No direct exposure** to the internet for enhanced security

### 3️⃣ Database Layer
- Located in **private subnets**
- Uses **Amazon RDS (MySQL)** for managed relational database services
- Network access is **restricted exclusively** to the Application Layer

---
## 🌐 Network Architecture

- A dedicated **Virtual Private Cloud (VPC)** for full network isolation
- **Public subnets** provisioned for the Web Layer to allow internet access
- **Private subnets** configured for the Application and Database Layers
- An **Internet Gateway (IGW)** enables inbound/outbound traffic to the Web Layer
- A **NAT Gateway** allows instances in private subnets to access the internet securely
- **Route tables** are configured to ensure correct traffic flow between layers


## 🔐 Security Groups

| Layer         | Inbound Access From               |
|---------------|-----------------------------------|
| Web Tier      | HTTP/HTTPS/SSH from internet      |
| App Tier      | Custom port (e.g., 8080) from Web |
| Database Tier | MySQL (3306) from App Tier        |

---

## 📁 Project Structure

```

3-tier-terraform/
├── main.tf               # Root Terraform file invoking modules
├── variables.tf          # Input variable definitions
├── outputs.tf            # Output variable definitions
├── terraform.tfvars      # Actual variable values
│
├── modules/
│   ├── vpc/              # VPC, Subnets, NAT, IGW
│   ├── web/              # EC2 instance setup for Web Tier
│   ├── app/              # EC2 instance setup for App Tier
│   ├── db/               # RDS MySQL instance setup
│   └── security/         # Security Groups for all tiers

````

---

## 🛠 Getting Started with Terraform in VS Code

### 1. Set Up Project Workspace
- Navigate to your **Desktop** and create a new directory called: `three-tier-aws`.
- Open this directory using Visual Studio Code.

### 2. Initialize the Root Configuration
Inside the `three-tier-aws` folder, create these Terraform configuration files:
- `main.tf` – Entry point for Terraform code
- `variables.tf` – Declares input variables
- `outputs.tf` – Declares output values
- `terraform.tfvars` – Provides values for variables

### 3. Organize Terraform Modules
Create a folder named `modules` within `three-tier-aws`. Inside the `modules` folder, define subfolders for each component:
- `vpc/`
- `web/`
- `application/`
- `database/`
- `security/`

Each of these module directories should include:
- `main.tf`
- `variables.tf`
- `outputs.tf`

### 4. Initialize the Terraform Backend
Run the following command in the terminal to initialize the project:

```bash
terraform init

## 📂 Step 1: Open Root Directory

1. Open the folder `3-tier-terraform` in **Visual Studio Code**.
2. You should see the following structure:


```

3-tier-terraform/
├── main.tf               # Root Terraform file invoking modules
├── variables.tf          # Input variable definitions
├── outputs.tf            # Output variable definitions
├── terraform.tfvars      # Actual variable values
├── backend.tf            # Optional backend config for remote state (S3/DynamoDB)
│
├── modules/
│   ├── vpc/              # VPC, Subnets, NAT, IGW
│   ├── web/              # EC2 instance setup for Web Tier
│   ├── app/              # EC2 instance setup for App Tier
│   ├── db/               # RDS MySQL instance setup
│   └── security/         # Security Groups for all tiers

````
---

## ✍️ Step 2: Add Code to Root Files

### 🔹 main.tf (Root)

Open `main.tf` and add:

```hcl
terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
 
# Configure the AWS Provider
provider "aws" {
  region = var.region
}
module "vpc" {
  source    = "./modules/vpc"
  region = var.region
  vpc_cidr  = var.vpc_cidr
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "web" {
  source             = "./modules/web"
  public_subnets     = module.vpc.public_subnets
  ami_id             = var.web_ami
  instance_type      = var.web_instance_type
  security_group_id  = module.security.web_sg_id
}

module "app" {
  source             = "./modules/app"
  private_subnets    = module.vpc.app_subnets
  ami_id             = var.app_ami
  instance_type      = var.app_instance_type
  security_group_id  = module.security.app_sg_id
}

module "db" {
  source             = "./modules/db"
  db_subnets         = module.vpc.db_subnets
  db_username        = var.db_username
  db_password        = var.db_password
  security_group_id  = module.security.db_sg_id
}
```
### 🔹 variables.tf (Root)

Open `variables.tf` and add:

```hcl
variable "region" {}
variable "vpc_cidr" {}
variable "web_ami" {}
variable "web_instance_type" {}
variable "app_ami" {}
variable "app_instance_type" {}
variable "db_username" {}
variable "db_password" {}

```
### 🔹 outputs.tf (Root)

Open `variables.tf` and add:

```hcl
output "web_instance_ids" {
  value = module.web.instance_ids
}

output "app_instance_ids" {
  value = module.app.instance_ids
}

output "db_endpoint" {
  value = module.db.db_endpoint
}
```
### 🔹 terraform.tfvars (Root)

Open `terraform.tf` and add:

```hcl
vpc_cidr = "10.0.0.0/16"
region = "ap-south-1"
web_ami = "ami-0e35ddab05955cf57"
app_ami = "ami-0e35ddab05955cf57"
web_instance_type = "t2.micro"
app_instance_type = "t2.micro"
db_username = "admin"
db_password = "Pass$123"
```

## 🧱 Step 3: Add Code to Modules

### 🔹 main.tf (module/vpc)

open `modules/vpc/main.tf` and add:

```hcl
  resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_subnet" "app" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_subnet" "db" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + 4)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

data "aws_availability_zones" "available" {}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "app_subnets" {
  value = aws_subnet.app[*].id
}

output "db_subnets" {
  value = aws_subnet.db[*].id
}

```
### 🔹 variables.tf (module/vpc)

open `modules/vpc/variables.tf` and add:

```hcl
variable "vpc_cidr" {}
variable "region" {}
```
### 🔹 main.tf (module/security)

open `modules/security/main.tf` and add:

```hcl
resource "aws_security_group" "web_sg" {
  name = "web-sg"
  description = "Allow HTTP"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name = "app-sg"
  description = "Allow from Web"
  vpc_id = var.vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name = "db-sg"
  description = "Allow MySQL from App"
  vpc_id = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

```
### 🔹 variables.tf (module/security)

open `modules/security/variables.tf` and add:

```hcl
variable "vpc_id" {}
```
### 🔹 main.tf (module/web)

open `modules/web/main.tf` and add:

```hcl
resource "aws_instance" "web" {
  count = 2
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = element(var.public_subnets, count.index)
  vpc_security_group_ids = [var.security_group_id]
  tags = { Name = "web-${count.index+1}" }
}

output "instance_ids" {
  value = aws_instance.web[*].id
}


```
### 🔹 variables.tf (module/web)

open `modules/web/variables.tf` and add:

```hcl
variable "ami_id" {}
variable "instance_type" {}
variable "public_subnets" {}
variable "security_group_id" {}

```
### 🔹 main.tf (module/app)

open `modules/app/main.tf` and add:

```hcl
resource "aws_instance" "app" {
  count = 2
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = element(var.private_subnets, count.index)
  vpc_security_group_ids = [var.security_group_id]
  tags = { Name = "app-${count.index+1}" }
}

output "instance_ids" {
  value = aws_instance.app[*].id
}

```
### 🔹 variables.tf (module/app)

open `modules/app/variables.tf` and add:

```hcl
variable "ami_id" {} 
variable "instance_type" {}
variable "private_subnets" {}
variable "security_group_id" {}
```
### 🔹 variables.tf (module/db)

open `modules/db/main.tf` and add:

```hcl
resource "aws_db_subnet_group" "db" {
  name       = "db-subnet-group"
  subnet_ids = var.db_subnets
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  #name                 = "appdb"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible = false
}

output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

```
### 🔹 variables.tf (module/db)

open `modules/db/variables.tf` and add:

```hcl
variable "db_subnets" {}
variable "db_username" {}
variable "db_password" {}
variable "security_group_id" {}
  
```

---

## 🛠 Tools Used

| Tool         | Purpose                        |
|--------------|--------------------------------|
| Terraform    | Infrastructure provisioning   |
| AWS EC2      | Compute instances              |
| AWS RDS      | Managed MySQL DB               |
| AWS VPC      | Networking and isolation       |

---

## 🚀 Deployment Steps

```bash
# Clone the repository
git clone https://github.com/Swatiz-cloud/3-tier-terraform-modules.git
cd 3-tier-terraform

# Configure variable values in terraform.tfvars

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview the changes
terraform plan

# Apply the configuration
terraform apply
````

---
## 📤 Terraform Outputs

After a successful deployment, Terraform will display the following useful information:

- ✅ **Web Tier Public IPs** – Access your web servers directly
- 🔒 **App Tier Private IPs** – Internal IPs for backend services
- 🗄️ **Database Endpoint** – Connect securely to the RDS instance
- 🧩 **VPC & Subnet IDs** – Useful for networking and debugging

---

## 🛡️ Security Best Practices

Security is baked into the design with the following practices:

- 🌐 **Web Tier is Public** – Only HTTP/HTTPS/SSH allowed from the internet
- 🔒 **App & DB Tiers are Private** – No direct internet exposure
- 🌍 **NAT Gateway** – Enables outbound traffic from private subnets safely
- 🧷 **Sensitive Data Handling** – Credentials and secrets are stored in `terraform.tfvars`, not hardcoded


---
## 🧼 Tear Down & Cleanup

Once you're done testing or no longer need the infrastructure, follow these steps to safely clean up:

```
# Remove all resources created by Terraform
terraform destroy

# Clean up local Terraform state files (optional but recommended)
rm -rf .terraform/ terraform.tfstate* crash.log
```


## 📈 Benefits of Modular Terraform

* 🔍 **Clarity** – Separation of concerns improves maintainability
* ♻️ **Reusability** – Modules can be reused in different environments
* 📏 **Consistency** – Predictable and parameterized deployments
* 🚀 **Scalability** – Easy to add/remove components
* 🤖 **Automation** – Full IaC workflow

---

Here are some ideas to improve and scale the infrastructure in the future:

- 🔀 Add an Application Load Balancer (ALB) :  to distribute incoming traffic evenly across web instances.
- 📈 Enable Auto Scaling Groups :  to automatically adjust the number of EC2 instances based on traffic load.
- 🔐 Use AWS Secrets Manager or SSM Parameter Store:  for managing sensitive data like database credentials securely.
- 🔒 Set up HTTPS : by integrating AWS Certificate Manager (ACM) with the load balancer for encrypted traffic.
- 📊 Incorporate AWS CloudWatch: for centralized logging, monitoring, and custom alerts.
- ☁️ Configure a Remote Backend(S3 + DynamoDB): to manage Terraform state securely and enable team collaboration.

---
## ✅ Final Thoughts
<<<<<<< HEAD
This project delivers a robust, modular, and secure AWS environment built with Terraform. It establishes a solid foundation for deploying production-grade applications, with ample flexibility to scale, automate, and integrate into modern DevOps workflows effortlessly.#
