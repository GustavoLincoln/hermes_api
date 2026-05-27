# Contributing to Hermes

First of all, thank you for considering contributing to Hermes.

Hermes is an open source Flutter desktop API Client focused on performance, simplicity and developer experience.

---

# 🚀 Getting Started

## Fork the repository

```bash
git clone https://github.com/your-username/hermes.git
```

---

# 📦 Install dependencies

```bash
flutter pub get
```

---

# ▶️ Run the project

```bash
flutter run -d windows
```

---

# 🧱 Architecture

Hermes follows Clean Architecture with modular feature separation.

Please follow the existing structure:

```txt
MODULES
 ┣ FEATURE
 ┃ ┣ DATA
 ┃ ┣ DOMAIN
 ┃ ┗ PRESENTATION
```

---

# 📌 Guidelines

## Code Style
- Keep code clean and readable
- Use meaningful names
- Avoid unnecessary comments
- Prefer composition over inheritance

## Architecture
- Business rules belong in DOMAIN
- Data access belongs in DATA
- UI logic belongs in PRESENTATION
- Keep layers isolated

## State Management
- Use Bloc/Cubit
- Keep states immutable
- Avoid business logic inside widgets

## Pull Requests
- Keep PRs focused
- Small PRs are preferred
- Explain your changes clearly

---

# 🐛 Reporting Bugs

When reporting bugs include:
- OS version
- Flutter version
- Steps to reproduce
- Expected behavior
- Screenshots if possible

---

# ✨ Feature Requests

Feature suggestions are welcome.

Please open an issue before implementing large changes.

---

# 📄 License

By contributing to Hermes, you agree that your contributions will be licensed under the MIT License.

---

# ❤️ Thank You

Thanks for helping make Hermes better.