#!/bin/bash
# Deploy Step 1: Create Lightsail Instance with Ubuntu ($5/month)
set -e
set -a
source .env
set +a

echo "🚀 Creating Lightsail instance with Ubuntu (nano_3_0 - $5/month)..."

aws lightsail create-instances \
    --region us-east-1 \
    --instance-names sustainability-survey-app \
    --availability-zone us-east-1a \
    --blueprint-id ubuntu_22_04 \
    --bundle-id nano_3_0 \
    --tags key=Project,value=SustainabilitySurvey key=Owner,value=WildBlue

echo "⏳ Waiting for instance to be available..."
echo "This usually takes 2-3 minutes..."

aws lightsail wait instance-available --region us-east-1 --instance-name sustainability-survey-app

echo "📱 Creating static IP (free when attached)..."
aws lightsail allocate-static-ip --region us-east-1 --static-ip-name sustainability-survey-ip

echo "🔗 Attaching static IP to instance..."
aws lightsail attach-static-ip \
    --region us-east-1 \
    --static-ip-name sustainability-survey-ip \
    --instance-name sustainability-survey-app

echo "✅ Instance created successfully!"
echo ""
echo "📊 Instance Details:"
aws lightsail get-instance --region us-east-1 --instance-name sustainability-survey-app \
    --query 'instance.[name,state.name,publicIpAddress,privateIpAddress]' \
    --output table

echo ""
echo "🌐 Static IP Details:"
aws lightsail get-static-ip --region us-east-1 --static-ip-name sustainability-survey-ip \
    --query 'staticIp.[name,ipAddress,isAttached]' \
    --output table

echo ""
echo "💰 Current monthly cost: $5.00 (instance only)"
echo "Next: Create MySQL database (+$15/month)"

# Clean up
rm "$0"