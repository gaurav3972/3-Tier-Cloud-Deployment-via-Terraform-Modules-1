# 🚀 3-Tier Cloud Deployment via Terraform Modules

## 📘 Introduction

This project demonstrates how to build and deploy a **three-tier cloud infrastructure** on **Amazon Web Services (AWS)** using **modular Terraform**. It follows Infrastructure as Code (IaC) best practices to create a **scalable**, **secure**, and **reusable** architecture.

---

## 📊 Project Overview

The infrastructure follows the classic **three-tier architecture**:

* **Web Tier**
* **Application Tier**
* **Database Tier**

Each tier is:

* Deployed in **separate subnets**
* Managed via **custom Terraform modules**
* Isolated using **dedicated security groups**

---

## 🏗️ Architecture Blueprint

### 1️⃣ Web Tier

* Runs on **EC2** instances in **public subnets**
* Exposed via **HTTP, HTTPS, and SSH**
* Serves front-end traffic

### 2️⃣ Application Tier

* Runs on EC2 in **private subnets**
* Handles business logic
* Only accessible by the Web and DB tiers

### 3️⃣ Database Tier

* Uses **Amazon RDS (MySQL)** in **private subnets**
* Accessible **only** from the App Tier

---

## 🌐 Network Architecture

* **VPC** with public and private subnets across availability zones
* **Internet Gateway** for public-facing traffic
* **NAT Gateway** for private subnet internet access
* Proper **routing and security group rules** per layer

---

## 🔐 Security Groups

| Layer         | Inbound Access From            |
| ------------- | ------------------------------ |
| Web Tier      | HTTP/HTTPS/SSH from Internet   |
| App Tier      | App Port (e.g., 8080) from Web |
| Database Tier | MySQL (3306) from App Tier     |

---

## 📁 Project Structure

```
3-tier-terraform/
├── main.tf               # Root Terraform config
├── variables.tf          # Input variables
├── outputs.tf            # Outputs
├── terraform.tfvars      # Variable values
│
├── modules/
│   ├── vpc/              # VPC, Subnets, NAT
│   ├── web/              # Web EC2
│   ├── app/              # App EC2
│   ├── db/               # RDS
│   └── security/         # Security groups
```

---

## 🧱 Terraform Module Overview

### 🔹 VPC Module

* Creates VPC, public/private subnets
* Outputs subnet IDs

### 🔹 Security Module

* Defines 3 security groups: Web, App, DB

### 🔹 Web & App Modules

* Launches EC2 in respective subnets
* Attaches relevant security groups

### 🔹 DB Module

* Creates RDS instance with subnet group
* Accepts DB username, password

---

## 💻 Getting Started in VS Code

1. **Clone repo & enter directory**

```bash
git clone https://github.com/gaurav3972/3-tier-Deployment-via-terraform-modules-1.git
```
```
cd 3-tier-terraform
```

2. **Set your values in `terraform.tfvars`**

3. **Initialize Terraform**

```bash
terraform init
```

4. **Validate & Plan**

```bash
terraform validate
terraform plan
```

5. **Apply**

```bash
terraform apply
```

---

## 📤 Terraform Outputs

After deployment, you'll receive:

* ✅ Web Tier instance IDs (public)
* 🔒 App Tier instance IDs (private)
* 🗄️ Database endpoint
* 🌐 VPC and subnet IDs

---

## 🔐 Security Highlights

* 🌍 Web Tier is **internet-facing**
* 🔒 App & DB Tiers are **private**
* 🔄 NAT Gateway provides secure outbound access
* 🧷 Secrets (like DB creds) are stored in `terraform.tfvars`, not hardcoded

---

## 🧼 Tear Down

```bash
terraform destroy
rm -rf .terraform terraform.tfstate*
```

---

## 📈 Benefits of Using Modules

* ✅ **Modularity**: Code reuse & clean separation
* 🔁 **Reusability**: Easily adapt for staging/production
* 📦 **Scalability**: Add layers like ALB, Auto Scaling
* 🔐 **Security**: Granular control per layer
* 📂 **Team-friendly**: Consistent and manageable

---
### ✅ **Project Summary:**

This project demonstrates how to deploy a **modular, secure, and scalable 3-tier architecture** on **AWS** using **Terraform modules**. It separates the infrastructure into **Web**, **Application**, and **Database** tiers — each deployed in separate subnets with tailored **security groups**. The Web Tier is public and handles incoming HTTP/HTTPS traffic, the App Tier is private and runs business logic, and the DB Tier uses **Amazon RDS (MySQL)** in isolated private subnets.
The project uses **modular Terraform code** for each layer (VPC, Web, App, DB, and Security), following **Infrastructure as Code (IaC)** principles. It ensures clean separation of concerns, easier reusability, and enhanced maintainability. Additional best practices like **NAT Gateways**, **routing**, **secure credentials management**, and **output handling** are implemented.
This infrastructure is ideal for production-grade environments, with room for future improvements like **load balancing**, **auto scaling**, **HTTPS**, and **centralized monitoring**.
