# AWS Lightsail Deployment Steps

## Overview
Complete deployment process for the Sustainability Survey application on AWS Lightsail.

**Target Cost:** $20/month ($5 instance + $15 database)

## Prerequisites
- AWS CLI configured with credentials
- `.env` file with database password and demo credentials

## Deployment Steps

### Step 1: Create Lightsail Instance ($5/month)
```bash
./deploy-step1-fixed.sh
```
- Creates Ubuntu 22.04 instance (nano_3_0 bundle)
- Allocates and attaches static IP
- Instance: sustainability-survey-app
- Static IP: sustainability-survey-ip

### Step 2: Create MySQL Database ($15/month)
```bash
./deploy-step2-database.sh
```
- Creates MySQL 8.0 database (micro_2_0 bundle)
- Database: sustainability-survey-db
- Master user: admin
- Takes 5-10 minutes to provision

### Step 3: Configure Networking
```bash
./deploy-step3-networking.sh
```
- Opens ports: 22 (SSH), 80 (HTTP), 443 (HTTPS), 3000 (Node.js)
- Configures security groups

### Step 4: Deploy Application
```bash
./deploy-step4-app.sh
```
- Uploads application code to instance
- Installs Node.js 18.x and PM2
- Sets up production environment
- Imports database schema
- Starts application with PM2

### Step 5: Configure SSL Proxy
```bash
./deploy-step5-ssl.sh
```
- Installs and configures Caddy reverse proxy
- Sets up HTTP reverse proxy (port 80 → 3000)
- Prepares for HTTPS with domain (when available)

## Access Information
- **Application URL:** http://[STATIC_IP] or http://[STATIC_IP]:3000
- **Login:** Sustain / RecycleNow
- **Database:** Accessible internally to application

## Status Checking
```bash
./check-database-status.sh  # Check database creation progress
./check-status.sh          # Check instance status
```

## Monthly Costs
- Lightsail Instance (nano_3_0): $5.00
- MySQL Database (micro_2_0): $15.00
- Static IP: Free (when attached)
- **Total: $20.00/month**

## Upgrade Path
- Instance can be upgraded to larger bundles as needed
- Database can be scaled up for more storage/performance
- Can add CDN, load balancer, or additional instances later

## Security Features
- HTTP Basic Auth for demo protection
- MySQL with dedicated application user
- Firewall configured for minimal required ports
- Production environment variables

## Notes
- Database takes 5-10 minutes to provision
- Instance provisioning takes 2-3 minutes
- Application deployment takes 3-5 minutes
- SSL requires domain name for automatic HTTPS certificates