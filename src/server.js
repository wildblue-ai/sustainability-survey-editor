// Load environment variables
require('dotenv').config();

const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
const bcrypt = require('bcrypt');
const session = require('express-session');
const MySQLStore = require('express-mysql-session')(session);
const { v4: uuidv4 } = require('uuid');
const basicAuth = require('express-basic-auth');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
    origin: process.env.APP_URL || 'http://localhost:3000',
    credentials: true
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Force HTTPS redirect in production
if (process.env.NODE_ENV === 'production') {
    app.use((req, res, next) => {
        if (req.header('x-forwarded-proto') !== 'https') {
            res.redirect(`https://${req.header('host')}${req.url}`);
        } else {
            next();
        }
    });
}

// Session store configuration
const sessionStore = new MySQLStore({
    host: process.env.DB_HOST || '127.0.0.1',
    port: parseInt(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'sustainability_survey',
    socketPath: process.env.DB_SOCKET || undefined,
    createDatabaseTable: true, // Auto-create sessions table
    clearExpired: true,
    checkExpirationInterval: 900000, // 15 minutes
    expiration: 86400000 // 24 hours
});

// Session configuration
app.use(session({
    key: 'session_cookie_name',
    secret: process.env.SESSION_SECRET || 'fallback-secret-for-development-only',
    store: sessionStore,
    resave: false,
    saveUninitialized: false,
    cookie: { 
        secure: process.env.NODE_ENV === 'production', // HTTPS in production
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000 // 24 hours
    }
}));

// Basic Auth for demo protection (only in production)
if (process.env.NODE_ENV === 'production' || process.env.ENABLE_BASIC_AUTH === 'true') {
    app.use(basicAuth({
        users: { 
            [process.env.DEMO_USERNAME || 'demo']: process.env.DEMO_PASSWORD || 'password' 
        },
        challenge: true,
        realm: 'Sustainability Survey Demo'
    }));
}

app.use(express.static(path.join(__dirname, '../public')));

// MySQL connection configuration
const dbConfig = {
    host: process.env.DB_HOST || '127.0.0.1',
    port: parseInt(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'sustainability_survey',
    socketPath: process.env.DB_SOCKET || undefined,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
};

// Create MySQL connection pool
const pool = mysql.createPool(dbConfig);

// Test database connection
async function testConnection() {
    try {
        const connection = await pool.getConnection();
        console.log('✅ Database connected successfully');
        connection.release();
    } catch (error) {
        console.error('❌ Database connection failed:', error.message);
    }
}

// Authentication middleware
const requireAuth = (roles = []) => {
    return async (req, res, next) => {
        if (!req.session.userId) {
            return res.status(401).json({
                success: false,
                error: 'Authentication required'
            });
        }

        try {
            const [users] = await pool.execute(
                'SELECT * FROM users WHERE id = ? AND is_active = TRUE',
                [req.session.userId]
            );

            if (users.length === 0) {
                req.session.destroy();
                return res.status(401).json({
                    success: false,
                    error: 'User not found or inactive'
                });
            }

            const user = users[0];
            
            if (roles.length > 0 && !roles.includes(user.role)) {
                return res.status(403).json({
                    success: false,
                    error: 'Insufficient permissions'
                });
            }

            req.user = user;
            next();
        } catch (error) {
            console.error('Auth middleware error:', error);
            res.status(500).json({
                success: false,
                error: 'Authentication error'
            });
        }
    };
};

// Routes

// Serve login page or redirect based on authentication
app.get('/', (req, res) => {
    if (req.session.userId) {
        res.sendFile(path.join(__dirname, 'index.html'));
    } else {
        res.sendFile(path.join(__dirname, 'login.html'));
    }
});

// Serve dashboard HTML files
app.get('/superadmin.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'superadmin.html'));
});

app.get('/partner-dashboard.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'partner-dashboard.html'));
});

app.get('/client-dashboard.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'client-dashboard.html'));
});

// Serve survey preview page
app.get('/survey-preview.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'survey-preview.html'));
});

// === AUTHENTICATION API ENDPOINTS ===

// Login endpoint
app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password, expectedRole } = req.body;
        
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                error: 'Email and password are required'
            });
        }

        if (!expectedRole) {
            return res.status(400).json({
                success: false,
                error: 'Please select your role'
            });
        }

        // Find user by email
        const [users] = await pool.execute(
            'SELECT * FROM users WHERE email = ? AND is_active = TRUE',
            [email.toLowerCase().trim()]
        );

        console.log('Login attempt:', {
            email: email.toLowerCase().trim(),
            expectedRole,
            foundUsers: users.length
        });

        if (users.length === 0) {
            console.log('No user found for email:', email);
            return res.status(401).json({
                success: false,
                error: 'Invalid credentials or role mismatch'
            });
        }

        const user = users[0];
        console.log('Found user:', {
            email: user.email,
            role: user.role,
            expectedRole,
            hasPassword: !!user.password_hash
        });

        // Verify password
        const passwordMatch = await bcrypt.compare(password, user.password_hash);
        console.log('Password match result:', passwordMatch);
        
        if (!passwordMatch) {
            console.log('Password mismatch for user:', user.email);
            return res.status(401).json({
                success: false,
                error: 'Invalid credentials or role mismatch'
            });
        }

        // Verify role matches
        if (user.role !== expectedRole) {
            console.log('Role mismatch:', { userRole: user.role, expectedRole });
            return res.status(401).json({
                success: false,
                error: `Account not found for the selected role. This email is registered as a ${user.role}.`
            });
        }

        // Create session
        req.session.userId = user.id;
        req.session.userRole = user.role;

        // Update last login
        await pool.execute(
            'UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?',
            [user.id]
        );

        // Return user info (without password)
        const { password_hash, ...userInfo } = user;
        
        res.json({
            success: true,
            message: 'Login successful',
            user: userInfo
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({
            success: false,
            error: 'Server error during login'
        });
    }
});

// Logout endpoint
app.post('/api/auth/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            console.error('Logout error:', err);
            return res.status(500).json({
                success: false,
                error: 'Error during logout'
            });
        }
        
        res.clearCookie('connect.sid');
        res.json({
            success: true,
            message: 'Logout successful'
        });
    });
});

// Get current user info
app.get('/api/auth/user', requireAuth(), async (req, res) => {
    try {
        const { password_hash, ...userInfo } = req.user;
        res.json({
            success: true,
            user: userInfo
        });
    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({
            success: false,
            error: 'Error fetching user info'
        });
    }
});

// Check authentication status
app.get('/api/auth/status', (req, res) => {
    res.json({
        success: true,
        authenticated: !!req.session.userId,
        role: req.session.userRole || null
    });
});

// Database migration endpoint (temporary - for development use)
app.post('/api/migrate', async (req, res) => {
    try {
        // Check if users table already exists
        const [existing] = await pool.execute(`
            SELECT COUNT(*) as count 
            FROM information_schema.tables 
            WHERE table_schema = 'sustainability_survey' 
            AND table_name = 'users'
        `);

        if (existing[0].count > 0) {
            return res.json({
                success: true,
                message: 'Migration already completed - users table exists'
            });
        }

        // First create the required tables that users table references
        // Create client_partners table
        await pool.execute(`
            CREATE TABLE IF NOT EXISTS client_partners (
                id INT PRIMARY KEY AUTO_INCREMENT,
                name VARCHAR(255) NOT NULL,
                description TEXT,
                contact_email VARCHAR(255),
                contact_phone VARCHAR(50),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `);

        // Create clients table
        await pool.execute(`
            CREATE TABLE IF NOT EXISTS clients (
                id INT PRIMARY KEY AUTO_INCREMENT,
                client_partner_id INT NOT NULL,
                name VARCHAR(255) NOT NULL,
                industry VARCHAR(100),
                size ENUM('Small', 'Medium', 'Large', 'Enterprise') DEFAULT 'Medium',
                contact_email VARCHAR(255),
                contact_phone VARCHAR(50),
                address TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (client_partner_id) REFERENCES client_partners(id) ON DELETE CASCADE
            )
        `);

        // Create vendors table
        await pool.execute(`
            CREATE TABLE IF NOT EXISTS vendors (
                id INT PRIMARY KEY AUTO_INCREMENT,
                name VARCHAR(255) NOT NULL,
                industry VARCHAR(100),
                vendor_type VARCHAR(100),
                contact_email VARCHAR(255),
                contact_phone VARCHAR(50),
                address TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `);

        // Insert some sample data for the referenced tables
        await pool.execute(`
            INSERT IGNORE INTO client_partners (id, name, description, contact_email) VALUES
            (1, 'GreenTech Consulting', 'Sustainability consulting firm', 'contact@greentech.com'),
            (2, 'EcoPartners Group', 'Environmental compliance services', 'info@ecopartners.com')
        `);

        await pool.execute(`
            INSERT IGNORE INTO clients (id, client_partner_id, name, industry, contact_email) VALUES
            (1, 1, 'TechCorp Manufacturing', 'Technology', 'sustainability@techcorp.com'),
            (3, 2, 'LocalFood Co', 'Food & Beverage', 'green@localfood.com')
        `);

        await pool.execute(`
            INSERT IGNORE INTO vendors (id, name, industry, vendor_type, contact_email) VALUES
            (1, 'SteelWorks Ltd', 'Manufacturing', 'Supplier', 'contact@steelworks.com'),
            (2, 'CleanEnergy Solutions', 'Energy', 'Service Provider', 'info@cleanenergy.com')
        `);

        // Now create users table
        await pool.execute(`
            CREATE TABLE users (
                id INT PRIMARY KEY AUTO_INCREMENT,
                email VARCHAR(255) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL,
                role ENUM('superadmin', 'client_partner', 'client', 'vendor') NOT NULL,
                name VARCHAR(255) NOT NULL,
                phone VARCHAR(50),
                address TEXT,
                is_active BOOLEAN DEFAULT TRUE,
                last_login TIMESTAMP NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                
                client_partner_id INT NULL,
                client_id INT NULL,
                vendor_id INT NULL,
                
                FOREIGN KEY (client_partner_id) REFERENCES client_partners(id) ON DELETE SET NULL,
                FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL,
                FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE SET NULL
            )
        `);

        // Create sessions table
        await pool.execute(`
            CREATE TABLE user_sessions (
                id VARCHAR(255) PRIMARY KEY,
                user_id INT NOT NULL,
                expires_at TIMESTAMP NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            )
        `);

        // Insert sample users with bcrypt password hash for 'password123'
        const passwordHash = '$2b$10$rOzWqIH6B4WbXhbG.LKe0uQs5Y4g1ZT8vQz/6A9XY5.JKWN8E9XYm';

        const sampleUsers = [
            // SuperAdmin
            ['admin@sustainedit.com', passwordHash, 'superadmin', 'Sarah Johnson', '+1 (555) 001-2345', '123 Admin Street, Suite 500, San Francisco, CA 94105', null, null, null],
            // Client Partners
            ['partner@greentech.com', passwordHash, 'client_partner', 'Michael Chen', '+1 (555) 101-2345', '456 Sustainability Blvd, Floor 8, Portland, OR 97201', 1, null, null],
            ['partner@ecopartners.com', passwordHash, 'client_partner', 'Lisa Anderson', '+1 (555) 102-2345', '987 Green Valley Road, Suite 200, Denver, CO 80202', 2, null, null],
            // Clients
            ['client@techcorp.com', passwordHash, 'client', 'Emma Rodriguez', '+1 (555) 201-2345', '789 Innovation Drive, Building A, Austin, TX 78701', 1, 1, null],
            ['client@localfood.com', passwordHash, 'client', 'James Wilson', '+1 (555) 202-2345', '654 Farm Fresh Lane, Seattle, WA 98101', 2, 3, null],
            // Vendors
            ['vendor@steelworks.com', passwordHash, 'vendor', 'David Kim', '+1 (555) 301-2345', '321 Industrial Park Way, Cleveland, OH 44115', null, null, 1],
            ['vendor@cleanenergy.com', passwordHash, 'vendor', 'Maria Garcia', '+1 (555) 302-2345', '147 Solar Panel Drive, Phoenix, AZ 85001', null, null, 2]
        ];

        for (const user of sampleUsers) {
            await pool.execute(`
                INSERT INTO users (email, password_hash, role, name, phone, address, client_partner_id, client_id, vendor_id) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            `, user);
        }

        // Add indexes
        await pool.execute('CREATE INDEX idx_users_email ON users(email)');
        await pool.execute('CREATE INDEX idx_users_role ON users(role)');
        await pool.execute('CREATE INDEX idx_sessions_user_id ON user_sessions(user_id)');
        await pool.execute('CREATE INDEX idx_sessions_expires ON user_sessions(expires_at)');

        res.json({
            success: true,
            message: 'Database migration completed successfully',
            usersCreated: sampleUsers.length
        });

    } catch (error) {
        console.error('Migration error:', error);
        res.status(500).json({
            success: false,
            error: 'Migration failed: ' + error.message
        });
    }
});

// Fix password hashes endpoint (temporary - for development use)
app.post('/api/fix-passwords', async (req, res) => {
    try {
        // Generate proper bcrypt hash for 'password123'
        const correctPasswordHash = await bcrypt.hash('password123', 10);
        console.log('Generated password hash:', correctPasswordHash);
        
        // Update all users with the correct password hash
        const [result] = await pool.execute(`
            UPDATE users SET password_hash = ?
        `, [correctPasswordHash]);
        
        console.log('Updated users:', result.affectedRows);
        
        res.json({
            success: true,
            message: 'Password hashes fixed successfully',
            usersUpdated: result.affectedRows,
            newHash: correctPasswordHash
        });
        
    } catch (error) {
        console.error('Password fix error:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fix passwords: ' + error.message
        });
    }
});

// Get questions organized by category for survey preview
app.get('/api/survey-preview', requireAuth(['superadmin']), async (req, res) => {
    try {
        const [questions] = await pool.execute(`
            SELECT * FROM sustainability_questions 
            ORDER BY category, question_order
        `);
        
        // Organize questions by category
        const categories = {};
        questions.forEach(question => {
            if (!categories[question.category]) {
                categories[question.category] = [];
            }
            categories[question.category].push(question);
        });
        
        // Get category names in custom order
        const categoryOrder = [
            'GHG',
            'Energy',
            'Transportation',
            'Water',
            'Eco Impacts',
            'Waste',
            'Materials',
            'Circularity',
            'Employee H&S',
            'Employee Experience',
            'DEI',
            'Community',
            'Customer',
            'Supply Chain',
            'G&L'
        ];
        
        const availableCategories = Object.keys(categories);
        const orderedCategories = categoryOrder.filter(category => 
            availableCategories.includes(category)
        );
        const unorderedCategories = availableCategories.filter(category =>
            !categoryOrder.includes(category)
        ).sort();
        const categoryNames = [...orderedCategories, ...unorderedCategories];
        
        res.json({
            success: true,
            categories: categories,
            categoryNames: categoryNames,
            totalQuestions: questions.length
        });
        
    } catch (error) {
        console.error('Error fetching survey preview:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Health check route for AWS load balancers
app.get('/healthz', (req, res) => {
    res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Get all questions with optional filtering and pagination
app.get('/api/questions', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 100;
        const search = req.query.search || '';
        const category = req.query.category || '';
        const type = req.query.type || '';
        
        const offset = (page - 1) * limit;
        
        let whereConditions = [];
        let queryParams = [];
        
        if (search) {
            whereConditions.push('question_text LIKE ?');
            queryParams.push(`%${search}%`);
        }
        
        if (category) {
            whereConditions.push('category = ?');
            queryParams.push(category);
        }
        
        if (type) {
            whereConditions.push('question_type = ?');
            queryParams.push(type);
        }
        
        const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';
        
        // Get total count
        const countQuery = `SELECT COUNT(*) as total FROM sustainability_questions ${whereClause}`;
        const [countResult] = await pool.execute(countQuery, queryParams);
        const totalCount = countResult[0].total;
        
        // Get questions
        const questionsQuery = `
            SELECT * FROM sustainability_questions 
            ${whereClause}
            ORDER BY category, question_order 
            LIMIT ${limit} OFFSET ${offset}
        `;
        
        const [questions] = await pool.execute(questionsQuery, queryParams);
        
        res.json({
            success: true,
            questions: questions,
            total: totalCount,
            page: page,
            totalPages: Math.ceil(totalCount / limit)
        });
        
    } catch (error) {
        console.error('Error fetching questions:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Get single question by ID
app.get('/api/questions/:id', async (req, res) => {
    try {
        const id = parseInt(req.params.id);
        
        if (!id) {
            return res.status(400).json({
                success: false,
                error: 'Invalid question ID'
            });
        }
        
        const [questions] = await pool.execute(
            'SELECT * FROM sustainability_questions WHERE id = ?',
            [id]
        );
        
        if (questions.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Question not found'
            });
        }
        
        res.json({
            success: true,
            question: questions[0]
        });
        
    } catch (error) {
        console.error('Error fetching question:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Create new question
app.post('/api/questions', async (req, res) => {
    try {
        const {
            category,
            question_order,
            question_text,
            question_type,
            answer_type,
            effort_rating,
            impact_rating,
            max_points
        } = req.body;
        
        // Validate required fields
        const requiredFields = ['category', 'question_order', 'question_text', 'question_type', 'answer_type', 'max_points'];
        
        for (const field of requiredFields) {
            if (!req.body[field] && req.body[field] !== 0) {
                return res.status(400).json({
                    success: false,
                    error: `Field '${field}' is required`
                });
            }
        }
        
        const query = `
            INSERT INTO sustainability_questions 
            (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `;
        
        const [result] = await pool.execute(query, [
            category,
            parseInt(question_order),
            question_text,
            question_type,
            answer_type,
            effort_rating ? parseFloat(effort_rating) : null,
            impact_rating ? parseFloat(impact_rating) : null,
            parseInt(max_points)
        ]);
        
        res.status(201).json({
            success: true,
            id: result.insertId,
            message: 'Question created successfully'
        });
        
    } catch (error) {
        console.error('Error creating question:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Update question
app.put('/api/questions/:id', async (req, res) => {
    try {
        const id = parseInt(req.params.id);
        
        if (!id) {
            return res.status(400).json({
                success: false,
                error: 'Invalid question ID'
            });
        }
        
        // For partial updates (like reordering), only validate question_order if other fields are missing  
        const hasOnlyOrder = Object.keys(req.body).length === 1 && 'question_order' in req.body;
        
        const {
            category,
            question_order,
            question_text,
            question_type,
            answer_type,
            effort_rating,
            impact_rating,
            max_points
        } = req.body;
        
        if (!hasOnlyOrder) {
            // Validate required fields for full updates
            const requiredFields = ['category', 'question_order', 'question_text', 'question_type', 'answer_type', 'max_points'];
            
            for (const field of requiredFields) {
                if (!req.body[field] && req.body[field] !== 0) {
                    return res.status(400).json({
                        success: false,
                        error: `Field '${field}' is required`
                    });
                }
            }
        }
        
        // Build dynamic query for partial updates
        let query, params;
        
        if (hasOnlyOrder) {
            // Simple order update
            query = `
                UPDATE sustainability_questions SET 
                question_order = ?,
                updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            `;
            params = [parseInt(question_order), id];
        } else {
            // Full update
            query = `
                UPDATE sustainability_questions SET 
                category = ?,
                question_order = ?,
                question_text = ?,
                question_type = ?,
                answer_type = ?,
                effort_rating = ?,
                impact_rating = ?,
                max_points = ?,
                updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            `;
            params = [
                category,
                parseInt(question_order),
                question_text,
                question_type,
                answer_type,
                effort_rating ? parseFloat(effort_rating) : null,
                impact_rating ? parseFloat(impact_rating) : null,
                parseInt(max_points),
                id
            ];
        }
        
        const [result] = await pool.execute(query, params);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Question not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Question updated successfully'
        });
        
    } catch (error) {
        console.error('Error updating question:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Delete question
app.delete('/api/questions/:id', async (req, res) => {
    try {
        const id = parseInt(req.params.id);
        
        if (!id) {
            return res.status(400).json({
                success: false,
                error: 'Invalid question ID'
            });
        }
        
        const [result] = await pool.execute(
            'DELETE FROM sustainability_questions WHERE id = ?',
            [id]
        );
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Question not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Question deleted successfully'
        });
        
    } catch (error) {
        console.error('Error deleting question:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Get categories
app.get('/api/categories', async (req, res) => {
    try {
        const [categories] = await pool.execute(
            'SELECT DISTINCT category FROM sustainability_questions ORDER BY category'
        );
        
        res.json({
            success: true,
            categories: categories.map(row => row.category)
        });
        
    } catch (error) {
        console.error('Error fetching categories:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Get statistics
app.get('/api/stats', async (req, res) => {
    try {
        const [totalCount] = await pool.execute('SELECT COUNT(*) as total FROM sustainability_questions');
        
        const [categoryStats] = await pool.execute(`
            SELECT category, COUNT(*) as count 
            FROM sustainability_questions 
            GROUP BY category 
            ORDER BY category
        `);
        
        const [typeStats] = await pool.execute(`
            SELECT question_type, COUNT(*) as count 
            FROM sustainability_questions 
            GROUP BY question_type 
            ORDER BY question_type
        `);
        
        res.json({
            success: true,
            stats: {
                total: totalCount[0].total,
                byCategory: categoryStats,
                byType: typeStats
            }
        });
        
    } catch (error) {
        console.error('Error fetching stats:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// === ANNUAL SURVEY SYSTEM API ENDPOINTS ===

// Get all client partners
app.get('/api/client-partners', async (req, res) => {
    try {
        const [partners] = await pool.execute(`
            SELECT cp.*, COUNT(c.id) as client_count
            FROM client_partners cp
            LEFT JOIN clients c ON cp.id = c.client_partner_id
            GROUP BY cp.id
            ORDER BY cp.name
        `);
        
        res.json({
            success: true,
            client_partners: partners
        });
    } catch (error) {
        console.error('Error fetching client partners:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Get clients by partner or all clients
app.get('/api/clients', async (req, res) => {
    try {
        const partnerId = req.query.partner_id;
        let query = `
            SELECT c.*, cp.name as partner_name
            FROM clients c
            JOIN client_partners cp ON c.client_partner_id = cp.id
        `;
        let params = [];
        
        if (partnerId) {
            query += ' WHERE c.client_partner_id = ?';
            params.push(partnerId);
        }
        
        query += ' ORDER BY c.name';
        
        const [clients] = await pool.execute(query, params);
        
        res.json({
            success: true,
            clients: clients
        });
    } catch (error) {
        console.error('Error fetching clients:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Get all vendors
app.get('/api/vendors', async (req, res) => {
    try {
        const [vendors] = await pool.execute(`
            SELECT v.*, COUNT(asv.id) as survey_count
            FROM vendors v
            LEFT JOIN annual_surveys asv ON v.id = asv.vendor_id
            GROUP BY v.id
            ORDER BY v.name
        `);
        
        res.json({
            success: true,
            vendors: vendors
        });
    } catch (error) {
        console.error('Error fetching vendors:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Get all annual surveys with filtering
app.get('/api/annual-surveys', async (req, res) => {
    try {
        const { year, status, client_id, vendor_id, partner_id } = req.query;
        
        let whereConditions = [];
        let queryParams = [];
        
        if (year) {
            whereConditions.push('asv.survey_year = ?');
            queryParams.push(year);
        }
        if (status) {
            whereConditions.push('asv.status = ?');
            queryParams.push(status);
        }
        if (client_id) {
            whereConditions.push('asv.client_id = ?');
            queryParams.push(client_id);
        }
        if (vendor_id) {
            whereConditions.push('asv.vendor_id = ?');
            queryParams.push(vendor_id);
        }
        if (partner_id) {
            whereConditions.push('asv.client_partner_id = ?');
            queryParams.push(partner_id);
        }
        
        const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';
        
        const query = `
            SELECT 
                asv.*,
                cp.name as partner_name,
                c.name as client_name,
                v.name as vendor_name,
                COUNT(sq.id) as question_count,
                COUNT(CASE WHEN sq.answer_value IS NOT NULL THEN 1 END) as answered_count
            FROM annual_surveys asv
            JOIN client_partners cp ON asv.client_partner_id = cp.id
            JOIN clients c ON asv.client_id = c.id
            JOIN vendors v ON asv.vendor_id = v.id
            LEFT JOIN survey_questions sq ON asv.id = sq.annual_survey_id
            ${whereClause}
            GROUP BY asv.id
            ORDER BY asv.survey_year DESC, asv.created_at DESC
        `;
        
        const [surveys] = await pool.execute(query, queryParams);
        
        res.json({
            success: true,
            annual_surveys: surveys
        });
    } catch (error) {
        console.error('Error fetching annual surveys:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Get single annual survey with all details
app.get('/api/annual-surveys/:id', async (req, res) => {
    try {
        const surveyId = parseInt(req.params.id);
        
        // Get survey details
        const [surveys] = await pool.execute(`
            SELECT 
                asv.*,
                cp.name as partner_name,
                c.name as client_name, c.industry as client_industry,
                v.name as vendor_name, v.industry as vendor_industry
            FROM annual_surveys asv
            JOIN client_partners cp ON asv.client_partner_id = cp.id
            JOIN clients c ON asv.client_id = c.id
            JOIN vendors v ON asv.vendor_id = v.id
            WHERE asv.id = ?
        `, [surveyId]);
        
        if (surveys.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Annual survey not found'
            });
        }
        
        // Get survey questions
        const [questions] = await pool.execute(`
            SELECT 
                sq.*,
                q.category, q.question_text, q.question_type, q.answer_type, q.max_points
            FROM survey_questions sq
            JOIN sustainability_questions q ON sq.question_id = q.id
            WHERE sq.annual_survey_id = ?
            ORDER BY sq.question_order
        `, [surveyId]);
        
        const survey = surveys[0];
        survey.questions = questions;
        
        res.json({
            success: true,
            annual_survey: survey
        });
    } catch (error) {
        console.error('Error fetching annual survey:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Create new annual survey
app.post('/api/annual-surveys', async (req, res) => {
    try {
        const {
            client_partner_id,
            client_id,
            vendor_id,
            survey_year,
            survey_name,
            description,
            start_date,
            end_date,
            include_all_questions = true,
            question_ids = []
        } = req.body;
        
        // Validate required fields
        const requiredFields = ['client_partner_id', 'client_id', 'vendor_id', 'survey_year', 'survey_name'];
        
        for (const field of requiredFields) {
            if (!req.body[field]) {
                return res.status(400).json({
                    success: false,
                    error: `Field '${field}' is required`
                });
            }
        }
        
        // Create the annual survey
        const [surveyResult] = await pool.execute(`
            INSERT INTO annual_surveys 
            (client_partner_id, client_id, vendor_id, survey_year, survey_name, description, start_date, end_date) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `, [client_partner_id, client_id, vendor_id, survey_year, survey_name, description, start_date, end_date]);
        
        const surveyId = surveyResult.insertId;
        
        // Add questions to the survey
        let questionsToAdd = [];
        
        if (include_all_questions) {
            // Get all questions ordered by category and question_order
            const [allQuestions] = await pool.execute(`
                SELECT id, max_points FROM sustainability_questions 
                ORDER BY category, question_order
            `);
            questionsToAdd = allQuestions;
        } else if (question_ids && question_ids.length > 0) {
            // Get specified questions
            const placeholders = question_ids.map(() => '?').join(',');
            const [selectedQuestions] = await pool.execute(`
                SELECT id, max_points FROM sustainability_questions 
                WHERE id IN (${placeholders})
                ORDER BY category, question_order
            `, question_ids);
            questionsToAdd = selectedQuestions;
        }
        
        // Insert survey questions
        let totalPossiblePoints = 0;
        for (let i = 0; i < questionsToAdd.length; i++) {
            const question = questionsToAdd[i];
            totalPossiblePoints += question.max_points || 0;
            
            await pool.execute(`
                INSERT INTO survey_questions 
                (annual_survey_id, question_id, question_order) 
                VALUES (?, ?, ?)
            `, [surveyId, question.id, i + 1]);
        }
        
        // Update survey with total possible points
        await pool.execute(`
            UPDATE annual_surveys 
            SET total_possible_points = ? 
            WHERE id = ?
        `, [totalPossiblePoints, surveyId]);
        
        res.status(201).json({
            success: true,
            id: surveyId,
            message: 'Annual survey created successfully',
            questions_added: questionsToAdd.length
        });
        
    } catch (error) {
        console.error('Error creating annual survey:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Update annual survey
app.put('/api/annual-surveys/:id', async (req, res) => {
    try {
        const surveyId = parseInt(req.params.id);
        const {
            survey_name,
            description,
            status,
            start_date,
            end_date,
            completion_percentage,
            actual_points_earned
        } = req.body;
        
        const [result] = await pool.execute(`
            UPDATE annual_surveys SET 
            survey_name = COALESCE(?, survey_name),
            description = COALESCE(?, description),
            status = COALESCE(?, status),
            start_date = COALESCE(?, start_date),
            end_date = COALESCE(?, end_date),
            completion_percentage = COALESCE(?, completion_percentage),
            actual_points_earned = COALESCE(?, actual_points_earned),
            updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `, [survey_name, description, status, start_date, end_date, completion_percentage, actual_points_earned, surveyId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Annual survey not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Annual survey updated successfully'
        });
        
    } catch (error) {
        console.error('Error updating annual survey:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Update survey question answer
app.put('/api/survey-questions/:id/answer', async (req, res) => {
    try {
        const questionId = parseInt(req.params.id);
        const { answer_value, points_earned, notes } = req.body;
        
        const [result] = await pool.execute(`
            UPDATE survey_questions SET 
            answer_value = ?,
            points_earned = COALESCE(?, points_earned),
            notes = COALESCE(?, notes),
            answered_at = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `, [answer_value, points_earned, notes, questionId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Survey question not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Survey question answer updated successfully'
        });
        
    } catch (error) {
        console.error('Error updating survey question answer:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Create new client partner
app.post('/api/client-partners', async (req, res) => {
    try {
        const { name, description, contact_email, contact_phone } = req.body;
        
        if (!name) {
            return res.status(400).json({
                success: false,
                error: 'Partner name is required'
            });
        }
        
        const [result] = await pool.execute(`
            INSERT INTO client_partners (name, description, contact_email, contact_phone) 
            VALUES (?, ?, ?, ?)
        `, [name, description, contact_email, contact_phone]);
        
        res.status(201).json({
            success: true,
            id: result.insertId,
            message: 'Client partner created successfully'
        });
        
    } catch (error) {
        console.error('Error creating client partner:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Update client partner
app.put('/api/client-partners/:id', async (req, res) => {
    try {
        const partnerId = parseInt(req.params.id);
        const { name, description, contact_email, contact_phone } = req.body;
        
        if (!name) {
            return res.status(400).json({
                success: false,
                error: 'Partner name is required'
            });
        }
        
        const [result] = await pool.execute(`
            UPDATE client_partners SET 
            name = ?,
            description = ?,
            contact_email = ?,
            contact_phone = ?,
            updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `, [name, description, contact_email, contact_phone, partnerId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Client partner not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Client partner updated successfully'
        });
        
    } catch (error) {
        console.error('Error updating client partner:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Delete client partner
app.delete('/api/client-partners/:id', async (req, res) => {
    try {
        const partnerId = parseInt(req.params.id);
        
        const [result] = await pool.execute(`
            DELETE FROM client_partners WHERE id = ?
        `, [partnerId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Client partner not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Client partner deleted successfully'
        });
        
    } catch (error) {
        console.error('Error deleting client partner:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Create new client
app.post('/api/clients', async (req, res) => {
    try {
        const { client_partner_id, name, industry, size, contact_email, contact_phone, address } = req.body;
        
        const requiredFields = ['client_partner_id', 'name'];
        for (const field of requiredFields) {
            if (!req.body[field]) {
                return res.status(400).json({
                    success: false,
                    error: `Field '${field}' is required`
                });
            }
        }
        
        const [result] = await pool.execute(`
            INSERT INTO clients (client_partner_id, name, industry, size, contact_email, contact_phone, address) 
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [client_partner_id, name, industry, size, contact_email, contact_phone, address]);
        
        res.status(201).json({
            success: true,
            id: result.insertId,
            message: 'Client created successfully'
        });
        
    } catch (error) {
        console.error('Error creating client:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Update client
app.put('/api/clients/:id', async (req, res) => {
    try {
        const clientId = parseInt(req.params.id);
        const { name, industry, size, contact_email, contact_phone, address } = req.body;
        
        if (!name) {
            return res.status(400).json({
                success: false,
                error: 'Client name is required'
            });
        }
        
        const [result] = await pool.execute(`
            UPDATE clients SET 
            name = ?,
            industry = ?,
            size = ?,
            contact_email = ?,
            contact_phone = ?,
            address = ?,
            updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `, [name, industry, size, contact_email, contact_phone, address, clientId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Client not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Client updated successfully'
        });
        
    } catch (error) {
        console.error('Error updating client:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Delete client
app.delete('/api/clients/:id', async (req, res) => {
    try {
        const clientId = parseInt(req.params.id);
        
        const [result] = await pool.execute(`
            DELETE FROM clients WHERE id = ?
        `, [clientId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Client not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Client deleted successfully'
        });
        
    } catch (error) {
        console.error('Error deleting client:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Create new vendor
app.post('/api/vendors', async (req, res) => {
    try {
        const { name, industry, vendor_type, contact_email, contact_phone, address } = req.body;
        
        if (!name) {
            return res.status(400).json({
                success: false,
                error: 'Vendor name is required'
            });
        }
        
        const [result] = await pool.execute(`
            INSERT INTO vendors (name, industry, vendor_type, contact_email, contact_phone, address) 
            VALUES (?, ?, ?, ?, ?, ?)
        `, [name, industry, vendor_type, contact_email, contact_phone, address]);
        
        res.status(201).json({
            success: true,
            id: result.insertId,
            message: 'Vendor created successfully'
        });
        
    } catch (error) {
        console.error('Error creating vendor:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Update vendor
app.put('/api/vendors/:id', async (req, res) => {
    try {
        const vendorId = parseInt(req.params.id);
        const { name, industry, vendor_type, contact_email, contact_phone, address } = req.body;
        
        if (!name) {
            return res.status(400).json({
                success: false,
                error: 'Vendor name is required'
            });
        }
        
        const [result] = await pool.execute(`
            UPDATE vendors SET 
            name = ?,
            industry = ?,
            vendor_type = ?,
            contact_email = ?,
            contact_phone = ?,
            address = ?,
            updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `, [name, industry, vendor_type, contact_email, contact_phone, address, vendorId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Vendor not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Vendor updated successfully'
        });
        
    } catch (error) {
        console.error('Error updating vendor:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Delete vendor
app.delete('/api/vendors/:id', async (req, res) => {
    try {
        const vendorId = parseInt(req.params.id);
        
        const [result] = await pool.execute(`
            DELETE FROM vendors WHERE id = ?
        `, [vendorId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Vendor not found'
            });
        }
        
        res.json({
            success: true,
            message: 'Vendor deleted successfully'
        });
        
    } catch (error) {
        console.error('Error deleting vendor:', error);
        res.status(500).json({
            success: false,
            error: 'Database error: ' + error.message
        });
    }
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Unhandled error:', err);
    res.status(500).json({
        success: false,
        error: 'Internal server error'
    });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        success: false,
        error: 'Endpoint not found'
    });
});

// Start server
app.listen(PORT, '0.0.0.0', async () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
    await testConnection();
    console.log('📝 CRUD Editor available at http://localhost:3000');
});

// Graceful shutdown
process.on('SIGINT', async () => {
    console.log('\n🛑 Shutting down server...');
    await pool.end();
    process.exit(0);
});