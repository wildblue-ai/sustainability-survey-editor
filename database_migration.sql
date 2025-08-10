-- Annual Survey Database Schema Migration
-- This script adds tables for managing annual surveys with client partnerships, clients, vendors, and question sets

-- Create client_partners table (highest level - organizations that manage multiple clients)
CREATE TABLE client_partners (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create clients table (individual clients under a partner)
CREATE TABLE clients (
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
);

-- Create vendors table (suppliers/vendors being assessed)
CREATE TABLE vendors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    industry VARCHAR(100),
    vendor_type VARCHAR(100), -- e.g., 'Supplier', 'Service Provider', 'Contractor'
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create annual_surveys table (main survey entity)
CREATE TABLE annual_surveys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_partner_id INT NOT NULL,
    client_id INT NOT NULL,
    vendor_id INT NOT NULL,
    survey_year YEAR NOT NULL,
    survey_name VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('Draft', 'Active', 'Completed', 'Archived') DEFAULT 'Draft',
    start_date DATE,
    end_date DATE,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00, -- 0.00 to 100.00
    total_possible_points INT DEFAULT 0,
    actual_points_earned INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_partner_id) REFERENCES client_partners(id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    UNIQUE KEY unique_survey (client_id, vendor_id, survey_year) -- One survey per client-vendor-year combination
);

-- Create survey_questions junction table (links surveys to specific questions)
CREATE TABLE survey_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    annual_survey_id INT NOT NULL,
    question_id INT NOT NULL,
    question_order INT NOT NULL, -- Order within this specific survey (can differ from global order)
    is_required BOOLEAN DEFAULT TRUE,
    weight_multiplier DECIMAL(3,2) DEFAULT 1.00, -- Allow weighting questions differently per survey
    answer_value TEXT, -- Store the actual answer for this survey
    points_earned INT DEFAULT 0,
    notes TEXT,
    answered_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (annual_survey_id) REFERENCES annual_surveys(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES sustainability_questions(id) ON DELETE CASCADE,
    UNIQUE KEY unique_survey_question (annual_survey_id, question_id)
);

-- Add some sample data to get started

-- Sample Client Partners
INSERT INTO client_partners (name, description, contact_email) VALUES
('GreenTech Consulting', 'Sustainability consulting firm specializing in supply chain assessment', 'contact@greentech.com'),
('EcoPartners Group', 'Environmental compliance and sustainability services', 'info@ecopartners.com'),
('Sustainable Solutions Inc', 'Corporate sustainability and ESG advisory services', 'hello@sustainablesolutions.com');

-- Sample Clients
INSERT INTO clients (client_partner_id, name, industry, size, contact_email) VALUES
(1, 'TechCorp Manufacturing', 'Technology', 'Large', 'sustainability@techcorp.com'),
(1, 'Global Retail Chain', 'Retail', 'Enterprise', 'esg@globalretail.com'),
(2, 'LocalFood Co', 'Food & Beverage', 'Medium', 'green@localfood.com'),
(3, 'BuildRight Construction', 'Construction', 'Large', 'enviro@buildright.com');

-- Sample Vendors
INSERT INTO vendors (name, industry, vendor_type, contact_email) VALUES
('SteelWorks Ltd', 'Manufacturing', 'Supplier', 'contact@steelworks.com'),
('CleanEnergy Solutions', 'Energy', 'Service Provider', 'info@cleanenergy.com'),
('EcoPackaging Corp', 'Packaging', 'Supplier', 'sales@ecopackaging.com'),
('GreenLogistics', 'Transportation', 'Service Provider', 'ops@greenlogistics.com'),
('SustainableMaterials Inc', 'Materials', 'Supplier', 'support@sustainablematerials.com');

-- Sample Annual Surveys
INSERT INTO annual_surveys (client_partner_id, client_id, vendor_id, survey_year, survey_name, description, status, start_date, end_date) VALUES
(1, 1, 1, 2024, 'TechCorp - SteelWorks Sustainability Assessment 2024', 'Annual sustainability evaluation of steel supplier', 'Active', '2024-01-15', '2024-03-31'),
(1, 1, 2, 2024, 'TechCorp - CleanEnergy Sustainability Assessment 2024', 'Annual sustainability evaluation of energy provider', 'Draft', '2024-02-01', '2024-04-30'),
(2, 3, 3, 2024, 'LocalFood - EcoPackaging Sustainability Assessment 2024', 'Annual sustainability evaluation of packaging supplier', 'Completed', '2024-01-01', '2024-02-29'),
(3, 4, 4, 2024, 'BuildRight - GreenLogistics Sustainability Assessment 2024', 'Annual sustainability evaluation of logistics provider', 'Active', '2024-01-10', '2024-03-15');

-- Add indexes for better performance
CREATE INDEX idx_clients_partner ON clients(client_partner_id);
CREATE INDEX idx_surveys_client ON annual_surveys(client_id);
CREATE INDEX idx_surveys_vendor ON annual_surveys(vendor_id);
CREATE INDEX idx_surveys_year ON annual_surveys(survey_year);
CREATE INDEX idx_surveys_status ON annual_surveys(status);
CREATE INDEX idx_survey_questions_survey ON survey_questions(annual_survey_id);
CREATE INDEX idx_survey_questions_question ON survey_questions(question_id);