#!/bin/bash
# Test AWS access and Lightsail availability
set -e
set -a
source .env
set +a

echo "🔍 Testing AWS credentials..."
aws sts get-caller-identity

echo ""
echo "🚀 Testing Lightsail access..."
aws lightsail get-regions

echo ""
echo "✅ AWS credentials and Lightsail access confirmed!"

# Clean up
rm "$0"