# Privacy Policy for Vault

**Effective Date: March 8, 2026**

Vault is designed with a "Trust-First, Offline-First" philosophy. This means your privacy is not just a policy, but a technical constraint of our architecture.

### 1. Data Collection & Local Storage
All financial data, including transaction history, merchant names, and bank alerts, is stored **exclusively on your device** in an encrypted SQLite database. 
- **No Cloud Backup:** We do not provide cloud backups of your financial data. If you delete the app or lose your device, your data is gone unless you have exported it manually.
- **Encryption:** Your data is encrypted using AES-256 with a key stored in your device's Secure Keychain/Keystore.

### 2. Permissions
- **SMS/Notifications:** Vault requests permission to read SMS and notifications to automatically track transactions. This processing happens entirely on-device using local machine learning models (TensorFlow Lite).
- **Biometrics:** Used to lock the app. We do not have access to your biometric data.

### 3. Third-Party Services
- **Bank Sync (Optional):** If you choose to connect your bank via Fuse/Plaid, your credentials are used once to obtain an access token. That token is stored securely on your device. We never see your credentials.
- **Subscriptions:** Managed via RevenueCat and your platform's app store (Apple/Google).

### 4. Anonymous Aggregated Insights (Opt-In)
If you choose to opt-in, we may upload anonymized spending patterns using differential privacy techniques. This data cannot be linked back to you and is used solely to provide better financial benchmarks for all users.

### 5. Your Rights
You can delete all your data at any time from the Privacy Dashboard within the app.

---
For questions, contact: support@vault.app
