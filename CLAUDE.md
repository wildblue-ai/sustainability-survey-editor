# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a comprehensive sustainability survey CRUD editor - a full-stack web application for managing sustainability assessment questions and surveys. The application features role-based authentication, advanced question management, and AWS deployment capabilities.

**Company**: WildBlue Enterprises LLC  
**License**: Proprietary  
**Technology Stack**: Node.js, Express, MySQL, Vanilla JavaScript, Tailwind CSS

## Project Structure

```
sustainability-survey/
├── src/                    # Server-side application code
│   └── server.js          # Main Express application server
├── public/                # Frontend files (HTML, CSS, JS)
│   ├── index.html         # Question library management interface
│   ├── login.html         # Authentication interface
│   ├── superadmin.html    # Admin dashboard
│   ├── survey-preview.html # Survey preview and testing
│   ├── script.js          # Main frontend application logic
│   └── styles.css         # Tailwind CSS styling
├── database/              # Database schema and migrations
│   ├── migrations/        # SQL migration files
│   └── seeds/            # Sample data and question sets
├── docs/                  # Project documentation
│   └── deployment/       # AWS deployment guides
├── scripts/              # Deployment and setup automation
│   └── setup/           # Database security scripts
├── deployment/           # AWS deployment configurations
│   └── apprunner.yaml   # AWS App Runner configuration
└── system_prompts.md    # Complete system prompt history (gitignored)
```

## Key Features

### Authentication & Authorization
- **Role-based access**: Superadmin, Partner, Client, Vendor roles
- **Secure sessions**: bcrypt password hashing, express-session
- **Protected routes**: Authentication middleware on all API endpoints

### Question Management
- **CRUD operations**: Create, read, update, delete sustainability questions
- **Category organization**: Questions grouped by sustainability topics (GHG, Energy, etc.)
- **Question types**: Systems, Best Practice, Performance categories
- **Answer types**: Boolean, numeric, percentage, multiple choice, free text
- **Effort/Impact ratings**: Scoring system for question prioritization

### Advanced UI Features
- **Accordion categories**: One-open-at-a-time category navigation
- **Auto-scroll**: Selected category scrolls to top of view
- **Real-time search**: Debounced search across questions and categories
- **Responsive design**: Mobile-friendly Tailwind CSS interface
- **Modal editing**: In-place question editing with validation

### Survey System
- **Preview functionality**: Test survey flow and question display
- **Multiple choice variants**: Single select, multi-select, yes/no per option
- **Free text support**: 1000 character limit with validation
- **Category ordering**: Custom category display sequence

## Development Commands

```bash
# Start development server
npm run dev

# Start production server  
npm start

# Install dependencies
npm install
```

## Database Setup

**Local Development:**
```bash
# Connect to secure MySQL
mysql -u sustainapp -p --socket=/tmp/mysql.sock

# Run migrations
mysql -u sustainapp -p sustainability_survey < database/migrations/database_migration.sql
```

**Environment Configuration:**
- Copy `.env.example` to `.env`
- Configure `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_SOCKET`
- Set `SESSION_SECRET` for secure sessions

## Security Implementation

### Environment-Based Configuration
- All credentials stored in `.env` (gitignored)
- Dedicated database user (`sustainapp`) with limited privileges
- Production-ready session management with secure cookies
- CORS configuration for cross-origin protection

### Database Security
- MySQL root password secured
- Application-specific database user
- Socket-based local connections
- Environment variable configuration for all deployments

## AWS Deployment Strategy

**Phase 1: Testing (~$18/month)**
- AWS Lightsail VPS + Managed MySQL
- Quick deployment for immediate testing

**Phase 2: Production (~$100-200/month)**  
- AWS App Runner + RDS MySQL
- Auto-scaling and high availability

**Phase 3: Enterprise (~$200+/month)**
- ECS Fargate + Load Balancer + CloudFront
- Full enterprise features and monitoring

**Deployment Files:**
- `deployment/apprunner.yaml` - App Runner configuration
- `docs/deployment/aws-setup.md` - Comprehensive deployment guide
- `scripts/deploy-lightsail.sh` - Automated Lightsail setup

## API Endpoints

### Authentication
- `POST /api/login` - User authentication
- `POST /api/logout` - Session termination
- `GET /api/me` - Current user info

### Questions Management
- `GET /api/questions` - List questions with filtering/pagination
- `POST /api/questions` - Create new question
- `PUT /api/questions/:id` - Update existing question
- `DELETE /api/questions/:id` - Delete question
- `GET /api/stats` - Question statistics by category/type

### Survey System
- `GET /api/survey-preview` - Get survey questions for preview
- `POST /api/migrate` - Database migration endpoint

### Utility
- `GET /healthz` - Health check for load balancers

## Git Workflow

### Commit Message Standards
- Use conventional commit format: `type(scope): description`
- Always include requester: "Cheryl Aday"
- Include date, changes made, and technical details
- Use `.gitmessage` template for consistency

### Branch Strategy
- Main branch: `main`
- Feature branches for development
- All changes require testing before commit

## Important Files

- **`.env`** - Environment configuration (never commit)
- **`system_prompts.md`** - In docs folder. Complete instruction history (gitignored)
- **`.gitmessage`** - Commit message template
- **`CLAUDE.md`** - This file (project guidance)

## Development Workflow

1. **Environment Setup**: Configure `.env` with database credentials
2. **Database Migration**: Run SQL migrations for schema setup  
3. **Development Server**: Use `npm run dev` for hot reloading
4. **Testing**: Verify all endpoints and UI functionality
5. **Security Check**: Ensure no credentials in code
6. **Update System Prompts**: Document significant user requests in `docs/system_prompts.md`
7. **Commit**: Use template for proper attribution and details

## Security Guidelines

### Database Access Security
- **NEVER use passwords in command line** - Passwords appear in shell history and process lists
- **Use configuration files**: Create `.my.cnf` with secure permissions (600) for MySQL access
- **Environment variables**: Reference credentials from `.env` file when possible
- **Secure file permissions**: Ensure config files are readable only by owner
- **Avoid hardcoded credentials**: Never commit passwords or secrets to repository

### Files Excluded from Git Repository (.gitignore)
The following files and patterns are excluded from version control:

**Security & Credentials:**
- `.env` - Environment variables with database passwords, API keys, session secrets
- `*.pem` - SSH private keys for server access
- `.my.cnf` - MySQL configuration with credentials

**Development Files:**
- `node_modules/` - NPM package dependencies
- `*.log` - Application and system log files
- `.DS_Store` - macOS system files
- `sustain/` - Legacy directory

**Documentation & Internal Files:**
- `system_prompts*` - Internal conversation history and system instructions
- `.gitmessage` - Git commit message template

**Deployment Scripts:**
- `/deploy-step*.sh` - Automated AWS deployment scripts (root level only)
- `/check-*.sh` - Status monitoring scripts (root level only) 
- `/test-*.sh` - Testing automation scripts (root level only)
- `*.tar.gz` - Deployment packages and archives

**Important**: All credential files (.env, .pem, .my.cnf) must never be committed to avoid security breaches. The deployment scripts contain sensitive infrastructure commands and should remain local-only.

## Troubleshooting

### Common Issues
- **Database connection**: Check socket path in `.env`
- **Port conflicts**: Application runs on port 3000
- **Authentication errors**: Verify session configuration
- **Build issues**: Ensure all dependencies installed

### MySQL Socket Issues
- Local MySQL uses `/tmp/mysql.sock`
- Update `DB_SOCKET` in `.env` if connection fails
- Verify MySQL service is running

## Documentation Requirements

### System Prompts Tracking
- **Document user requests** in `docs/system_prompts.md` with:
  - Timestamp and requester (Cheryl Aday)
  - Original request content
  - Context about what was implemented
  - Technical details and approach taken
- **Update after significant sessions** to maintain development history
- **Include cross-references** to relevant commits and files

## Current Deployment Architecture (DO NOT BREAK)

### Existing Production Setup (Live System)
- **Instance**: `sustainability-survey-app` (Lightsail nano_3_0 - $5/month)
- **Database**: `sustainability-survey-db` (Lightsail MySQL micro_2_0 - $15/month)
- **IP**: Static IP `98.86.81.114` attached to instance
- **Domain**: `www.green-metrics.com` (points to static IP)
- **Production URL**: https://www.green-metrics.com
- **Direct IP Access**: http://98.86.81.114
- **Process Manager**: PM2 running `src/server.js` as `sustainability-survey`
- **Reverse Proxy**: Caddy on port 80, proxying to Node.js on port 3000
- **SSL**: Caddy handles HTTPS for the domain
- **Current Access**: Basic auth enabled with DEMO_USERNAME/DEMO_PASSWORD

### Critical Production Configuration
- **Database Endpoint**: `ls-7c1f4c7b75d1fafe00053c0859027e4356c41c60.cyx68ei0gu8t.us-east-1.rds.amazonaws.com`
- **Database User**: `admin` (master user, not `sustainapp`)
- **Database Name**: `sustainabilitydb` (not `sustainability_survey`)
- **Environment**: Production `.env` created by `deploy-step4-app.sh`
- **SSL**: Caddy configured for HTTP reverse proxy (HTTPS requires domain)

### Deployment Scripts (Automated Sequence)
1. `deploy-step1-instance.sh` - Creates Lightsail instance + static IP
2. `deploy-step2-database.sh` - Creates Lightsail MySQL database  
3. `deploy-step4-app.sh` - Deploys app, creates production .env, imports schema
4. `deploy-step5-ssl.sh` - Configures Caddy reverse proxy for port 80
5. `check-status.sh` - Status monitoring

### CRITICAL: What NOT to Change
- **Do not modify PM2 process name**: Must remain `sustainability-survey`
- **Do not change database connection details**: Uses Lightsail MySQL, not RDS
- **Do not break existing .env structure**: Production .env created by deployment script
- **Do not modify startup command**: PM2 starts `src/server.js` directly
- **Do not change ports**: App on 3000, Caddy on 80

### AWS Secrets Manager Integration (New Addition)
- **Purpose**: Hybrid config system for secure credential management
- **Behavior**: Uses .env locally, AWS Secrets Manager in production
- **Implementation**: `src/start.js` wrapper + `src/config.js` manager
- **Production Switch**: Change PM2 to start `src/start.js` instead of `src/server.js`
- **Secrets Created**: 
  - `sustainability-survey/database` (with actual Lightsail endpoint)
  - `sustainability-survey/app-config` (with session secret and demo auth)

### Deployment Safety Rules
1. **Always backup production** before major changes
2. **Test locally first** with NODE_ENV=development  
3. **Use PM2 restart**, not stop/start, to avoid downtime
4. **Verify database connectivity** before restarting services
5. **Check Caddy status** after any changes to ensure reverse proxy works

### Current Login Issue Diagnosis
- **Problem**: Basic auth working but user login failing
- **Likely Cause**: User password hashes don't match between local/production
- **Solution**: Update production user table with correct password hashes using AWS Secrets Manager credentials

## Security Notes

- **Never commit** `.env` files or credentials
- **Database user** has limited privileges (not root)
- **Session secrets** must be cryptographically secure
- **CORS** configured for production deployment
- **Input validation** on all form submissions