-- Flexible Answer Storage Schema Enhancement (Simplified)
-- Adds JSON-based answer storage system for extensible question types
-- Date: 2025-08-13

USE sustainability_survey;

-- 1. Create question type configuration table
CREATE TABLE IF NOT EXISTS question_type_configs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    input_component VARCHAR(100) NOT NULL,
    validation_rules JSON,
    scoring_method VARCHAR(50) DEFAULT 'weighted',
    default_points INT DEFAULT 0,
    ui_config JSON,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Add JSON columns to sustainability_questions table
ALTER TABLE sustainability_questions 
ADD COLUMN answer_config JSON COMMENT 'Question-specific configuration overrides',
ADD COLUMN scoring_config JSON COMMENT 'Custom scoring rules for this question',
ADD COLUMN ui_metadata JSON COMMENT 'UI display metadata and options';

-- 3. Add JSON columns to survey_questions table
ALTER TABLE survey_questions 
ADD COLUMN answer_data JSON COMMENT 'Structured answer data in JSON format',
ADD COLUMN answer_metadata JSON COMMENT 'Additional metadata about the answer',
ADD COLUMN validation_status ENUM('valid', 'invalid', 'pending', 'needs_review') DEFAULT 'pending',
ADD COLUMN validation_errors JSON COMMENT 'Validation error details';

-- 4. Seed question type configurations
INSERT IGNORE INTO question_type_configs (type_name, display_name, description, input_component, validation_rules, scoring_method, ui_config) VALUES
('boolean', 'Yes/No', 'Simple yes/no question', 'boolean', 
 '{"required": true, "type": "boolean"}', 
 'binary', 
 '{"trueLabel": "Yes", "falseLabel": "No", "style": "radio"}'),

('numeric', 'Numeric Input', 'Numeric value input', 'number', 
 '{"required": true, "type": "number", "min": 0}', 
 'weighted', 
 '{"placeholder": "Enter number", "step": "any", "showUnit": true}'),

('percentage', 'Percentage', 'Percentage value (0-100)', 'percentage', 
 '{"required": true, "type": "number", "min": 0, "max": 100}', 
 'weighted', 
 '{"suffix": "%", "step": 0.1, "placeholder": "0-100"}'),

('multiple_choice_single', 'Single Select', 'Choose one option from list', 'radio', 
 '{"required": true, "type": "string", "options": []}', 
 'weighted', 
 '{"layout": "vertical", "randomizeOptions": false}'),

('multiple_choice_multiple', 'Multiple Select', 'Choose multiple options from list', 'checkbox', 
 '{"required": true, "type": "array", "options": [], "minItems": 1}', 
 'weighted', 
 '{"layout": "vertical", "maxSelections": null}'),

('multiple_choice_yesno', 'Yes/No Each Option', 'Yes/No response for each option', 'yesno_matrix', 
 '{"required": true, "type": "object", "options": []}', 
 'weighted', 
 '{"showHeaders": true, "compactMode": false}'),

('free_text', 'Free Text', 'Open text response', 'textarea', 
 '{"required": false, "type": "string", "minLength": 0, "maxLength": 2000}', 
 'binary', 
 '{"rows": 4, "placeholder": "Enter your response...", "showCharCount": true}'),

('file_upload', 'File Upload', 'Upload supporting documents', 'file', 
 '{"required": false, "type": "array", "maxFiles": 5, "allowedTypes": ["pdf", "doc", "docx", "xlsx", "jpg", "png"]}', 
 'binary', 
 '{"maxSizeMB": 10, "dropzoneText": "Drop files here or click to upload"}'),

('date', 'Date', 'Date selection', 'date', 
 '{"required": false, "type": "string", "format": "date"}', 
 'binary', 
 '{"placeholder": "Select date", "showCalendar": true}'),

('date_range', 'Date Range', 'Date range selection', 'daterange', 
 '{"required": false, "type": "object", "properties": {"start": {"type": "string", "format": "date"}, "end": {"type": "string", "format": "date"}}}', 
 'binary', 
 '{"placeholder": {"start": "Start date", "end": "End date"}}'),

('rating', 'Rating Scale', 'Rating on a scale (1-5, 1-10, etc)', 'rating', 
 '{"required": true, "type": "number", "min": 1, "max": 5}', 
 'weighted', 
 '{"scale": 5, "labels": {"min": "Poor", "max": "Excellent"}, "showNumbers": true}'),

('matrix', 'Matrix/Grid', 'Multiple questions in grid format', 'matrix', 
 '{"required": true, "type": "object", "rows": [], "columns": []}', 
 'weighted', 
 '{"layout": "grid", "singleSelect": true}');

-- 5. Create indexes for better performance (ignore errors if they exist)
CREATE INDEX idx_question_type_configs_type_name ON question_type_configs(type_name);
CREATE INDEX idx_survey_questions_validation_status ON survey_questions(validation_status);
CREATE INDEX idx_survey_questions_answered_at ON survey_questions(answered_at);