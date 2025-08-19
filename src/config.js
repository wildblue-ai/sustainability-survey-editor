// Configuration manager - handles both local .env and AWS Secrets Manager
const SecretsManager = require('../scripts/secrets-manager-integration');
require('dotenv').config();

class ConfigManager {
    constructor() {
        this.isProduction = process.env.NODE_ENV === 'production';
        this.secretsManager = this.isProduction ? new SecretsManager() : null;
        this.configCache = null;
    }

    async getConfig() {
        // Return cached config if available
        if (this.configCache) {
            return this.configCache;
        }

        let config;

        if (this.isProduction) {
            console.log('🔐 Loading configuration from AWS Secrets Manager...');
            config = await this.loadFromSecretsManager();
        } else {
            console.log('🔧 Loading configuration from .env file...');
            config = this.loadFromEnv();
        }

        // Cache the configuration
        this.configCache = config;
        return config;
    }

    async loadFromSecretsManager() {
        try {
            const [dbConfig, appConfig] = await Promise.all([
                this.secretsManager.getDatabaseConfig(),
                this.secretsManager.getAppConfig()
            ]);

            return {
                database: {
                    host: dbConfig.host,
                    user: dbConfig.user,
                    password: dbConfig.password,
                    database: dbConfig.database,
                    port: dbConfig.port
                },
                app: {
                    sessionSecret: appConfig.sessionSecret,
                    port: process.env.PORT || 3000,
                    nodeEnv: appConfig.nodeEnv,
                    demoUsername: appConfig.demoUsername,
                    demoPassword: appConfig.demoPassword,
                    enableBasicAuth: true // Always enabled in production
                }
            };
        } catch (error) {
            console.error('❌ Failed to load from Secrets Manager:', error.message);
            throw new Error('Failed to load production configuration');
        }
    }

    loadFromEnv() {
        return {
            database: {
                host: process.env.DB_HOST || '127.0.0.1',
                user: process.env.DB_USER || 'sustainapp',
                password: process.env.DB_PASSWORD,
                database: process.env.DB_NAME || 'sustainability_survey',
                port: parseInt(process.env.DB_PORT) || 3306,
                socketPath: process.env.DB_SOCKET // Only used locally
            },
            app: {
                sessionSecret: process.env.SESSION_SECRET,
                port: parseInt(process.env.PORT) || 3000,
                nodeEnv: process.env.NODE_ENV || 'development',
                demoUsername: process.env.DEMO_USERNAME,
                demoPassword: process.env.DEMO_PASSWORD,
                enableBasicAuth: process.env.ENABLE_BASIC_AUTH === 'true'
            }
        };
    }

    // Helper method to get database pool configuration
    async getDatabasePoolConfig() {
        const config = await this.getConfig();
        const poolConfig = {
            host: config.database.host,
            user: config.database.user,
            password: config.database.password,
            database: config.database.database,
            port: config.database.port,
            waitForConnections: true,
            connectionLimit: 10,
            queueLimit: 0
        };

        // Add socket path for local development only
        if (!this.isProduction && config.database.socketPath) {
            poolConfig.socketPath = config.database.socketPath;
        }

        return poolConfig;
    }
}

// Export singleton instance
module.exports = new ConfigManager();