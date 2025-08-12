# Database Security Setup

## ⚠️ SECURITY NOTICE

**NEVER commit actual passwords to version control!**

This directory contains templates for database security setup. Always replace placeholder passwords with actual secure passwords from your `.env` file.

## Setup Instructions

### 1. Generate Secure Passwords

Generate strong passwords for your local development:

```bash
# Generate a secure password (32 characters)
openssl rand -base64 32

# Or use this command to generate a MySQL-safe password
openssl rand -hex 16
```

### 2. Update Local Environment

Add the generated password to your `.env` file:

```bash
# Local development database credentials
DB_PASSWORD=your-generated-secure-password-here
```

### 3. Run Security Setup

Before running the SQL script, replace the placeholder:

```sql
-- In setup-mysql-security.sql, replace:
CREATE USER IF NOT EXISTS 'sustainapp'@'localhost' IDENTIFIED BY 'YOUR_SECURE_PASSWORD_HERE';

-- With your actual password from .env:
CREATE USER IF NOT EXISTS 'sustainapp'@'localhost' IDENTIFIED BY 'your-generated-secure-password-here';
```

### 4. Execute Script

```bash
# Run as MySQL root user
mysql -u root -p < setup-mysql-security.sql
```

## Security Best Practices

1. **Never hardcode passwords** in scripts or code
2. **Use environment variables** for all sensitive data
3. **Rotate passwords regularly** (every 90 days recommended)
4. **Use different passwords** for development, staging, and production
5. **Store production passwords** in AWS Secrets Manager or Parameter Store

## Password Requirements

- Minimum 16 characters
- Mix of uppercase, lowercase, numbers, symbols
- No dictionary words
- Unique per environment

## Production Deployment

For AWS production, passwords are managed through:
- Environment variables on the server
- AWS Secrets Manager (recommended for larger teams)
- AWS Parameter Store (free tier available)

See [../../docs/prod-security-updates.md](../../docs/prod-security-updates.md) for production security roadmap.