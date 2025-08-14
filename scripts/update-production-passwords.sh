#!/bin/bash
# Update production database with secure passwords
set -e

echo "🔐 Updating production database passwords..."

# Get production database endpoint
DB_ENDPOINT=$(aws lightsail get-relational-database \
    --region us-east-1 \
    --relational-database-name sustainability-survey-db \
    --query 'relationalDatabase.masterEndpoint.address' \
    --output text)

echo "Database endpoint: $DB_ENDPOINT"

# Upload and run the password update script on production
echo "📤 Uploading password update script to production..."
scp -i ~/.aws/lightsail_default_key.pem \
    scripts/update-secure-passwords.js \
    ubuntu@98.86.81.114:/home/ubuntu/sustainability-survey/

echo "🚀 Running password update on production..."
ssh -i ~/.aws/lightsail_default_key.pem ubuntu@98.86.81.114 << 'EOF'
cd /home/ubuntu/sustainability-survey
export NODE_ENV=production
export DB_HOST=ls-7c1f4c7b75d1fafe00053c0859027e4356c41c60.cyx68ei0gu8t.us-east-1.rds.amazonaws.com
export DB_USER=sustainapp
export DB_PASSWORD="$(cat /home/ubuntu/.env | grep DB_PASSWORD | cut -d'=' -f2)"
export DB_NAME=sustainability_survey

echo "🔧 Running password update script..."
node scripts/update-secure-passwords.js

echo "✅ Production password update completed!"
EOF

echo "🎉 Production database passwords updated successfully!"