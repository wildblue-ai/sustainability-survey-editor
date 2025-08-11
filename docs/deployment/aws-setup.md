# AWS Deployment Guide - Sustainability Survey Project

## Current Architecture
- Node.js Express application with MySQL database
- Session-based authentication with bcrypt passwords
- Static file serving for frontend
- Health check endpoint at `/healthz`

## Deployment Strategy Overview

### Phase 1: Testing/Development (Current) - ~$18/month
- **Compute**: AWS Lightsail VPS ($3.50/month)
- **Database**: Lightsail Managed MySQL ($15/month)  
- **SSL**: Free via Let's Encrypt/Caddy
- **Target**: Testing and development

### Phase 2: Production Ready - ~$100-200/month
- **Compute**: AWS App Runner (auto-scaling)
- **Database**: RDS MySQL (Multi-AZ)
- **Session Store**: ElastiCache Redis
- **Storage**: S3 for static assets
- **Target**: Production launch

### Phase 3: High Scale - ~$200+/month
- **Compute**: ECS Fargate + Application Load Balancer
- **Database**: RDS MySQL (Multi-AZ, read replicas)
- **Cache**: ElastiCache Redis cluster
- **CDN**: CloudFront
- **Target**: High traffic, enterprise use

## Phase 1: Lightsail Setup (Deploy Today)

### Prerequisites
- AWS Account with billing enabled
- Domain name (optional but recommended)
- Local development environment working

### Step 1: Create Lightsail Instance

```bash
# Choose region (us-east-1, us-west-2, etc.)
# Instance type: Linux/Unix
# Blueprint: Node.js (includes npm, git pre-installed)
# Instance plan: $3.50 USD (512 MB RAM, 1 vCPU, 20 GB SSD)
# Instance name: sustainability-survey-app
```

### Step 2: Create Lightsail Database

```bash
# Database engine: MySQL
# Database plan: $15 USD (1 GB RAM, 1 vCPU, 20 GB storage)
# Database name: sustainability-survey-db
# Master username: sustainapp
# Master password: [Generate strong password]
# Database identifier: sustainability-survey-mysql
```

### Step 3: Configure Networking

```bash
# Create static IP and attach to instance
# Configure firewall:
# - SSH (22) - My IP only
# - HTTP (80) - Anywhere
# - HTTPS (443) - Anywhere
# - Custom (3000) - Anywhere (for testing)
```

### Step 4: Server Setup Commands

```bash
# SSH into your Lightsail instance
ssh -i /path/to/key.pem bitnami@your-static-ip

# Update system
sudo apt update && sudo apt upgrade -y

# Install additional packages
sudo apt install -y git build-essential

# Install PM2 globally
sudo npm install -g pm2

# Install Caddy for SSL
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy

# Create app directory
mkdir -p /home/bitnami/sustainability-survey
cd /home/bitnami/sustainability-survey
```

### Step 5: Deploy Application

```bash
# Clone your repository (or upload via SCP)
git clone https://github.com/yourusername/sustainability-survey.git .

# Install dependencies
npm ci --production

# Create environment file
cp .env.example .env

# Edit environment variables
nano .env
```

### Step 6: Environment Configuration

Create `/home/bitnami/sustainability-survey/.env`:

```bash
# Database Configuration (from Lightsail DB console)
DB_HOST=ls-xxxxxxxxxxxxx.czxxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com
DB_USER=sustainapp
DB_PASSWORD=your-lightsail-db-password
DB_NAME=sustainability_survey
DB_PORT=3306

# Session Security
SESSION_SECRET=your-super-long-random-session-secret-min-32-characters-here

# Application Settings
NODE_ENV=production
PORT=3000
APP_URL=https://yourdomain.com
```

### Step 7: Configure Caddy (SSL/Reverse Proxy)

Create `/etc/caddy/Caddyfile`:

```caddy
yourdomain.com {
    reverse_proxy 127.0.0.1:3000
    
    # Optional: serve static files directly
    handle /static/* {
        root * /home/bitnami/sustainability-survey
        file_server
    }
    
    # Security headers
    header {
        X-Content-Type-Options nosniff
        X-Frame-Options DENY
        X-XSS-Protection "1; mode=block"
        Strict-Transport-Security "max-age=31536000; includeSubDomains"
    }
}

# HTTP redirect
http://yourdomain.com {
    redir https://{host}{uri} permanent
}
```

### Step 8: Start Services

```bash
# Start application with PM2
cd /home/bitnami/sustainability-survey
pm2 start "npm start" --name sustainability-survey
pm2 save
pm2 startup

# Start Caddy
sudo systemctl enable caddy
sudo systemctl start caddy
```

### Step 9: Database Migration

```bash
# Run migration endpoint (one time)
curl -X POST https://yourdomain.com/api/migrate

# Or connect directly to MySQL and run schema
mysql -h ls-xxxxx.czxxxxx.us-east-1.rds.amazonaws.com -u sustainapp -p sustainability_survey < aws-migration-schema.sql
```

### Step 10: DNS Configuration

```bash
# Point your domain to the Lightsail static IP
# A record: yourdomain.com -> your-static-ip
# CNAME: www.yourdomain.com -> yourdomain.com
```

## Phase 2: Production Migration (App Runner)

### When to migrate:
- Consistent traffic (>10 users/day)
- Need auto-scaling
- Require high availability
- Ready for production costs

### Migration steps:
1. Create RDS MySQL instance
2. Export data from Lightsail DB to RDS
3. Create App Runner service with GitHub integration
4. Configure environment variables in App Runner
5. Update DNS to App Runner URL
6. Add ElastiCache Redis for sessions

### App Runner Configuration:

```yaml
# apprunner.yaml (already in your repo)
version: 1.0
runtime: nodejs16
build:
  commands:
    build:
      - npm ci --production
      - echo "Build completed"
run:
  runtime-version: 16
  command: npm start
  network:
    port: 3000
    env: PORT
  env:
    - name: NODE_ENV
      value: "production"
```

## Phase 3: Enterprise Scale (ECS Fargate)

### When to migrate:
- High traffic (>1000 concurrent users)
- Multiple environments needed
- Advanced monitoring required
- Enterprise security requirements

### Architecture:
- ECS Fargate cluster with auto-scaling
- Application Load Balancer with SSL
- RDS with read replicas
- ElastiCache cluster mode
- CloudFront CDN
- WAF protection

## Monitoring & Maintenance

### Phase 1 (Lightsail):
- CloudWatch agent for basic metrics
- Lightsail console monitoring
- Manual log checking via SSH

### Phase 2+ (App Runner/ECS):
- CloudWatch detailed monitoring
- AWS X-Ray tracing  
- CloudWatch Logs centralization
- SNS alerts for errors

## Security Considerations

### All Phases:
- Environment variables for secrets
- HTTPS only (handled by Caddy/ALB)
- Database encryption at rest
- VPC security groups
- Regular security updates

### Production+ (Phase 2+):
- AWS Secrets Manager
- VPC endpoints
- WAF rules
- AWS Config compliance
- GuardDuty threat detection

## Backup Strategy

### Phase 1:
- Lightsail automatic database snapshots (7 days)
- Manual application code backups

### Phase 2+:
- RDS automated backups (35 days)
- Cross-region backup replication
- Application deployment rollback capability

## Cost Optimization

### Phase 1:
- Use smallest instances that meet performance needs
- Monitor usage and right-size after testing

### Phase 2+:
- Reserved instances for predictable workloads
- Auto-scaling policies to minimize idle resources
- CloudWatch cost monitoring and budgets

## Migration Checklist

### Phase 1 → Phase 2:
- [ ] Export Lightsail database
- [ ] Create RDS instance
- [ ] Import data to RDS
- [ ] Deploy to App Runner
- [ ] Test thoroughly
- [ ] Update DNS
- [ ] Monitor for 48 hours
- [ ] Decommission Lightsail

### Phase 2 → Phase 3:
- [ ] Create ECS cluster and task definitions
- [ ] Set up Application Load Balancer
- [ ] Configure auto-scaling policies
- [ ] Implement blue/green deployment
- [ ] Set up comprehensive monitoring
- [ ] Load test before cutover

## Troubleshooting

### Common Lightsail Issues:
- **Can't connect to database**: Check security groups and connection string
- **SSL certificate issues**: Verify domain DNS and Caddy configuration  
- **Application won't start**: Check PM2 logs with `pm2 logs`
- **High memory usage**: Monitor with `htop`, consider upgrading instance

### Migration Issues:
- **Database connection timeouts**: Adjust connection pool settings
- **Session persistence**: Ensure Redis is properly configured
- **Static file serving**: Configure CDN/S3 properly

## Support Contacts

- AWS Support (if on paid plan)
- Database issues: Check CloudWatch metrics first
- Application issues: Check application logs and health checks
- Network issues: Verify security groups and DNS