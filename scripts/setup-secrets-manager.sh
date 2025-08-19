#!/bin/bash
# Setup AWS Secrets Manager for production credentials
set -e

echo "🔐 Setting up AWS Secrets Manager for sustainability survey..."

# Create the secret for database credentials
echo "📝 Creating database credentials secret..."
aws secretsmanager create-secret \
  --name "sustainability-survey/database" \
  --description "Database credentials for sustainability survey production" \
  --secret-string '{
    "host": "PLACEHOLDER_DB_HOST",
    "username": "sustainapp", 
    "password": "PLACEHOLDER_DB_PASSWORD",
    "database": "sustainability_survey",
    "port": 3306
  }' \
  --region us-east-1

# Create the secret for application config
echo "📝 Creating application config secret..."
aws secretsmanager create-secret \
  --name "sustainability-survey/app-config" \
  --description "Application configuration for sustainability survey" \
  --secret-string '{
    "session_secret": "PLACEHOLDER_SESSION_SECRET",
    "demo_username": "Sustain",
    "demo_password": "RecycleNow",
    "node_env": "production"
  }' \
  --region us-east-1

echo "✅ Secrets created! Next steps:"
echo "1. Update the secret values with your actual credentials using AWS Console"
echo "2. Update the application to use AWS Secrets Manager"
echo "3. Grant the Lightsail instance permission to read these secrets"