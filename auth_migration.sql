-- Authentication System Migration
-- This script adds user authentication with role-based access control

-- Create users table
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
    
    -- Role-specific foreign keys (nullable based on role)
    client_partner_id INT NULL, -- For client_partner and client roles
    client_id INT NULL,          -- For client role only
    vendor_id INT NULL,          -- For vendor role only
    
    -- Foreign key constraints
    FOREIGN KEY (client_partner_id) REFERENCES client_partners(id) ON DELETE SET NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE SET NULL
);

-- Create sessions table for session management
CREATE TABLE user_sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id INT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Sample User Accounts
-- Note: In production, passwords should be properly hashed. These are bcrypt hashes for 'password123'

-- SuperAdmin Account
INSERT INTO users (email, password_hash, role, name, phone, address) VALUES
('admin@sustainedit.com', '$2b$10$rOzWqIH6B4WbXhbG.LKe0uQs5Y4g1ZT8vQz/6A9XY5.JKWN8E9XYm', 'superadmin', 'Sarah Johnson', '+1 (555) 001-2345', '123 Admin Street, Suite 500, San Francisco, CA 94105');

-- Client Partner Account (linked to existing partner)
INSERT INTO users (email, password_hash, role, name, phone, address, client_partner_id) VALUES
('partner@greentech.com', '$2b$10$rOzWqIH6B4WbXhbG.LKe0uQs5Y4g1ZT8vQz/6A9XY5.JKWN8E9XYm', 'client_partner', 'Michael Chen', '+1 (555) 101-2345', '456 Sustainability Blvd, Floor 8, Portland, OR 97201', 1);

-- Client Account (linked to existing client)
INSERT INTO users (email, password_hash, role, name, phone, address, client_partner_id, client_id) VALUES
('client@techcorp.com', '$2b$10$rOzWqIH6B4WbXhbG.LKe0uQs5Y4g1ZT8vQz/6A9XY5.JKWN8E9XYm', 'client', 'Emma Rodriguez', '+1 (555) 201-2345', '789 Innovation Drive, Building A, Austin, TX 78701', 1, 1);

-- Vendor Account (linked to existing vendor)
INSERT INTO users (email, password_hash, role, name, phone, address, vendor_id) VALUES
('vendor@steelworks.com', '$2b$10$rOzWqIH6B4WbXhbG.LKe0uQs5Y4g1ZT8vQz/6A9XY5.JKWN8E9XYm', 'vendor', 'David Kim', '+1 (555) 301-2345', '321 Industrial Park Way, Cleveland, OH 44115');

-- Additional sample accounts for variety

-- Another Client Partner
INSERT INTO users (email, password_hash, role, name, phone, address, client_partner_id) VALUES
('partner@ecopartners.com', '$2b$10$rOzWqIH6B4WbXhbG.LKe0uQs5Y4g1ZT8vQz/6A9XY5.JKWN8E9XYm', 'client_partner', 'Lisa Anderson', '+1 (555) 102-2345', '987 Green Valley Road, Suite 200, Denver, CO 80202', 2);

-- Another Client
INSERT INTO users (email, password_hash, role, name, phone, address, client_partner_id, client_id) VALUES
('client@localfood.com', '$2b$10$rOzWqIH6B4WbXhbG.LKe0uQs5Y4g1ZT8vQz/6A9XY5.JKWN8E9XYm', 'client', 'James Wilson', '+1 (555) 202-2345', '654 Farm Fresh Lane, Seattle, WA 98101', 2, 3);

-- Another Vendor
INSERT INTO users (email, password_hash, role, name, phone, address, vendor_id) VALUES
('vendor@cleanenergy.com', '$2b$10$rOzWqIH6B4WbXhbG.LKe0uQs5Y4g1ZT8vQz/6A9XY5.JKWN8E9XYm', 'vendor', 'Maria Garcia', '+1 (555) 302-2345', '147 Solar Panel Drive, Phoenix, AZ 85001', 2);

-- Add indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_sessions_expires ON user_sessions(expires_at);

-- Sample login credentials for testing:
-- SuperAdmin: admin@sustainedit.com / password123
-- Client Partner: partner@greentech.com / password123
-- Client: client@techcorp.com / password123
-- Vendor: vendor@steelworks.com / password123