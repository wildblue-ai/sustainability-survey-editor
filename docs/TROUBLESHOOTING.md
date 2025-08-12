# Troubleshooting Guide

## Common Development Issues

### MySQL Connection Issues

#### Problem: Socket Path Mismatches
**Error:** `ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/usr/local/mysql.sock' (2)`

**Root Cause:** MySQL client is looking for socket in wrong location.

**Solutions:**

1. **Find your actual socket path:**
   ```bash
   # Method 1: Check MySQL config
   mysql_config --socket
   
   # Method 2: Check running processes
   ps aux | grep mysql
   
   # Method 3: Check common locations
   ls -la /tmp/mysql.sock
   ls -la /var/run/mysqld/mysqld.sock
   ls -la /usr/local/mysql/mysql.sock
   ```

2. **Update your .env file with correct socket:**
   ```bash
   # Common macOS paths:
   DB_SOCKET=/tmp/mysql.sock                    # Homebrew MySQL
   DB_SOCKET=/var/run/mysqld/mysqld.sock        # Linux/Ubuntu
   DB_SOCKET=/usr/local/mysql/mysql.sock        # MySQL Installer
   ```

3. **Test connection with explicit socket:**
   ```bash
   mysql -u root -p --socket=/tmp/mysql.sock
   ```

4. **Alternative: Use TCP connection instead:**
   ```bash
   # In .env, remove DB_SOCKET and use:
   DB_HOST=127.0.0.1
   DB_PORT=3306
   ```

#### Problem: MySQL Service Not Running
**Error:** Connection refused or socket not found

**Solution:**
```bash
# macOS with Homebrew:
brew services start mysql

# macOS with MySQL Installer:
sudo /usr/local/mysql/support-files/mysql.server start

# Linux/Ubuntu:
sudo systemctl start mysql
```

### Environment Variable Issues

#### Problem: .env Changes Not Loading
**Solution:** Restart your Node.js application after changing `.env` files.

#### Problem: Production vs Development Config
**Solution:** Use different `.env` files:
- `.env` - Local development (gitignored)
- `.env.example` - Template (committed)
- `.env.production` - Production settings (on server only)

### Database Issues

#### Problem: Database Doesn't Exist
**Solution:**
```sql
CREATE DATABASE IF NOT EXISTS sustainability_survey;
```

#### Problem: User Permissions
**Solution:**
```sql
GRANT ALL PRIVILEGES ON sustainability_survey.* TO 'sustainapp'@'localhost';
FLUSH PRIVILEGES;
```

## macOS-Specific Issues

### MySQL Installation Variations
- **Homebrew:** Socket usually at `/tmp/mysql.sock`
- **MySQL Installer:** Socket usually at `/usr/local/mysql/mysql.sock`
- **MAMP/XAMPP:** Custom socket paths

### Finding Your MySQL Installation:
```bash
which mysql
brew list | grep mysql
ls -la /usr/local/mysql
```

## Security Best Practices

### Password Management
1. **Never commit actual passwords**
2. **Use environment variables**
3. **Rotate passwords regularly**
4. **Use different passwords per environment**

### Socket File Permissions
MySQL socket files should have restricted permissions:
```bash
ls -la /tmp/mysql.sock
# Should show: srwxrwxrwx (socket file)
```

## Development Workflow

### When Setup Issues Occur:
1. **Document the problem** in this file
2. **Find the root cause**
3. **Create a reusable solution**
4. **Update documentation**
5. **Commit the fix**

### Common Commands Reference:
```bash
# Check MySQL status
brew services list | grep mysql

# Test database connection
mysql -u sustainapp -p sustainability_survey

# Restart Node.js development server
npm run dev

# Check environment variables loading
node -e "require('dotenv').config(); console.log(process.env.DB_SOCKET)"
```

## Getting Help

### Before Asking for Help:
1. Check this troubleshooting guide
2. Search recent git commits for similar issues
3. Check the logs: `npm run dev` output
4. Verify environment variables are loading

### What to Include When Reporting Issues:
1. **Operating System:** macOS version, Linux distro
2. **MySQL Version:** `mysql --version`
3. **Node.js Version:** `node --version`
4. **Error Messages:** Complete error output
5. **Recent Changes:** What was modified last
6. **Environment:** Development, staging, or production

---

**Note:** This document should be updated whenever new issues are discovered and resolved.