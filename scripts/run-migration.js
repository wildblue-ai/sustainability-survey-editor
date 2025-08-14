#!/usr/bin/env node

// Secure database migration runner
// Uses environment variables from .env file

require('dotenv').config();
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

async function runMigration() {
    // Database connection configuration from environment
    const dbConfig = {
        host: process.env.DB_HOST || '127.0.0.1',
        port: parseInt(process.env.DB_PORT) || 3306,
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASSWORD || '',
        database: process.env.DB_NAME || 'sustainability_survey',
        multipleStatements: true // Allow multiple SQL statements
    };

    console.log('🔌 Connecting to database...');
    console.log(`   Host: ${dbConfig.host}:${dbConfig.port}`);
    console.log(`   Database: ${dbConfig.database}`);
    console.log(`   User: ${dbConfig.user}`);

    try {
        // Create connection
        const connection = await mysql.createConnection(dbConfig);
        console.log('✅ Database connected successfully');

        // Read migration file
        // Run multiple migrations in sequence
        const migrations = [
            '../database/migrations/001_create_survey_system.sql',
            '../database/migrations/002_flexible_answer_storage_simple.sql',
            '../database/migrations/003_enhanced_survey_system_simple.sql'
        ];
        
        for (const migrationFile of migrations) {
            const migrationPath = path.join(__dirname, migrationFile);
            console.log(`\n📄 Reading migration: ${migrationPath}`);
            
            const migrationSQL = fs.readFileSync(migrationPath, 'utf8');
            console.log(`📝 Migration file size: ${migrationSQL.length} characters`);

            // Execute migration
            console.log('🚀 Executing migration...');
            
            // Split SQL into individual statements and execute them one by one
            // Remove comments and split on semicolons
            const cleanSQL = migrationSQL
                .split('\n')
                .filter(line => !line.trim().startsWith('--'))
                .join('\n');
                
            const statements = cleanSQL
                .split(';')
                .map(stmt => stmt.trim())
                .filter(stmt => stmt.length > 0);
            
            console.log(`📝 Found ${statements.length} SQL statements to execute`);
            
            for (let i = 0; i < statements.length; i++) {
                const statement = statements[i];
                if (statement.length > 0) {
                    try {
                        console.log(`   Executing statement ${i + 1}/${statements.length}...`);
                        // Use query instead of execute for statements that don't support prepared statements
                        if (statement.toUpperCase().startsWith('USE ') || 
                            statement.toUpperCase().includes('CREATE INDEX') ||
                            statement.toUpperCase().includes('INSERT IGNORE') ||
                            statement.toUpperCase().includes('DELIMITER') ||
                            statement.toUpperCase().includes('CREATE TRIGGER') ||
                            statement.toUpperCase().includes('CREATE FUNCTION')) {
                            await connection.query(statement);
                        } else {
                            await connection.execute(statement);
                        }
                    } catch (error) {
                        if (error.message.includes('already exists') || 
                            error.message.includes('Duplicate column') ||
                            error.message.includes('Duplicate key name') ||
                            error.message.includes('Duplicate foreign key constraint') ||
                            error.message.includes('Duplicate constraint name')) {
                            console.log(`   ⚠️  Statement ${i + 1} skipped (already exists): ${error.message}`);
                        } else {
                            throw error;
                        }
                    }
                }
            }
            console.log(`✅ Migration ${migrationFile} completed!`);
        }
        
        console.log('✅ Migration completed successfully!');
        
        // Verify the results
        console.log('🔍 Verifying migration results...');
        
        // Check question_type_configs table
        const [typeConfigs] = await connection.execute('SELECT COUNT(*) as count FROM question_type_configs');
        console.log(`📊 Question type configurations: ${typeConfigs[0].count}`);
        
        // Check new columns in sustainability_questions
        const [questionCols] = await connection.execute('DESCRIBE sustainability_questions');
        const jsonColumns = questionCols.filter(col => col.Type.includes('json'));
        console.log(`📊 JSON columns in sustainability_questions: ${jsonColumns.length}`);
        
        // Check new columns in survey_questions  
        const [surveyCols] = await connection.execute('DESCRIBE survey_questions');
        const surveyJsonColumns = surveyCols.filter(col => col.Type.includes('json'));
        console.log(`📊 JSON columns in survey_questions: ${surveyJsonColumns.length}`);

        // Close connection
        await connection.end();
        console.log('🔒 Database connection closed');
        
        process.exit(0);
        
    } catch (error) {
        console.error('❌ Migration failed:', error.message);
        console.error('Stack trace:', error.stack);
        process.exit(1);
    }
}

// Run migration
runMigration();