const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
require('dotenv').config();

async function updateSecurePasswords() {
    console.log('🔌 Connecting to database...');
    console.log('   Host: 127.0.0.1:3306');
    console.log('   Database:', process.env.DB_NAME);
    console.log('   User:', process.env.DB_USER);

    const pool = mysql.createPool({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        socketPath: process.env.DB_SOCKET,
        waitForConnections: true,
        connectionLimit: 10,
        queueLimit: 0
    });

    try {
        console.log('✅ Database connected successfully\n');

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
            console.log(`   Generated hash: ${passwordHash.substring(0, 20)}...`);
            
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
        
    } catch (error) {
        console.error('❌ Error updating passwords:', error.message);
        process.exit(1);
    } finally {
        await pool.end();
        console.log('🔒 Database connection closed');
    }
}

updateSecurePasswords();