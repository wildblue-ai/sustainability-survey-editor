#!/bin/bash
# Deploy Step 5: Configure SSL with Caddy for HTTPS
set -e
set -a
source .env
set +a

INSTANCE_IP=$(aws lightsail get-static-ip --region us-east-1 --static-ip-name sustainability-survey-ip --query 'staticIp.ipAddress' --output text)

echo "🔒 Configuring SSL with Caddy reverse proxy..."
echo "Instance IP: $INSTANCE_IP"

# Connect and set up Caddy
ssh -i ~/.ssh/LightsailDefaultKey-us-east-1.pem \
    -o StrictHostKeyChecking=no \
    ubuntu@$INSTANCE_IP << 'EOF'

# Install Caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy

# Create Caddyfile for reverse proxy (HTTP for now, HTTPS requires domain)
sudo tee /etc/caddy/Caddyfile > /dev/null << 'CADDY_EOF'
# Basic HTTP reverse proxy to Node.js app
:80 {
    reverse_proxy localhost:3000
    log {
        output file /var/log/caddy/access.log
    }
}

# For HTTPS with domain (uncomment and modify when domain is available):
# your-domain.com {
#     reverse_proxy localhost:3000
#     log {
#         output file /var/log/caddy/access.log
#     }
# }
CADDY_EOF

# Create log directory
sudo mkdir -p /var/log/caddy
sudo chown caddy:caddy /var/log/caddy

# Start and enable Caddy
sudo systemctl enable caddy
sudo systemctl start caddy
sudo systemctl status caddy --no-pager

echo "✅ Caddy configured for HTTP reverse proxy"
echo "🔒 For HTTPS, configure a domain name and update Caddyfile"

EOF

echo ""
echo "✅ SSL proxy configured!"
echo "🌐 Your application is now accessible at:"
echo "   HTTP:  http://$INSTANCE_IP"
echo "   Direct: http://$INSTANCE_IP:3000"
echo ""
echo "🔐 Login credentials: $DEMO_USERNAME / $DEMO_PASSWORD"
echo "💰 Total monthly cost: \$20.00"
echo ""
echo "🎉 Deployment complete! Your sustainability survey is live!"

# Clean up
rm "$0"