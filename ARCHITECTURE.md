# 🏗 App Architecture & Technical Structure

This document provides a deep dive into the architecture, folder structure, and technical implementation of the **Eden App**. The project is built for scalability and maintainability using a **Feature-First** approach combined with **Riverpod** for state management.

---

## 🛠 Tech Stack Overview

-   **Framework**: Flutter (Multi-platform support)
-   **State Management**: [Riverpod](https://riverpod.dev/) (Dependency Injection & Reactive State)
-   **Routing**: [GoRouter](https://pub.dev/packages/go_router) (Declarative Routing)
-   **Backend**: [Supabase](https://supabase.com/) (Authentication, PostgreSQL Database, Storage)
-   **AI Management**: [TensorFlow Lite](https://www.tensorflow.org/lite) (Offline on-device inference) & [Supabase Edge Functions](https://supabase.com/edge-functions) (Online cloud-based inference)
-   **Persistence**: [SharedPreferences](https://pub.dev/packages/shared_preferences) (Local user preferences)
-   **UI & Styling**: [Google Fonts](https://pub.dev/packages/google_fonts), Custom "Glassmorphism" Design System

---

## 📂 Project Structure (`lib/`)

The application follows a modular structure where each feature is self-contained.

### 1. `lib/core/`
The foundation of the app, containing code shared across all features.
-   **`providers/`**: Global Riverpod providers (e.g., auth state, locale settings).
-   **`router/`**: Centralized navigation logic using `GoRouter`.
-   **`theme/`**: Design system tokens, colors, typography, and `ThemeData`.
-   **`utils/`**: Helper classes and extension methods.

### 2. `lib/features/`
Each folder represents a specific domain or user flow.
-   **`auth/`**: Signup, Login, and User Session management via Supabase.
-   **`garden/`**: Personal plant collection and tracking logic.
-   **`home/`**: Main discovery dashboard and trending content.
-   **`onboarding/`**: Tutorial and first-time user experience.
-   **`plant_profile/`**: Comprehensive species details (care, medical, ecology).
-   **`quiz/`**: Interactive educational quizzes.
-   **`scan/`**: AI-powered image processing and plant identification logic.
-   **`splash/`**: Application entry and initialization logic.

---

## 🔄 Data Flow & Logic

### 1. AI Plant Identification
The `scan/` feature provides a flexible dual-mode identification system:
-   **Offline Mode**: Uses **TensorFlow Lite** (`tflite_flutter`) for on-device inference. This ensures privacy and availability without an internet connection.
-   **Online Mode**: Leverages a **Supabase Edge Function** to perform cloud-based identification (often providing higher accuracy via remote models).

**Process:**
1.  **Image Input**: Captured via camera or picked from gallery (`image_picker`).
2.  **Processing**: The image is pre-processed (resized/normalized) using the `image` package for local inference, or encoded as Base64 for online requests.
3.  **Inference**:
    -   *Offline*: Run against the local `.tflite` model in `assets/`.
    -   *Online*: HTTP POST request to the Supabase API endpoint.
4.  **Result**: Predictions (label and confidence score) are returned and mapped to botanical data.

### 2. Backend Integration (Supabase)
Eden uses Supabase as a real-time backend.
-   **Auth**: Managed via `Supabase.instance.client.auth`.
-   **Storage**: Plant images are uploaded to Supabase buckets.
-   **Database**: PostgreSQL stores user-specific data like the "Digital Garden" collection.

---

## 🔗 Design Patterns

-   **Controller/Provider Pattern**: Features use Riverpod `StateNotifier` or `AsyncNotifier` to handle UI logic separate from building.
-   **Repository Pattern**: (Planned) Data fetching logic is abstracted to handle local vs. remote data sources.
-   **Responsive Layouts**: Widgets are built to adapt to various screen sizes and orientations.

---

## 🌍 Localization (i18n)

The app uses `flutter_localizations` with `.arb` files in `lib/l10n/`.
-   **English (EN)**, **French (FR)**, and **Arabic (AR)** are fully supported.
-   RTL (Right-to-Left) layouts are handled automatically for Arabic users.

---

Developed with ❤️ by the **Korax Team**.
