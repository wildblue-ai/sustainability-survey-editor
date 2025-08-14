-- Enhanced Survey System with Locking, Audit Trail, and Templates
-- Implements complete survey lifecycle with audit trail and locking
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
    created_by INT, -- user who created template
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (client_partner_id) REFERENCES client_partners(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    
    UNIQUE KEY unique_template_per_partner_year (client_partner_id, survey_year),
    INDEX idx_template_year (survey_year),
    INDEX idx_template_partner (client_partner_id)
);

-- 2. Create template questions table (which questions are included in each template)
CREATE TABLE IF NOT EXISTS survey_template_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    survey_template_id INT NOT NULL,
    question_id INT NOT NULL,
    question_order INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    custom_config JSON, -- template-specific question configuration
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (survey_template_id) REFERENCES survey_templates(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES sustainability_questions(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_question_per_template (survey_template_id, question_id),
    INDEX idx_template_question_order (survey_template_id, question_order)
);

-- 3. Add survey lifecycle and sharing to annual_surveys
ALTER TABLE annual_surveys 
ADD COLUMN survey_template_id INT,
ADD COLUMN survey_status ENUM('draft', 'in_progress', 'submitted', 'approved', 'locked') DEFAULT 'draft',
ADD COLUMN is_shared_survey BOOLEAN DEFAULT FALSE,
ADD COLUMN shared_survey_id INT, -- points to the "master" survey if this is a shared instance
ADD COLUMN submitted_at TIMESTAMP NULL,
ADD COLUMN approved_at TIMESTAMP NULL,
ADD COLUMN approved_by INT, -- user who approved
ADD COLUMN locked_at TIMESTAMP NULL,
ADD COLUMN locked_by INT, -- user who locked
ADD CONSTRAINT fk_survey_template FOREIGN KEY (survey_template_id) REFERENCES survey_templates(id),
ADD CONSTRAINT fk_shared_survey FOREIGN KEY (shared_survey_id) REFERENCES annual_surveys(id),
ADD CONSTRAINT fk_approved_by FOREIGN KEY (approved_by) REFERENCES users(id),
ADD CONSTRAINT fk_locked_by FOREIGN KEY (locked_by) REFERENCES users(id);

-- 4. Create survey editing locks table
CREATE TABLE IF NOT EXISTS survey_editing_locks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    annual_survey_id INT NOT NULL UNIQUE,
    locked_by_user_id INT NOT NULL,
    locked_by_vendor_id INT NOT NULL,
    user_ip VARCHAR(45), -- supports IPv6
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

-- 5. Create survey answer audit trail
CREATE TABLE IF NOT EXISTS survey_answer_audit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    survey_question_id INT NOT NULL,
    changed_by_user_id INT NOT NULL,
    change_type ENUM('created', 'updated', 'deleted') NOT NULL,
    previous_value JSON, -- previous answer_data
    new_value JSON, -- new answer_data
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

-- 6. Add previous year reference to survey_questions for hints
ALTER TABLE survey_questions
ADD COLUMN previous_year_answer JSON, -- stores previous year's answer for display hints
ADD COLUMN previous_year_survey_id INT, -- reference to previous year's survey question
ADD CONSTRAINT fk_prev_year_survey FOREIGN KEY (previous_year_survey_id) REFERENCES survey_questions(id);

-- 7. Create view for survey sharing analysis
CREATE VIEW survey_sharing_view AS
SELECT 
    master.id as master_survey_id,
    master.survey_name as master_survey_name,
    master.vendor_id as shared_vendor_id,
    v.name as vendor_name,
    cp.name as client_partner_name,
    master.survey_year,
    COUNT(shared.id) as shared_instances,
    GROUP_CONCAT(c.name) as sharing_clients
FROM annual_surveys master
LEFT JOIN annual_surveys shared ON master.id = shared.shared_survey_id
LEFT JOIN vendors v ON master.vendor_id = v.id
LEFT JOIN client_partners cp ON master.client_partner_id = cp.id
LEFT JOIN clients c ON shared.client_id = c.id
WHERE master.shared_survey_id IS NULL -- only master surveys
GROUP BY master.id;

-- 8. Create indexes for performance
CREATE INDEX idx_annual_surveys_status ON annual_surveys(survey_status);
CREATE INDEX idx_annual_surveys_shared ON annual_surveys(is_shared_survey, shared_survey_id);
CREATE INDEX idx_annual_surveys_template ON annual_surveys(survey_template_id);

-- 9. Add survey lifecycle triggers
DELIMITER $$

CREATE TRIGGER survey_status_change_audit
    AFTER UPDATE ON annual_surveys
    FOR EACH ROW
BEGIN
    -- Log status changes in a simple way
    IF OLD.survey_status != NEW.survey_status THEN
        INSERT INTO survey_answer_audit (
            survey_question_id, 
            changed_by_user_id, 
            change_type, 
            previous_value, 
            new_value,
            changed_at
        ) VALUES (
            0, -- special ID for survey-level changes
            COALESCE(NEW.approved_by, NEW.locked_by, 1), -- best guess at who changed it
            'updated',
            JSON_OBJECT('survey_status', OLD.survey_status),
            JSON_OBJECT('survey_status', NEW.survey_status),
            NOW()
        );
    END IF;
END$$

DELIMITER ;

-- 10. Create function to check if survey is editable
DELIMITER $$

CREATE FUNCTION is_survey_editable(survey_id INT) 
RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE survey_status VARCHAR(50);
    DECLARE is_locked BOOLEAN DEFAULT FALSE;
    
    SELECT s.survey_status INTO survey_status
    FROM annual_surveys s 
    WHERE s.id = survey_id;
    
    SELECT COUNT(*) > 0 INTO is_locked
    FROM survey_editing_locks l 
    WHERE l.annual_survey_id = survey_id 
    AND l.expires_at > NOW();
    
    RETURN (survey_status IN ('draft', 'in_progress') AND NOT is_locked);
END$$

DELIMITER ;