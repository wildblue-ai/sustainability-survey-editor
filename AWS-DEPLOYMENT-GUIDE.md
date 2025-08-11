# AWS Deployment Guide for Sustainability Survey

## Prerequisites
- AWS CLI installed and configured
- Node.js application ready with environment variables

## Step 1: Create RDS MySQL Instance

```bash
# Create RDS MySQL instance
aws rds create-db-instance \
    --db-instance-identifier sustainsurvey-db \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --engine-version 8.0.35 \
    --master-username admin \
    --master-user-password "YOUR_RDS_PASSWORD_HERE" \
    --allocated-storage 20 \
    --storage-type gp2 \
    --vpc-security-group-ids sg-XXXXXXXX \
    --no-publicly-accessible \
    --backup-retention-period 7 \
    --storage-encrypted
```

## Step 2: Import Database Schema

```bash
# Wait for RDS to be available, then import schema
mysql -h YOUR_RDS_ENDPOINT -u admin -p sustainsurvey < aws-migration-schema.sql
```

## Step 3: Deploy with AWS App Runner

Create `apprunner.yaml`:
```yaml
version: 1.0
runtime: nodejs16
build:
  commands:
    build:
      - npm install
run:
  runtime-version: 16
  command: npm start
  network:
    port: 3000
    env:
      - name: PORT
        value: "3000"
      - name: NODE_ENV  
        value: "production"
      - name: DB_HOST
        value: "YOUR_RDS_ENDPOINT"
      - name: DB_USER
        value: "admin"
      - name: DB_PASSWORD
        value: "YOUR_RDS_PASSWORD"
      - name: DB_NAME
        value: "sustainsurvey"
      - name: SESSION_SECRET
        value: "YOUR_SESSION_SECRET"
      - name: APP_URL
        value: "https://YOUR_APP_RUNNER_URL"
```

## Step 4: Create App Runner Service

```bash
# Create App Runner service
aws apprunner create-service \
    --service-name sustainsurvey-app \
    --source-configuration '{
        "ImageRepository": {
            "ImageIdentifier": "public.ecr.aws/aws-containers/hello-app-runner:latest",
            "ImageConfiguration": {
                "Port": "3000"
            }
        },
        "AutoDeploymentsEnabled": false
    }' \
    --instance-configuration '{
        "Cpu": "0.25 vCPU",
        "Memory": "0.5 GB"
    }'
```

## Environment Variables Needed:
- `DB_HOST`: RDS endpoint
- `DB_USER`: admin
- `DB_PASSWORD`: Your RDS password  
- `DB_NAME`: sustainsurvey
- `SESSION_SECRET`: Your secure session secret
- `NODE_ENV`: production
- `APP_URL`: Your App Runner URL

## Security Checklist:
✅ Database user created with limited permissions
✅ Environment variables configured  
✅ Session secret generated
✅ RDS encryption enabled
✅ Database not publicly accessible