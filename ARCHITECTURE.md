# App Architecture & Project Structure

This document outlines the architecture, folder structure, and key relationships within the **Eden App**. The project follows a **Feature-First** architecture combined with **Riverpod** for state management.

## 🏗 High-Level Architecture

The application is built using **Flutter** and follows a modular, feature-based structure. This ensures that the code remains scalable, maintainable, and easy to navigate.

- **State Management**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`) is used for dependency injection and state management.
- **Routing**: [GoRouter](https://pub.dev/packages/go_router) (`go_router`) handles navigation and deep linking.
- **Styling**: Uses `google_fonts` and a centralized `ThemeData`.
- **Assets**: Managed via `assets/` directory (includes SVGs, images).

---

## 📂 Folder Structure

The `lib/` directory is the core of the application. Here is the breakdown:

```
lib/
├── core/                  # Core functionality shared across the entire app
│   ├── providers/         # Global Riverpod providers
│   ├── router/            # GoRouter configuration
│   └── theme/             # App theme, colors, and text styles
│
├── features/              # Feature modules (Feature-First approach)
│   ├── home/              # 'Home' feature
│   │   └── presentation/  # UI logic and widgets for Home
│   │       └── pages/     # Full screen pages
│   │
│   └── onboarding/        # 'Onboarding' feature
│       └── ...
│
├── main.dart              # Entry point of the application
└── app.dart (implied)     # Root widget (App setup)
```

---

## 📜 Role of Each Folder/File

### 1. `lib/core/`
This folder contains code that is **agnostic** to specific features. It serves as the foundation of the app.
- **`providers/`**: Global state that needs to be accessed anywhere (e.g., User session, Theme mode).
- **`router/`**: Contains the `GoRouter` configuration, defining all routes URLs (e.g., `/`, `/home`) and redirects.
- **`theme/`**: Centralized design system constants (Colors, Typography, ThemeData) to ensure UI consistency.

### 2. `lib/features/`
Each folder here represents a distinct **domain** or **feature** of the application.
- **`home/`, `onboarding/`**: Self-contained modules.
- **`presentation/`**: Contains the UI code:
    - **`pages/`**: Full-screen widgets mapped to a route.
    - **`widgets/`**: Reusable components specific to this feature.
    - **`providers/`** (optional): Feature-specific state management (e.g., `home_controller.dart`).

### 3. `lib/main.dart`
The entry point. It setup the `ProviderScope` (for Riverpod) and runs the app.

---

## 🔗 Relationships & Data Flow

1.  **Entry Point**: `main.dart` initializes the app and wraps it in `ProviderScope`.
2.  **Navigation**: The `Router` (in `core/router`) defines which **Page** (in `features/*/presentation/pages`) to show based on the URL.
3.  **State Access**:
    - **Pages** read data from **Providers**.
    - **Providers** may fetch data from Repositories (if added in the future) or Services.
4.  **Dependencies**:
    - **Features** can depend on **Core**.
    - **Features** should generally **NOT** depend on other Features (to avoid tight coupling). Interaction between features is usually handled via the Router or shared Core providers.

## 🛠 Tech Stack Summary

- **Framework**: Flutter
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Persistence**: SharedPreferences (local storage)
- **UI/Assets**: Flutter SVG, Google Fonts, Equatable
