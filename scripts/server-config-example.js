// Example of how to update server.js to use the hybrid configuration
// This shows the key changes needed in your existing server.js

const express = require('express');
const mysql = require('mysql2/promise');
const configManager = require('./config'); // Import our config manager

async function initializeServer() {
    const app = express();
    
    // Load configuration (will use .env locally, Secrets Manager in production)
    const config = await configManager.getConfig();
    
    // Set up database connection using the config
    const pool = mysql.createPool(await configManager.getDatabasePoolConfig());
    
    // Set up basic auth if enabled
    if (config.app.enableBasicAuth) {
        const basicAuth = require('express-basic-auth');
        app.use(basicAuth({
            users: { 
                [config.app.demoUsername]: config.app.demoPassword 
            },
            challenge: true
        }));
    }
    
    // Set up session with secret from config
    const session = require('express-session');
    app.use(session({
        secret: config.app.sessionSecret,
        resave: false,
        saveUninitialized: false,
        cookie: { 
            secure: config.app.nodeEnv === 'production',
            maxAge: 24 * 60 * 60 * 1000 // 24 hours
        }
    }));
    
    // Rest of your server setup...
    
    // Start server
    const port = config.app.port;
    app.listen(port, () => {
        console.log(`🚀 Server running on port ${port}`);
        console.log(`📊 Environment: ${config.app.nodeEnv}`);
        console.log(`🔐 Config source: ${config.app.nodeEnv === 'production' ? 'AWS Secrets Manager' : '.env file'}`);
    });
}

// Handle async initialization
initializeServer().catch(error => {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
});

module.exports = { initializeServer };