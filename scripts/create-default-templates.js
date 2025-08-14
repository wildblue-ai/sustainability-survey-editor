#!/usr/bin/env node

// Create default survey templates from current question library
// Uses existing category and question order structure

require('dotenv').config();
const mysql = require('mysql2/promise');

async function createDefaultTemplates() {
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

        // Get all client partners
        const [partners] = await connection.execute('SELECT * FROM client_partners ORDER BY name');
        console.log(`📊 Found ${partners.length} client partners`);

        // Get all questions ordered by category and question_order
        const [questions] = await connection.execute(`
            SELECT id, category, question_order, question_text, question_type, answer_type, max_points
            FROM sustainability_questions 
            ORDER BY category, question_order
        `);
        console.log(`📝 Found ${questions.length} questions in library`);

        // Group questions by category to show structure
        const categoryCounts = {};
        questions.forEach(q => {
            categoryCounts[q.category] = (categoryCounts[q.category] || 0) + 1;
        });
        
        console.log('\n📋 Question Library Structure:');
        Object.entries(categoryCounts).forEach(([category, count]) => {
            console.log(`   • ${category}: ${count} questions`);
        });

        // Create default templates for each partner for 2024 and 2025
        const years = [2024, 2025];
        
        for (const partner of partners) {
            for (const year of years) {
                console.log(`\n🏗️  Creating template for ${partner.name} (${year})...`);
                
                // Check if template already exists
                const [existing] = await connection.execute(`
                    SELECT id FROM survey_templates 
                    WHERE client_partner_id = ? AND survey_year = ?
                `, [partner.id, year]);
                
                if (existing.length > 0) {
                    console.log(`   ⚠️  Template already exists for ${partner.name} ${year}`);
                    continue;
                }
                
                // Create the survey template
                const [templateResult] = await connection.execute(`
                    INSERT INTO survey_templates (
                        client_partner_id, 
                        template_name, 
                        survey_year, 
                        description, 
                        created_by
                    ) VALUES (?, ?, ?, ?, ?)
                `, [
                    partner.id,
                    `${partner.name} ${year} Sustainability Survey`,
                    year,
                    `Complete sustainability assessment template for ${year} including all categories: ${Object.keys(categoryCounts).join(', ')}`,
                    1 // Default to first user (admin)
                ]);
                
                const templateId = templateResult.insertId;
                console.log(`   ✅ Created template ID: ${templateId}`);
                
                // Add all questions to the template in their current order
                console.log(`   📝 Adding ${questions.length} questions to template...`);
                
                for (let i = 0; i < questions.length; i++) {
                    const question = questions[i];
                    
                    await connection.execute(`
                        INSERT INTO survey_template_questions (
                            survey_template_id,
                            question_id,
                            question_order,
                            is_required,
                            custom_config
                        ) VALUES (?, ?, ?, ?, ?)
                    `, [
                        templateId,
                        question.id,
                        i + 1, // Sequential order starting from 1
                        true, // All questions required by default
                        JSON.stringify({
                            category: question.category,
                            original_order: question.question_order,
                            max_points: question.max_points
                        })
                    ]);
                }
                
                console.log(`   ✅ Added all questions to ${partner.name} ${year} template`);
            }
        }

        // Verify the results
        console.log('\n🔍 Verifying created templates...');
        const [templates] = await connection.execute(`
            SELECT 
                st.id,
                st.template_name,
                st.survey_year,
                cp.name as partner_name,
                COUNT(stq.id) as question_count
            FROM survey_templates st
            JOIN client_partners cp ON st.client_partner_id = cp.id
            LEFT JOIN survey_template_questions stq ON st.id = stq.survey_template_id
            GROUP BY st.id
            ORDER BY cp.name, st.survey_year
        `);
        
        console.log(`\n📊 Created Templates Summary:`);
        templates.forEach(template => {
            console.log(`   • ${template.partner_name} ${template.survey_year}: ${template.question_count} questions`);
        });

        // Show category breakdown for first template
        if (templates.length > 0) {
            const firstTemplateId = templates[0].id;
            const [categoryBreakdown] = await connection.execute(`
                SELECT 
                    JSON_UNQUOTE(JSON_EXTRACT(stq.custom_config, '$.category')) as category,
                    COUNT(*) as count
                FROM survey_template_questions stq
                WHERE stq.survey_template_id = ?
                GROUP BY JSON_UNQUOTE(JSON_EXTRACT(stq.custom_config, '$.category'))
                ORDER BY category
            `, [firstTemplateId]);
            
            console.log(`\n📋 Sample Template (${templates[0].template_name}) Categories:`);
            categoryBreakdown.forEach(cat => {
                console.log(`   • ${cat.category}: ${cat.count} questions`);
            });
        }

        await connection.end();
        console.log('\n🎉 Default survey templates created successfully!');
        
    } catch (error) {
        console.error('❌ Error creating templates:', error.message);
        process.exit(1);
    }
}

createDefaultTemplates();