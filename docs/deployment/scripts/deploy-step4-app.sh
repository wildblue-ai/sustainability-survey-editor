#!/bin/bash
# Deploy Step 4: Deploy application to Lightsail instance
set -e
set -a
source .env
set +a

INSTANCE_IP=$(aws lightsail get-static-ip --region us-east-1 --static-ip-name sustainability-survey-ip --query 'staticIp.ipAddress' --output text)

echo "🚀 Deploying application to Lightsail instance..."
echo "Instance IP: $INSTANCE_IP"

# Get database endpoint (fallback to manual entry if AWS CLI fails)
DB_ENDPOINT=$(aws lightsail get-relational-database \
    --region us-east-1 \
    --relational-database-name sustainability-survey-db \
    --query 'relationalDatabase.masterEndpoint.address' \
    --output text 2>/dev/null || echo "sustainability-survey-db.public.us-east-1.rds.amazonaws.com")

echo "Database endpoint: $DB_ENDPOINT"

# Create deployment package
echo "📦 Creating deployment package..."
tar -czf sustainability-survey.tar.gz \
    --exclude=node_modules \
    --exclude=.git \
    --exclude="*.sh" \
    --exclude="*.tar.gz" \
    --exclude=".env" \
    src/ public/ package.json package-lock.json database/

# Copy deployment package to instance
echo "📤 Uploading application to instance..."
scp -i ~/.ssh/LightsailDefaultKey-us-east-1.pem \
    -o StrictHostKeyChecking=no \
    sustainability-survey.tar.gz \
    ubuntu@$INSTANCE_IP:~/

# Connect and set up application
echo "⚙️ Setting up application on instance..."
ssh -i ~/.ssh/LightsailDefaultKey-us-east-1.pem \
    -o StrictHostKeyChecking=no \
    ubuntu@$INSTANCE_IP << EOF

# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 for process management
sudo npm install -g pm2

# Extract and set up application
tar -xzf sustainability-survey.tar.gz
cd sustainability-survey || exit 1

# Install dependencies
npm install --production

# Create production environment file
cat > .env << EOL
NODE_ENV=production
PORT=3000
DB_HOST=$DB_ENDPOINT
DB_PORT=3306
DB_USER=admin
DB_PASSWORD=$DB_PASSWORD
DB_NAME=sustainabilitydb
DEMO_USERNAME=$DEMO_USERNAME
DEMO_PASSWORD=$DEMO_PASSWORD
ENABLE_BASIC_AUTH=true
EOL

# Import database schema
mysql -h $DB_ENDPOINT -u admin -p$DB_PASSWORD sustainabilitydb < database/schema.sql

# Start application with PM2
pm2 start src/server.js --name sustainability-survey
pm2 startup
pm2 save

echo "✅ Application deployed successfully!"
echo "🌐 Access at: http://$INSTANCE_IP:3000"

EOF

# Clean up local files
rm sustainability-survey.tar.gz

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your application is now live at: http://$INSTANCE_IP:3000"
echo "🔐 Login with: $DEMO_USERNAME / $DEMO_PASSWORD"
echo ""
echo "💰 Total monthly cost: \$20.00"
echo "Next: Configure SSL with Caddy for HTTPS"

# Clean up
rm "$0"