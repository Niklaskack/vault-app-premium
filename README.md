# Vault – Trust-First, Offline-First Financial Companion

Vault is a proactive, hyper-personalized financial advisor built for iOS and Android. It is designed with **absolute privacy** and **offline functionality** at its core. Unlike traditional finance apps, Vault ensures your financial data stays where it belongs: entirely on your device.

## 🛡️ Core Philosophy
- **Privacy by Design**: No financial data ever leaves your device. All processing (NLP for SMS, spending analysis, fraud detection) happens locally using on-device AI.
- **Offline-First**: Core functionality works instantly without internet. Sync only happens for optional bank connections and subscription validation.
- **Trust as a Feature**: Radical transparency. No ads, no data selling. You control every bit of data.
- **Proactive Intelligence**: Anticipates your needs—fraud alerts, spending nudges, and bill negotiation opportunities.

## 🚀 Key Features

### 1. Triple-Layer Transaction Tracking
- **Auto SMS/Notification Parsing**: On-device AI (TensorFlow Lite) extracts merchant, amount, and date from your bank alerts.
- **Smart Manual Entry**: Instant logging with receipt scanning (OCR) and voice entry.
- **Optional Bank Sync**: Securely link institutions via professional aggregators, with all transaction data stored locally and encrypted.

### 2. Intelligent Insights & Security
- **Proactive Dashboard**: Real-time spending summaries, sparkline charts, and personalized nudges.
- **On-Device Anomaly Detection**: Local AI monitors for suspicious activity and alerts you instantly.
- **Bill Negotiation**: Automatically identifies recurring bills and provides scripts/tips to lower your monthly costs.
- **Privacy Dashboard**: Complete control over your data, with options to wipe everything or opt-in to anonymous aggregated insights.

## 🛠️ Tech Stack
- **Framework**: Flutter (Dart 3.8+)
- **State Management**: Riverpod
- **Local Database**: `sqflite_sqlcipher` (AES-256 Encryption)
- **Secure Storage**: `flutter_secure_storage` (Keychain/Keystore)
- **AI/ML**: `tflite_flutter` (Inference), `google_mlkit_text_recognition` (OCR)
- **Background Tasks**: `workmanager`
- **Subscriptions**: RevenueCat (`purchases_flutter`)

## 📦 Project Structure
```text
lib/
├── core/           # Theme, Providers, Constants
├── data/           # Local DB & Secure Storage implementations
├── domain/         # Repositories & Entities
├── features/       # Feature-based UI & Logic (Dashboard, Onboarding, etc.)
└── services/       # AI, Background, and External Integration services
```

## 🛠️ Getting Started
### Prerequisites
- Flutter SDK (latest stable)
- Android Studio / VS Code
- CocoaPods (for iOS)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/vault.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## 🔒 Security & Compliance
- **Local Encryption**: All data is encrypted using SQLCipher with a key stored in the device's secure hardware (Keystore/Keychain).
- **Anonymization**: Any optional aggregated data uses differential privacy techniques to ensure zero personal identifiability.
- **Regulatory Readiness**: Designed to naturally comply with GDPR and CCPA through data minimization.

---
*Built with ❤️ for privacy and financial freedom.*
