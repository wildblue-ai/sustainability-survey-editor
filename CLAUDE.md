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

## Security Notes

- **Never commit** `.env` files or credentials
- **Database user** has limited privileges (not root)
- **Session secrets** must be cryptographically secure
- **CORS** configured for production deployment
- **Input validation** on all form submissions