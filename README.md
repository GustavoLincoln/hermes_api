<p align="center">
  <!-- PLACE YOUR BANNER HERE -->
  <img src="./assets/banner.png" alt="Hermes Banner" />
</p>

<h1 align="center">Hermes</h1>

<p align="center">
  Lightweight, modern and cURL-first API Client built with Flutter Desktop.
</p>

<p align="center">
  Inspired by Postman, Insomnia and Bruno — focused on speed, simplicity and developer experience.
</p>

---

## ✨ Overview

Hermes is a lightweight desktop API Client focused on fast HTTP testing, cURL workflows and a modern Fluent Design interface.

The project was created as:
- a professional Flutter desktop portfolio project;
- an open source developer tool;
- an experimental API client focused on performance and simplicity.

Unlike heavy API platforms, Hermes aims to deliver a fast, clean and offline-first experience.

---

## 🚀 Features

### HTTP Requests
- GET
- POST
- PUT
- PATCH
- DELETE

### Request Builder
- Headers
- Query Params
- JSON Body
- Raw Text Body
- Authentication support

### cURL Workflow
- Import cURL commands
- Generate cURL from requests
- Parse headers, method, body and URL automatically

### Collections
- Organize requests
- Save local collections
- Request history

### Response Viewer
- Syntax highlighted JSON
- Response headers
- Status code
- Request duration
- Response size

### Desktop Experience
- Fluent Design UI
- Windows 11 Mica effect
- Acrylic transparency
- Native desktop feel
- Responsive layout

---

# 🖥️ Preview

## Main Interface
<!-- SCREENSHOT HERE -->
<img src="./assets/screenshots/main.png" />

## cURL Import
<!-- SCREENSHOT HERE -->
<img src="./assets/screenshots/curl-import.png" />

## Response Viewer
<!-- SCREENSHOT HERE -->
<img src="./assets/screenshots/response.png" />

---

# 🧱 Architecture

Hermes follows a modular Clean Architecture structure.

```txt
APP
 ┣ CORE
 ┣ MODULES
 ┃ ┣ FEATURE_NAME
 ┃ ┃ ┣ DATA
 ┃ ┃ ┃ ┣ DATASOURCES
 ┃ ┃ ┃ ┣ MODELS
 ┃ ┃ ┃ ┗ REPOSITORIES
 ┃ ┃ ┣ DOMAIN
 ┃ ┃ ┃ ┣ ENTITIES
 ┃ ┃ ┃ ┣ ENUMS
 ┃ ┃ ┃ ┣ REPOSITORIES
 ┃ ┃ ┃ ┗ USECASES
 ┃ ┃ ┗ PRESENTATION
 ┃ ┃   ┣ BLOC
 ┃ ┃   ┣ CUBIT
 ┃ ┃   ┣ PAGES
 ┃ ┃   ┗ WIDGETS
 ┗ SHARED
```

---

# ⚙️ Tech Stack

## Core
- Flutter Desktop
- Dart

## State Management
- flutter_bloc
- Cubit

## Networking
- Dio

## Routing
- go_router

## Dependency Injection
- GetIt
- Injectable

## Local Storage
- Isar / Hive

## Code Generation
- Freezed
- json_serializable

## UI
- fluent_ui
- flutter_acrylic
- bitsdojo_window

---

# 🎨 Design

Hermes uses:
- Fluent Design System
- Windows 11 Mica Effect
- Acrylic Blur
- Modern developer-focused UX

Inspired by:
- VSCode
- Windows Terminal
- DevToys
- Postman
- Bruno

---

# 📂 Project Structure

```txt
lib/
 ┣ app/
 ┃ ┣ core/
 ┃ ┣ modules/
 ┃ ┗ shared/
```

---

# 🚧 Roadmap

## MVP
- [x] Base architecture
- [x] HTTP requests
- [x] cURL parser
- [x] Response viewer
- [ ] Collections
- [ ] Environment variables
- [ ] Request history
- [ ] Export/import

## Future Features
- [ ] GraphQL support
- [ ] WebSocket support
- [ ] Plugin system
- [ ] Tabs management
- [ ] Multi-environment support
- [ ] OpenAPI import
- [ ] REST client testing
- [ ] Linux and macOS optimizations

---

# 🛠️ Getting Started

## Requirements

- Flutter 3.22+
- Dart 3+
- Windows 11 recommended

---

## Installation

```bash
git clone https://github.com/your-username/hermes.git
```

```bash
cd hermes
```

```bash
flutter pub get
```

```bash
flutter run -d windows
```

---

# 🤝 Contributing

Contributions are welcome.

Please read the [CONTRIBUTING.md](./CONTRIBUTING.md) file before submitting a Pull Request.

---

# 📄 License

This project is licensed under the MIT License.

---

# ⭐ Support

If you like the project:
- Leave a star on GitHub
- Share the project
- Contribute with ideas and improvements

---

<p align="center">
  Built with Flutter 💙
</p>