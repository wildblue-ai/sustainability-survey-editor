-- Flexible Answer Storage Schema Enhancement
-- Adds JSON-based answer storage system for extensible question types
-- Date: 2025-08-13

USE sustainability_survey;

-- 1. Create question type configuration table
CREATE TABLE question_type_configs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    input_component VARCHAR(100) NOT NULL, -- Frontend component type
    validation_rules JSON, -- Validation schema
    scoring_method VARCHAR(50) DEFAULT 'weighted', -- 'binary', 'weighted', 'custom', 'calculated'
    default_points INT DEFAULT 0,
    ui_config JSON, -- UI-specific configuration
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Add JSON columns to sustainability_questions table
ALTER TABLE sustainability_questions 
ADD COLUMN answer_config JSON COMMENT 'Question-specific configuration overrides',
ADD COLUMN scoring_config JSON COMMENT 'Custom scoring rules for this question',
ADD COLUMN ui_metadata JSON COMMENT 'UI display metadata and options';

-- 3. Add JSON columns to survey_questions table (where actual answers are stored)
ALTER TABLE survey_questions 
ADD COLUMN answer_data JSON COMMENT 'Structured answer data in JSON format',
ADD COLUMN answer_metadata JSON COMMENT 'Additional metadata about the answer',
ADD COLUMN validation_status ENUM('valid', 'invalid', 'pending', 'needs_review') DEFAULT 'pending',
ADD COLUMN validation_errors JSON COMMENT 'Validation error details';

-- 4. Create index on answer_data for better query performance
CREATE INDEX idx_survey_questions_answer_data ON survey_questions ((CAST(answer_data AS CHAR(255))));

-- 5. Seed question type configurations
INSERT INTO question_type_configs (type_name, display_name, description, input_component, validation_rules, scoring_method, ui_config) VALUES

-- Boolean type
('boolean', 'Yes/No', 'Simple yes/no question', 'boolean', 
 '{"required": true, "type": "boolean"}', 
 'binary', 
 '{"trueLabel": "Yes", "falseLabel": "No", "style": "radio"}'),

-- Numeric type  
('numeric', 'Numeric Input', 'Numeric value input', 'number', 
 '{"required": true, "type": "number", "min": 0}', 
 'weighted', 
 '{"placeholder": "Enter number", "step": "any", "showUnit": true}'),

-- Percentage type
('percentage', 'Percentage', 'Percentage value (0-100)', 'percentage', 
 '{"required": true, "type": "number", "min": 0, "max": 100}', 
 'weighted', 
 '{"suffix": "%", "step": 0.1, "placeholder": "0-100"}'),

-- Single select multiple choice
('multiple_choice_single', 'Single Select', 'Choose one option from list', 'radio', 
 '{"required": true, "type": "string", "options": []}', 
 'weighted', 
 '{"layout": "vertical", "randomizeOptions": false}'),

-- Multiple select multiple choice  
('multiple_choice_multiple', 'Multiple Select', 'Choose multiple options from list', 'checkbox', 
 '{"required": true, "type": "array", "options": [], "minItems": 1}', 
 'weighted', 
 '{"layout": "vertical", "maxSelections": null}'),

-- Yes/No for each option
('multiple_choice_yesno', 'Yes/No Each Option', 'Yes/No response for each option', 'yesno_matrix', 
 '{"required": true, "type": "object", "options": []}', 
 'weighted', 
 '{"showHeaders": true, "compactMode": false}'),

-- Free text
('free_text', 'Free Text', 'Open text response', 'textarea', 
 '{"required": false, "type": "string", "minLength": 0, "maxLength": 2000}', 
 'binary', 
 '{"rows": 4, "placeholder": "Enter your response...", "showCharCount": true}'),

-- File upload
('file_upload', 'File Upload', 'Upload supporting documents', 'file', 
 '{"required": false, "type": "array", "maxFiles": 5, "allowedTypes": ["pdf", "doc", "docx", "xlsx", "jpg", "png"]}', 
 'binary', 
 '{"maxSizeMB": 10, "dropzoneText": "Drop files here or click to upload"}'),

-- Date type
('date', 'Date', 'Date selection', 'date', 
 '{"required": false, "type": "string", "format": "date"}', 
 'binary', 
 '{"placeholder": "Select date", "showCalendar": true}'),

-- Date range
('date_range', 'Date Range', 'Date range selection', 'daterange', 
 '{"required": false, "type": "object", "properties": {"start": {"type": "string", "format": "date"}, "end": {"type": "string", "format": "date"}}}', 
 'binary', 
 '{"placeholder": {"start": "Start date", "end": "End date"}}'),

-- Rating scale
('rating', 'Rating Scale', 'Rating on a scale (1-5, 1-10, etc)', 'rating', 
 '{"required": true, "type": "number", "min": 1, "max": 5}', 
 'weighted', 
 '{"scale": 5, "labels": {"min": "Poor", "max": "Excellent"}, "showNumbers": true}'),

-- Matrix/Grid questions
('matrix', 'Matrix/Grid', 'Multiple questions in grid format', 'matrix', 
 '{"required": true, "type": "object", "rows": [], "columns": []}', 
 'weighted', 
 '{"layout": "grid", "singleSelect": true}');

-- 6. Create view for easy answer data queries
CREATE VIEW survey_answers_view AS
SELECT 
    sq.id as survey_question_id,
    sq.annual_survey_id,
    sq.question_id,
    sq.question_order,
    q.question_text,
    q.category,
    q.answer_type,
    qtc.display_name as question_type_display,
    qtc.input_component,
    sq.answer_value as legacy_answer,
    sq.answer_data,
    sq.answer_metadata,
    sq.points_earned,
    sq.notes,
    sq.answered_at,
    sq.validation_status,
    sq.validation_errors,
    asv.survey_name,
    asv.survey_year,
    v.name as vendor_name,
    c.name as client_name
FROM survey_questions sq
JOIN sustainability_questions q ON sq.question_id = q.id
LEFT JOIN question_type_configs qtc ON q.answer_type = qtc.type_name
JOIN annual_surveys asv ON sq.annual_survey_id = asv.id
JOIN vendors v ON asv.vendor_id = v.id
JOIN clients c ON asv.client_id = c.id;

-- 7. Create trigger to validate answer_data against question type
DELIMITER $$

CREATE TRIGGER validate_answer_data_trigger
    BEFORE UPDATE ON survey_questions
    FOR EACH ROW
BEGIN
    -- Only validate if answer_data is being updated and is not null
    IF NEW.answer_data IS NOT NULL AND NEW.answer_data != OLD.answer_data THEN
        -- Set validation status to pending for manual review if complex validation needed
        SET NEW.validation_status = 'pending';
        
        -- Basic validation could be added here
        -- For now, we'll rely on application-level validation
    END IF;
END$$

DELIMITER ;

-- 8. Add indexes for better performance
CREATE INDEX idx_question_type_configs_type_name ON question_type_configs(type_name);
CREATE INDEX idx_survey_questions_validation_status ON survey_questions(validation_status);
CREATE INDEX idx_survey_questions_answered_at ON survey_questions(answered_at);

-- 9. Update existing answer_type values to match new type_name values
UPDATE sustainability_questions 
SET answer_type = CASE 
    WHEN answer_type = 'boolean' THEN 'boolean'
    WHEN answer_type = 'numeric' THEN 'numeric' 
    WHEN answer_type = 'percentage' THEN 'percentage'
    WHEN answer_type = 'multiple_choice_single' THEN 'multiple_choice_single'
    WHEN answer_type = 'multiple_choice_multiple' THEN 'multiple_choice_multiple'
    WHEN answer_type = 'multiple_choice_yesno' THEN 'multiple_choice_yesno'
    WHEN answer_type = 'free_text' THEN 'free_text'
    ELSE answer_type
END;

-- Migration completed
SELECT 'Flexible answer storage schema migration completed successfully' as message;