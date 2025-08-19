const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
const SecretsManager = require('./secrets-manager-integration');

async function updateProductionPasswords() {
    const secretsManager = new SecretsManager();
    
    try {
        console.log('🔐 Retrieving database credentials from AWS Secrets Manager...');
        const dbConfig = await secretsManager.getDatabaseConfig();
        
        console.log('🔌 Connecting to production database...');
        const pool = mysql.createPool({
            host: dbConfig.host,
            user: dbConfig.user,
            password: dbConfig.password,
            database: dbConfig.database,
            port: dbConfig.port,
            waitForConnections: true,
            connectionLimit: 10,
            queueLimit: 0
        });

        // Define the secure passwords that match the login page
        const userPasswords = [
            { email: 'admin@sustainedit.com', password: 'AdminSecure2025!' },
            { email: 'partner@greentech.com', password: 'GreenTech2025!' },
            { email: 'partner@ecopartners.com', password: 'EcoPartner2025!' },
            { email: 'client@techcorp.com', password: 'TechCorp2025!' },
            { email: 'client@localfood.com', password: 'LocalFood2025!' },
            { email: 'vendor@steelworks.com', password: 'GreenSteel2025!Secure' },
            { email: 'vendor@cleanenergy.com', password: 'CleanEnergy2025!' }
        ];

        console.log('🔒 Updating passwords for', userPasswords.length, 'users...\n');

        for (const user of userPasswords) {
            console.log(`🔧 Processing ${user.email}...`);
            
            // Generate bcrypt hash for the password
            const passwordHash = await bcrypt.hash(user.password, 10);
            console.log(`   Generated secure hash`);
            
            // Update the user's password in the database
            const [result] = await pool.execute(
                'UPDATE users SET password_hash = ? WHERE email = ?',
                [passwordHash, user.email]
            );
            
            if (result.affectedRows > 0) {
                console.log(`   ✅ Updated ${user.email}`);
            } else {
                console.log(`   ⚠️  User ${user.email} not found`);
            }
            console.log('');
        }

        console.log('✅ Password update completed successfully!');
        await pool.end();
        
    } catch (error) {
        console.error('❌ Error updating passwords:', error.message);
        process.exit(1);
    }
}

// Only run if called directly
if (require.main === module) {
    updateProductionPasswords();
}

module.exports = updateProductionPasswords;