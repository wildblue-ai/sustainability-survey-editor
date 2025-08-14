-- Enhanced Survey System (Simplified - No Triggers/Functions)
-- Implements survey lifecycle with audit trail and locking
-- Date: 2025-08-13

USE sustainability_survey;

-- 1. Create survey templates table (client partner level)
CREATE TABLE IF NOT EXISTS survey_templates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_partner_id INT NOT NULL,
    template_name VARCHAR(255) NOT NULL,
    survey_year YEAR NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (client_partner_id) REFERENCES client_partners(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    
    UNIQUE KEY unique_template_per_partner_year (client_partner_id, survey_year),
    INDEX idx_template_year (survey_year),
    INDEX idx_template_partner (client_partner_id)
);

-- 2. Create template questions table
CREATE TABLE IF NOT EXISTS survey_template_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    survey_template_id INT NOT NULL,
    question_id INT NOT NULL,
    question_order INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    custom_config JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (survey_template_id) REFERENCES survey_templates(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES sustainability_questions(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_question_per_template (survey_template_id, question_id),
    INDEX idx_template_question_order (survey_template_id, question_order)
);

-- 3. Add survey lifecycle columns to annual_surveys
ALTER TABLE annual_surveys 
ADD COLUMN survey_template_id INT,
ADD COLUMN survey_status ENUM('draft', 'in_progress', 'submitted', 'approved', 'locked') DEFAULT 'draft',
ADD COLUMN is_shared_survey BOOLEAN DEFAULT FALSE,
ADD COLUMN shared_survey_id INT,
ADD COLUMN submitted_at TIMESTAMP NULL,
ADD COLUMN approved_at TIMESTAMP NULL,
ADD COLUMN approved_by INT,
ADD COLUMN locked_at TIMESTAMP NULL,
ADD COLUMN locked_by INT;

-- 4. Add foreign key constraints (separate from ALTER TABLE to avoid issues)
ALTER TABLE annual_surveys 
ADD CONSTRAINT fk_survey_template FOREIGN KEY (survey_template_id) REFERENCES survey_templates(id);

ALTER TABLE annual_surveys 
ADD CONSTRAINT fk_shared_survey FOREIGN KEY (shared_survey_id) REFERENCES annual_surveys(id);

ALTER TABLE annual_surveys 
ADD CONSTRAINT fk_approved_by FOREIGN KEY (approved_by) REFERENCES users(id);

ALTER TABLE annual_surveys 
ADD CONSTRAINT fk_locked_by FOREIGN KEY (locked_by) REFERENCES users(id);

-- 5. Create survey editing locks table
CREATE TABLE IF NOT EXISTS survey_editing_locks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    annual_survey_id INT NOT NULL UNIQUE,
    locked_by_user_id INT NOT NULL,
    locked_by_vendor_id INT NOT NULL,
    user_ip VARCHAR(45),
    locked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    
    FOREIGN KEY (annual_survey_id) REFERENCES annual_surveys(id) ON DELETE CASCADE,
    FOREIGN KEY (locked_by_user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (locked_by_vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    
    INDEX idx_survey_lock (annual_survey_id),
    INDEX idx_lock_user (locked_by_user_id),
    INDEX idx_lock_expires (expires_at)
);

-- 6. Create survey answer audit trail
CREATE TABLE IF NOT EXISTS survey_answer_audit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    survey_question_id INT NOT NULL,
    changed_by_user_id INT NOT NULL,
    change_type ENUM('created', 'updated', 'deleted', 'status_change') NOT NULL,
    previous_value JSON,
    new_value JSON,
    previous_points INT,
    new_points INT,
    user_ip VARCHAR(45),
    user_agent TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (survey_question_id) REFERENCES survey_questions(id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by_user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_audit_survey_question (survey_question_id),
    INDEX idx_audit_user (changed_by_user_id),
    INDEX idx_audit_date (changed_at),
    INDEX idx_audit_change_type (change_type)
);

-- 7. Add previous year reference to survey_questions
ALTER TABLE survey_questions
ADD COLUMN previous_year_answer JSON,
ADD COLUMN previous_year_survey_id INT;

ALTER TABLE survey_questions
ADD CONSTRAINT fk_prev_year_survey FOREIGN KEY (previous_year_survey_id) REFERENCES survey_questions(id);

-- 8. Create performance indexes
CREATE INDEX idx_annual_surveys_status ON annual_surveys(survey_status);
CREATE INDEX idx_annual_surveys_shared ON annual_surveys(is_shared_survey, shared_survey_id);
CREATE INDEX idx_annual_surveys_template ON annual_surveys(survey_template_id);