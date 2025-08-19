// AWS Secrets Manager integration for sustainability survey
const { SecretsManagerClient, GetSecretValueCommand } = require('@aws-sdk/client-secrets-manager');

class SecretsManager {
    constructor() {
        this.client = new SecretsManagerClient({ region: 'us-east-1' });
        this.secretCache = new Map();
        this.cacheExpiry = 5 * 60 * 1000; // 5 minutes
    }

    async getSecret(secretName) {
        // Check cache first
        const cached = this.secretCache.get(secretName);
        if (cached && Date.now() - cached.timestamp < this.cacheExpiry) {
            return cached.value;
        }

        try {
            console.log(`🔐 Retrieving secret: ${secretName}`);
            const command = new GetSecretValueCommand({ SecretId: secretName });
            const response = await this.client.send(command);
            
            const secretValue = JSON.parse(response.SecretString);
            
            // Cache the result
            this.secretCache.set(secretName, {
                value: secretValue,
                timestamp: Date.now()
            });
            
            return secretValue;
        } catch (error) {
            console.error(`❌ Failed to retrieve secret ${secretName}:`, error.message);
            throw error;
        }
    }

    async getDatabaseConfig() {
        const dbSecret = await this.getSecret('sustainability-survey/database');
        return {
            host: dbSecret.host,
            user: dbSecret.username,
            password: dbSecret.password,
            database: dbSecret.database,
            port: dbSecret.port
        };
    }

    async getAppConfig() {
        const appSecret = await this.getSecret('sustainability-survey/app-config');
        return {
            sessionSecret: appSecret.session_secret,
            demoUsername: appSecret.demo_username,
            demoPassword: appSecret.demo_password,
            nodeEnv: appSecret.node_env
        };
    }
}

module.exports = SecretsManager;