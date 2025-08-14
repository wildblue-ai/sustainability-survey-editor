-- Create Annual Survey System Tables
-- Creates the core survey management tables
-- Date: 2025-08-13

USE sustainability_survey;

-- 1. Create annual_surveys table
CREATE TABLE IF NOT EXISTS annual_surveys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_partner_id INT NOT NULL,
    client_id INT NOT NULL,
    vendor_id INT NOT NULL,
    survey_year YEAR NOT NULL,
    survey_name VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('draft', 'active', 'completed', 'archived') DEFAULT 'draft',
    start_date DATE,
    end_date DATE,
    total_possible_points INT DEFAULT 0,
    actual_points_earned INT DEFAULT 0,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (client_partner_id) REFERENCES client_partners(id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_survey_per_vendor_year (vendor_id, client_id, survey_year),
    INDEX idx_survey_year (survey_year),
    INDEX idx_survey_status (status),
    INDEX idx_client_partner (client_partner_id),
    INDEX idx_client (client_id),
    INDEX idx_vendor (vendor_id)
);

-- 2. Create survey_questions table (links surveys to specific questions with answers)
CREATE TABLE IF NOT EXISTS survey_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    annual_survey_id INT NOT NULL,
    question_id INT NOT NULL,
    question_order INT NOT NULL,
    answer_value TEXT,
    points_earned INT DEFAULT 0,
    notes TEXT,
    answered_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (annual_survey_id) REFERENCES annual_surveys(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES sustainability_questions(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_question_per_survey (annual_survey_id, question_id),
    INDEX idx_survey_question_order (annual_survey_id, question_order),
    INDEX idx_question_answered (answered_at),
    INDEX idx_annual_survey (annual_survey_id),
    INDEX idx_question (question_id)
);