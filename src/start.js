// Production startup wrapper that loads AWS Secrets Manager configuration
// and injects it as environment variables before starting the main server

require('dotenv').config();

async function startServer() {
    const isProduction = process.env.NODE_ENV === 'production';
    
    if (isProduction) {
        console.log('🔐 Production mode: Loading configuration from AWS Secrets Manager...');
        
        try {
            // Load configuration from AWS Secrets Manager
            const configManager = require('./config');
            const config = await configManager.getConfig();
            
            // Inject configuration as environment variables for existing server code
            process.env.DB_HOST = config.database.host;
            process.env.DB_USER = config.database.user;
            process.env.DB_PASSWORD = config.database.password;
            process.env.DB_NAME = config.database.database;
            process.env.DB_PORT = config.database.port.toString();
            process.env.SESSION_SECRET = config.app.sessionSecret;
            process.env.DEMO_USERNAME = config.app.demoUsername;
            process.env.DEMO_PASSWORD = config.app.demoPassword;
            process.env.ENABLE_BASIC_AUTH = config.app.enableBasicAuth.toString();
            
            console.log('✅ AWS Secrets Manager configuration loaded');
            console.log(`🔐 Using basic auth: ${config.app.enableBasicAuth}`);
            
        } catch (error) {
            console.error('❌ Failed to load AWS Secrets Manager configuration:', error.message);
            console.log('⚠️  Falling back to environment variables...');
        }
    } else {
        console.log('🔧 Development mode: Using .env file configuration');
    }
    
    // Start the main server
    require('./server');
}

// Handle errors
startServer().catch(error => {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
});