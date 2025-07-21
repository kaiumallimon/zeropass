# ZeroPass

A modern, secure, and user-friendly password manager built with Flutter.

## Overview

**ZeroPass** is a cross-platform password manager that prioritizes user privacy and data security. With end-to-end encryption, seamless sync, and a beautiful interface, ZeroPass helps you generate, store, and manage strong passwords for all your accounts—anywhere, anytime.

---

## ✨ Features

- **End-to-End Encryption:** Your passwords are encrypted locally before they ever leave your device.
- **Secure Storage:** Uses industry-standard encryption and secure local storage for sensitive data.
- **Password Generator:** Instantly create strong, unique passwords for every account.
- **Cross-Platform Sync:** Access your passwords on mobile and desktop with seamless synchronization (powered by Supabase).
- **Organize & Categorize:** Easily manage and categorize your logins for quick access.
- **Modern UI:** Clean, intuitive design with custom fonts and smooth navigation.
- **Forgot Password & Account Recovery:** Simple flows to recover access securely.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.8.1 or higher)
- A [Supabase](https://supabase.com/) project (for sync features)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/zeropass.git
   cd zeropass
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Supabase:**
   - Add your Supabase credentials to the project as required (see `lib/data/` for integration points).
4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

- `lib/`
  - `core/` – App-wide constants and themes
  - `data/` – Data models, storage, and sync logic
  - `presentation/` – UI pages and widgets
  - `routes/` – App navigation
  - `shared/` – Reusable widgets
- `assets/` – Fonts, images, and icons

---

## 🛡️ Security
- All sensitive data is encrypted using the `encrypt` and `crypto` packages.
- Local storage uses `flutter_secure_storage` for maximum security.
- No passwords are ever stored or transmitted in plain text.

---

## 📦 Dependencies
- [Flutter](https://flutter.dev/)
- [Supabase Flutter](https://pub.dev/packages/supabase_flutter)
- [Provider](https://pub.dev/packages/provider)
- [Go Router](https://pub.dev/packages/go_router)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Encrypt](https://pub.dev/packages/encrypt)
- [Crypto](https://pub.dev/packages/crypto)
- [HugeIcons](https://pub.dev/packages/hugeicons)

---

## 🖋️ Customization
- Custom fonts: Sora, Space Grotesk (see `pubspec.yaml`)
- Easily swap themes or add dark mode in `lib/core/theme/app_theme.dart`

---

## 🤝 Contributing

Contributions are welcome! Please open issues or submit pull requests for new features, bug fixes, or improvements.

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgements
- [Flutter](https://flutter.dev/)
- [Supabase](https://supabase.com/)
- [Open Source Community](https://github.com/)
