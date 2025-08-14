#!/usr/bin/env node

require('dotenv').config();
const mysql = require('mysql2/promise');

async function checkTables() {
    const dbConfig = {
        host: process.env.DB_HOST || '127.0.0.1',
        port: parseInt(process.env.DB_PORT) || 3306,
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASSWORD || '',
        database: process.env.DB_NAME || 'sustainability_survey'
    };

    try {
        const connection = await mysql.createConnection(dbConfig);
        console.log('✅ Connected to database');

        // Show all tables
        const [tables] = await connection.execute('SHOW TABLES');
        console.log('\n📊 Current tables:');
        tables.forEach(row => {
            console.log(`   • ${Object.values(row)[0]}`);
        });

        // Check if survey_questions table exists
        const [surveyQuestionsTables] = await connection.execute(
            "SHOW TABLES LIKE 'survey_questions'"
        );
        
        if (surveyQuestionsTables.length === 0) {
            console.log('\n❌ survey_questions table does not exist');
            console.log('🔧 Need to create annual survey system tables first');
        } else {
            console.log('\n✅ survey_questions table exists');
        }

        await connection.end();
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

checkTables();