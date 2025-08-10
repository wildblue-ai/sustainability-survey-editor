-- SQLite version of Sustainability Survey Questions
-- This table stores all questions from the sustainability digital survey

CREATE TABLE sustainability_questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL,
    question_order INTEGER NOT NULL,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL CHECK (question_type IN ('Systems', 'Best Practice', 'Performance')),
    answer_type TEXT NOT NULL CHECK (answer_type IN ('boolean', 'numeric', 'multiple_choice', 'percentage')),
    effort_rating REAL NULL,
    impact_rating REAL NULL,
    max_points INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for efficient querying
CREATE INDEX idx_category_order ON sustainability_questions(category, question_order);
CREATE INDEX idx_type ON sustainability_questions(question_type);
CREATE INDEX idx_answer_type ON sustainability_questions(answer_type);