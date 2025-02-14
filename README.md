# **Security & Authorization Domain**

## **Description**
The Security & Authorization domain is responsible for managing authentication, authorization, and data encryption within the hospital system. Each functionality is implemented as an independent microservice to ensure security, scalability, and modularity.

## **Microservices**

### **1. User Authentication and Validation (JWT)**
- **Description**: Authenticates users and generates a JWT token for secure access. It also validates the provided JWT token to ensure secure API access.
- **Method**: POST
- **Dependencies**: Patient, doctor, and admin database 🗄️
- **Inputs**: Username and password or token
- **Outputs**: JWT token and verification result 🔑

### **2. Password Encryption and Verification**
- **Description**: Encrypts passwords before storing them in the database and verifies if a provided password matches the stored encrypted password.
- **Method**: POST
- **Inputs**: Plain text password or encrypted password
- **Outputs**: Encrypted password 🔐 or verification result (match ✅ or no match ❌)

### **3. Patient Registration**
- **Description**: Registers new patients into the system and sends a welcome email with their credentials.
- **Method**: POST
- **Dependencies**: AWS SES (Simple Email Service) for sending emails, Patient database 🗄️
- **Inputs**: Patient details including first name, last name, birth date, gender, address, phone, email, username, and password
- **Outputs**: Success message upon registration and email notification 📧

## **Technologies Used**
- **Backend**: Go, bcrypt 💻
- **Database**: PostgreSQL 🐘, MySQL 🐬
- **Email Service**: AWS SES (Simple Email Service)
- **Authentication**: JWT (JSON Web Tokens)
- **Frameworks**: Gorilla Mux for routing

## **Integrations**
- **Patient Management Domain**: Encryption is necessary to keep patient passwords secure.
- **Doctor Management Domain**: Encryption is necessary to keep doctor passwords secure.
- **Admin Management Domain**: Encryption is necessary to keep admin passwords secure.
- **AWS SES Integration**: Sends welcome emails to newly registered patients with their login credentials.

## **Deployment**
- **Dockerized Microservices**: Each microservice is containerized using Docker for easy deployment and scalability.
- **Deployment Environments**:
  - **QA Environment**: Deployed on AWS EC2 instance with incremental ports starting from 8080.
  - **Dev Environment**: Deployed on AWS EC2 instance with incremental ports starting from 8080.
- **CI/CD Pipeline**: Automated workflows for syncing microservices to the domain repository and deploying them on AWS using GitHub Actions.

## **Repository Structure**
- **ms-login-jwt**: Microservice for user authentication and JWT validation.
- **ms-encrypt**: Microservice for password encryption and verification.
- **ms-register**: Microservice for patient registration and email notifications.
