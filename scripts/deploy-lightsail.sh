#!/bin/bash
# Secure AWS Lightsail deployment script
set -e  # exit on error
set -a  # automatically export all variables
source .env
set +a  # stop auto-exporting

echo "🚀 Creating Lightsail instance..."
aws lightsail create-instances \
    --instance-names sustainability-survey-app \
    --availability-zone us-east-1a \
    --blueprint-id node_js \
    --bundle-id nano_2_0

echo "⏳ Waiting for instance to be available..."
aws lightsail wait instance-available --instance-name sustainability-survey-app

echo "📱 Creating static IP..."
aws lightsail allocate-static-ip --static-ip-name sustainability-survey-ip

echo "🔗 Attaching static IP to instance..."
aws lightsail attach-static-ip \
    --static-ip-name sustainability-survey-ip \
    --instance-name sustainability-survey-app

echo "✅ Instance created successfully!"
echo "Getting instance details..."
aws lightsail get-instance --instance-name sustainability-survey-app --query 'instance.[name,resourceType,location.availabilityZone,bundleId,state.name,publicIpAddress]' --output table

# Clean up this script
rm "$0"