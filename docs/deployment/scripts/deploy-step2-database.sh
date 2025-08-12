#!/bin/bash
# Deploy Step 2: Create Lightsail MySQL Database ($15/month)
set -e
set -a
source .env
set +a

echo "🗄️ Creating Lightsail MySQL database (micro_2_0 - $15/month)..."

# Create MySQL database instance
aws lightsail create-relational-database \
    --region us-east-1 \
    --relational-database-name sustainability-survey-db \
    --availability-zone us-east-1a \
    --relational-database-blueprint-id mysql_8_0 \
    --relational-database-bundle-id micro_2_0 \
    --master-database-name sustainabilitydb \
    --master-username admin \
    --master-user-password "${DB_PASSWORD}" \
    --tags key=Project,value=SustainabilitySurvey key=Owner,value=WildBlue

echo "⏳ Waiting for database to be available..."
echo "This usually takes 5-10 minutes..."

aws lightsail wait relational-database-available \
    --region us-east-1 \
    --relational-database-name sustainability-survey-db

echo "🔌 Creating database endpoint..."
aws lightsail get-relational-database \
    --region us-east-1 \
    --relational-database-name sustainability-survey-db \
    --query 'relationalDatabase.[name,relationalDatabaseBlueprintId,relationalDatabaseBundleId,masterEndpoint.address,masterEndpoint.port]' \
    --output table

echo ""
echo "✅ Database created successfully!"
echo ""
echo "📊 Database Details:"
aws lightsail get-relational-database \
    --region us-east-1 \
    --relational-database-name sustainability-survey-db \
    --query 'relationalDatabase.[name,state,masterEndpoint.address,masterEndpoint.port]' \
    --output table

echo ""
echo "💰 Total monthly cost: $20.00 ($5 instance + $15 database)"
echo "Next: Configure networking and deploy application"

# Clean up
rm "$0"