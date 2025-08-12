#!/bin/bash
set -a
source .env  
set +a

echo "🔍 Checking instance status..."
aws lightsail get-instance --region us-east-1 --instance-name sustainability-survey-app --query 'instance.[name,state.name,publicIpAddress]' --output table

rm "$0"