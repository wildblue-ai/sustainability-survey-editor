# Deployment Scripts

These are reference templates for AWS Lightsail deployment. They use environment variables from `.env` files and should be customized for your specific deployment needs.

## ⚠️ Security Notice

- These scripts reference environment variables (`${DB_PASSWORD}`, `$DEMO_USERNAME`, etc.)
- **Never hardcode secrets** in these files
- Always use `.env` files or AWS Parameter Store for sensitive data
- Review and customize before using in production

## Scripts Overview

### Core Deployment
- `deploy-step1-fixed.sh` - Create Lightsail instance with Ubuntu
- `deploy-step2-database.sh` - Create MySQL database instance  
- `deploy-step3-networking.sh` - Configure firewall and networking
- `deploy-step4-app.sh` - Deploy application code and setup
- `deploy-step5-ssl.sh` - Configure Caddy for HTTPS

### Utility Scripts
- `check-status.sh` - Check instance and database status
- `test-aws-access.sh` - Verify AWS credentials and permissions

## Usage

1. **Set up environment variables:**
   ```bash
   # Required in .env file
   DB_PASSWORD=your-secure-password
   DEMO_USERNAME=your-demo-username
   DEMO_PASSWORD=your-demo-password
   ```

2. **Customize scripts:**
   - Update domain names
   - Modify instance sizes if needed
   - Adjust tags and metadata

3. **Run in sequence:**
   ```bash
   ./deploy-step1-fixed.sh
   ./deploy-step2-database.sh
   ./deploy-step3-networking.sh
   ./deploy-step4-app.sh
   ./deploy-step5-ssl.sh
   ```

## Cost Estimates (as of 2025)

- **Lightsail Instance (nano_3_0):** $5.00/month
- **MySQL Database (micro_2_0):** $15.00/month
- **Static IP:** Free (when attached)
- **Total:** $20.00/month

## Prerequisites

- AWS CLI configured with Lightsail permissions
- Domain name registered and DNS configured
- SSH key pair for server access

## Troubleshooting

See [aws-deployment-steps.md](../aws-deployment-steps.md) for detailed troubleshooting and common issues.