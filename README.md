<div align="center">

```
 ██████╗ ██╗   ██╗███╗   ███╗    ████████╗██████╗  █████╗ ██╗███╗   ██╗███████╗██████╗
██╔════╝ ╚██╗ ██╔╝████╗ ████║    ╚══██╔══╝██╔══██╗██╔══██╗██║████╗  ██║██╔════╝██╔══██╗
██║  ███╗ ╚████╔╝ ██╔████╔██║       ██║   ██████╔╝███████║██║██╔██╗ ██║█████╗  ██████╔╝
██║   ██║  ╚██╔╝  ██║╚██╔╝██║       ██║   ██╔══██╗██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗
╚██████╔╝   ██║   ██║ ╚═╝ ██║       ██║   ██║  ██║██║  ██║██║██║ ╚████║███████╗██║  ██║
 ╚═════╝    ╚═╝   ╚═╝     ╚═╝       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
```

### Your AI-Powered Personal Fitness Companion

*Train smarter. Move better. Never train alone.*

---

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Gemini AI](https://img.shields.io/badge/Gemini-2.5_Flash-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-Backend-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Python](https://img.shields.io/badge/Python-Flask_+_MediaPipe-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![Platform](https://img.shields.io/badge/Platform-Android_|_iOS-green?style=for-the-badge&logo=android&logoColor=white)](https://flutter.dev/multi-platform)

</div>

---

## What is AI Gym Trainer?

**AI Gym Trainer** is a full-stack Flutter fitness application that merges real-time computer vision, generative AI, and personalized tracking into one dark-themed, glassmorphism-styled experience. It is not just another step counter — it watches your form as you lift, chats with you like a coach, and builds your workout plan on the fly.

At the center of it all is **Julie**, your AI personal trainer powered by Gemini 2.5 Flash, ready to answer your questions, build your plan, and keep you motivated.

---

## Meet Julie — Your AI Personal Trainer

<div align="center">

```
  ╔══════════════════════════════════════════════════════════════╗
  ║                                                              ║
  ║   ✨  Hi! I'm Julie.                                        ║
  ║                                                              ║
  ║   I'm your AI fitness coach — powered by Google Gemini.     ║
  ║   Ask me anything about:                                     ║
  ║                                                              ║
  ║   💪  Workout routines & programming                        ║
  ║   🥗  Nutrition and recovery tips                           ║
  ║   📐  Exercise form and technique                           ║
  ║   🔥  Staying motivated when it's hard                      ║
  ║                                                              ║
  ║   "You are good to go!! Go for it CHAMP!!!!"                ║
  ║                                        — Julie              ║
  ╚══════════════════════════════════════════════════════════════╝
```

</div>

Julie is friendly, motivational, and knowledgeable about fitness, nutrition, and wellness. She keeps answers concise and always encourages your progress. Her chat history is persisted locally via `ChatStorageService`, so your conversations carry context across sessions. Her most recent insights also feed directly into the **AI-generated daily tip** on your dashboard.

---

## Feature Showcase

| Feature | Description |
|---|---|
| 🤖 **AI Chat with Julie** | Real-time chat powered by Gemini 2.5 Flash with persistent session history |
| 🦾 **Pose Detection** | MediaPipe-based rep counting and form analysis for curls, squats & push-ups |
| 📊 **Smart Dashboard** | Live stats — calories burned, streak, weekly goal, and a daily AI tip |
| 🏋️ **Workout Library** | Create, manage, and execute custom workout routines with session timers |
| 📚 **Exercise Database** | Detailed exercise cards with instructions, muscle groups, and tips |
| 🔥 **Calorie Calculator** | Three-tier MET + heart-rate + AI-enhanced calorie estimation per session |
| 👤 **User Profile** | Personal info, fitness goals, notification preferences, and app settings |
| 🔐 **Secure Auth** | Email/password and Google Sign-In via Firebase Auth + Spring Boot JWT backend |
| 🎨 **Dark Glassmorphism UI** | Deep navy gradient with purple accent `#6C63FF → #9C88FF` and frosted cards |

---

## Screenshots

<div align="center">

| Dashboard | AI Trainer (Julie) | Pose Detection |
|:---------:|:------------------:|:--------------:|
| `[screenshot]` | `[screenshot]` | `[screenshot]` |

| Workouts | Exercise Detail | Profile |
|:--------:|:---------------:|:-------:|
| `[screenshot]` | `[screenshot]` | `[screenshot]` |

> Screenshots coming soon. Run the app and contribute yours — see [Contributing](#contributing).

</div>

---

## Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                         Flutter App (Dart)                           │
│                                                                      │
│  ┌──────────┐  ┌──────────┐  ┌─────────────┐  ┌──────────────────┐  │
│  │Dashboard │  │Workouts  │  │ AI Trainer  │  │ Pose Detection   │  │
│  │  Page    │  │  Page    │  │  (Julie)    │  │    Page          │  │
│  └────┬─────┘  └────┬─────┘  └──────┬──────┘  └────────┬─────────┘  │
│       │              │               │                   │            │
│  ┌────▼──────────────▼───────────────▼───────────────────▼────────┐  │
│  │                   GetX Controllers / Services                   │  │
│  │   DashboardService   WorkoutTrackerService   AIChatbotService   │  │
│  │   RecommendationService   CalorieCalculator   PoseAnalyzer      │  │
│  └────┬─────────────────────────┬─────────────────────────┬───────┘  │
└───────┼─────────────────────────┼─────────────────────────┼──────────┘
        │                         │                         │
        ▼                         ▼                         ▼
┌───────────────┐      ┌──────────────────────┐   ┌──────────────────────┐
│  Firebase     │      │  Spring Boot         │   │  Python Flask        │
│  Auth         │      │  Backend (Java)      │   │  Pose Server         │
│               │      │  JWT + REST API      │   │  MediaPipe + OpenCV  │
│  Google       │      │  68.233.96.179:8080  │   │  /analyze endpoint   │
│  Sign-In      │      └──────────┬───────────┘   └──────────────────────┘
└───────────────┘                 │
                        ┌─────────▼──────────┐
                        │  Gemini 2.5 Flash  │
                        │  Google AI API     │
                        │  ┌──────────────┐  │
                        │  │ Julie chat   │  │
                        │  │ Daily tips   │  │
                        │  │ AI calories  │  │
                        │  └──────────────┘  │
                        └────────────────────┘
```

---

## Tech Stack

<details>
<summary><b>Frontend — Flutter</b></summary>

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK `^3.8.1` | Cross-platform UI framework |
| `get` | `^4.7.2` | State management, routing, DI |
| `google_fonts` | `^6.1.0` | Poppins (headings) + Inter (body) |
| `camera` | `^0.11.2+1` | Live camera feed for pose detection |
| `web_socket_channel` | `^3.0.3` | WebSocket stream to pose server |
| `http` | `^1.2.0` | REST calls to Spring Boot + Gemini |
| `firebase_core` | `^4.2.0` | Firebase initialization |
| `firebase_auth` | `^6.1.2` | Email/password authentication |
| `google_sign_in` | `^7.2.0` | OAuth Google login |
| `flutter_secure_storage` | `^9.2.4` | Encrypted local token storage |
| `shared_preferences` | `^2.2.2` | Lightweight key-value persistence |
| `permission_handler` | `^12.0.1` | Camera & notification permissions |
| `share_plus` | `^7.0.0` | Share workout summaries |
| `csv` | `^5.0.1` | Export workout data to CSV |

</details>

<details>
<summary><b>Backend — Spring Boot</b></summary>

| Layer | Technology |
|-------|------------|
| Language | Java |
| Framework | Spring Boot |
| Auth | JWT (JSON Web Tokens) stored via `FlutterSecureStorage` |
| Deployment | Remote server — `68.233.96.179:8080` |

</details>

<details>
<summary><b>Pose Detection — Python Flask</b></summary>

| Component | Technology |
|-----------|------------|
| Language | Python 3.x |
| Web framework | Flask |
| Pose estimation | MediaPipe Pose (33 landmark points) |
| Image processing | OpenCV, NumPy |
| Communication | HTTP POST `/analyze` (base64 JPEG + exercise type) |
| Rep counting | Custom `RepCounter` class with angle thresholds |
| Supported exercises | Bicep curls, squats, push-ups |
| Deployment | Local LAN or Vercel |

</details>

<details>
<summary><b>AI — Google Gemini</b></summary>

| Use Case | Model | Details |
|----------|-------|---------|
| Julie chatbot | `gemini-2.5-flash` | Persistent message history, fitness-focused system prompt |
| Daily dashboard tip | `gemini-2.5-flash` | Context from recent chat history |
| AI calorie estimation | `gemini-2.5-flash` | Combines MET + user profile for refined estimate |

</details>

---

## Project Structure

```
gym_paglu/
├── lib/
│   ├── main.dart                         # App entry, GetX bindings, routing
│   ├── firebase_options.dart
│   ├── core/
│   │   ├── envVars.dart                  # API base URL config
│   │   └── theme/
│   │       └── app_theme.dart            # Light/dark Material themes
│   ├── controllers/                      # GetX services (single-responsibility)
│   │   ├── auth_controller.dart
│   │   ├── google_auth_service.dart
│   │   ├── ai_chatbot_service.dart       # Gemini API — Julie
│   │   ├── ai_workout_recommendation_service.dart
│   │   ├── recommendation_service.dart
│   │   ├── calorie_calculator.dart       # MET → HR → AI calorie tiers
│   │   ├── dashboard_service.dart
│   │   ├── workout_tracker.dart
│   │   ├── workout_tracker_service.dart
│   │   ├── user_profile_service.dart
│   │   ├── user_workout_service.dart
│   │   ├── exercise_db_service.dart
│   │   ├── chat_storage_service.dart     # Persistent chat history
│   │   ├── notification_service.dart
│   │   ├── theme_controller.dart
│   │   └── workoutsService.dart
│   ├── models/
│   │   └── workout.dart
│   ├── screens/
│   │   ├── auth/         (login_screen, signup_screen)
│   │   ├── home/         (home_screen — 5-tab shell)
│   │   ├── dashboard/    (dashboard_page)
│   │   ├── workouts/     (workouts_page, add_workout_page, workout_session_page)
│   │   ├── exercises/    (exercises_page, exercise_detail_page)
│   │   ├── ai_trainer/   (ai_trainer_page, chat_page)
│   │   ├── pose/         (poseScreen)
│   │   └── profile/      (profile_page, personal_info_page, fitness_goals_page,
│   │                       settings_page, notifications_page, help_support_page)
│   ├── widgets/
│   │   └── formatted_text.dart
│   ├── utils/
│   │   └── string_utils.dart
│   └── Pose_Detection/
│       ├── web_camera.py                 # Flask server entry point
│       ├── poseAnalyzer.dart             # Flutter HTTP client for pose API
│       ├── posePage.dart
│       └── SETUP_GUIDE.md
├── assets/
│   └── images/
├── android/
├── pubspec.yaml
└── firebase.json
```

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.8.1` — [install guide](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code with Flutter + Dart extensions
- Python 3.9+ (for local pose detection server)
- A Firebase project with Authentication enabled
- A Google Gemini API key — [get one free](https://aistudio.google.com/app/apikey)

---

### 1. Clone

```bash
git clone https://github.com/YOUR_USERNAME/gym_paglu.git
cd gym_paglu
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Firebase setup

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Email/Password** and **Google** sign-in providers
3. Download `google-services.json` → place in `android/app/`
4. Download `GoogleService-Info.plist` → place in `ios/Runner/`
5. Update `lib/firebase_options.dart` (or run `flutterfire configure`)

### 4. Gemini API key

Open `lib/controllers/ai_chatbot_service.dart` and replace the key:

```dart
const apiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

> For production, use `--dart-define=GEMINI_KEY=...` and read it via `const String.fromEnvironment('GEMINI_KEY')`.

### 5. Backend URL

Open `lib/core/envVars.dart`:

```dart
class ApiConfig {
  static const String serviceApi = 'http://YOUR_BACKEND_HOST:8080';
}
```

### 6. Start the pose detection server

```bash
cd lib/Pose_Detection

pip install flask opencv-python mediapipe numpy

python web_camera.py
```

The server will print its local IP. Update the URL list in `lib/Pose_Detection/poseAnalyzer.dart`:

```dart
static const List<String> _serverUrls = [
  'https://your-deployed-server.vercel.app',
  'http://YOUR_LOCAL_IP:5000',
];
```

### 7. Android HTTP permissions

For non-HTTPS local connections, add your IP to `android/app/src/main/res/xml/network_security_config.xml`:

```xml
<domain includeSubdomains="true">YOUR_LOCAL_IP</domain>
```

### 8. Run

```bash
flutter run

# Release APK
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle --release
```

---

## API Reference

### Spring Boot Backend (`/api`)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/api/auth/register` | None | Register a new user |
| `POST` | `/api/auth/login` | None | Login — returns JWT |
| `POST` | `/api/auth/firebase-login` | None | Google/Firebase token exchange |
| `GET` | `/api/user/profile` | Bearer JWT | Get user profile |
| `PUT` | `/api/user/profile` | Bearer JWT | Update profile |
| `GET` | `/api/workouts` | Bearer JWT | List user workouts |
| `POST` | `/api/workouts` | Bearer JWT | Create a workout |
| `DELETE` | `/api/workouts/{id}` | Bearer JWT | Delete a workout |
| `GET` | `/api/dashboard/stats` | Bearer JWT | Streak, calories, weekly goal |
| `POST` | `/api/stats/session` | Bearer JWT | Log a completed session |

### Python Pose Detection Server (`localhost:5000`)

| Method | Endpoint | Body | Description |
|--------|----------|------|-------------|
| `POST` | `/analyze` | `{ image: base64, exercise: string }` | Analyze pose frame — returns reps + form feedback |
| `POST` | `/reset` | `{ exercise: string }` | Reset rep counter for a given exercise |
| `GET` | `/health` | — | Server health check |

**Supported exercise values:** `curl` · `squat` · `pushup`

**Example `/analyze` response:**

```json
{
  "pose_detected": true,
  "exercise": "curl",
  "reps": 5,
  "stage": "down",
  "angle": 142.3,
  "feedback": "Good form! Keep your elbow steady.",
  "landmarks": {}
}
```

---

## How Pose Detection Works

```
Flutter Camera Frame
        │
        ▼  (JPEG bytes → base64)
  PoseAnalyzer.dart
        │
        ▼  HTTP POST /analyze
  Flask Server (web_camera.py)
        │
        ▼
  MediaPipe Pose (33 landmarks)
        │  landmark coordinates
        ▼
  Angle Calculation (shoulder / elbow / wrist…)
        │
        ▼
  RepCounter (state machine: up ↔ down)
        │
        ▼
  JSON Response → Flutter UI overlay
```

**Rep counting thresholds (from `web_camera.py`):**

| Exercise | Joint | Down threshold | Up threshold |
|----------|-------|---------------|-------------|
| Bicep Curl | Elbow angle | 160° | 40° |
| Squat | Knee angle | 100° | 60° |
| Push-up | Elbow angle | 100° | 40° |

---

## Calorie Calculation

`CalorieCalculator` uses a three-tier strategy — each tier adds precision:

1. **MET-based** — standard metabolic equivalent values per exercise type
   - Walking: 3.5 METs · Strength training: 5.0 · HIIT: 8.5 · etc.
2. **Heart-rate-based** — Keytel formula using age, weight, heart rate, and gender
3. **AI-enhanced** — Gemini prompt combining full user profile + workout session data

The best available estimate is persisted via `FlutterSecureStorage` and surfaced on the dashboard.

---

## Design System

```
Color Palette
────────────────────────────────────────────────────────
Background gradient:  #0F0F23  →  #1A1A2E  →  #16213E
Primary accent:       #6C63FF  (purple)
Accent gradient:      #6C63FF  →  #9C88FF
Dark background:      #121212
Text primary:         #FFFFFF
Text secondary:       Grey[400]

Glassmorphism cards:
  fill:    Colors.white.withOpacity(0.05 – 0.10)
  border:  Colors.white.withOpacity(0.10 – 0.15)
  blur:    BackdropFilter + ImageFilter.blur(sigmaX/Y: 10)

Typography:
  Display / headings  →  Poppins (Bold, SemiBold)
  Body / labels       →  Inter  (Regular, Medium)
```

---

## Contributing

Contributions are welcome. Here is how to get started:

### Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Follow existing GetX patterns — one `GetxController` per domain
4. Test on Android (iOS support is a bonus)
5. Open a Pull Request with a clear description

### Ideas for contribution

- [ ] More pose detection exercises (deadlift, plank, lunges)
- [ ] Progressive overload tracking over time
- [ ] Workout history charts with `fl_chart`
- [ ] Google Fit / Apple Health integration
- [ ] Offline mode with local exercise database
- [ ] Unit and widget tests (`flutter_test`)
- [ ] App screenshots for this README

### Code style

- Use `GetxController` for all state — avoid `StatefulWidget` where unnecessary
- Keep services single-responsibility
- Prefix observable variables with `Rx` or suffix with `.obs`
- Use `GoogleFonts.poppins()` for display text, `GoogleFonts.inter()` for body

### Reporting issues

Open an issue and include:
- Device model and Android/iOS version
- Flutter version (`flutter --version`)
- Steps to reproduce
- Expected vs actual behaviour

---

## Roadmap

- [x] AI chatbot (Julie) with Gemini 2.5 Flash
- [x] Pose detection — bicep curl, squat, push-up
- [x] Firebase Auth + Google Sign-In
- [x] Workout session timer with calorie tracking
- [x] Streak and weekly goal tracking
- [x] Exercise database with detail pages
- [x] Dark glassmorphism UI
- [x] Data export to CSV
- [ ] Push notifications for workout reminders
- [ ] Workout history analytics dashboard
- [ ] More pose detection exercises
- [ ] Progressive overload tracking
- [ ] iOS App Store release
- [ ] Wearable / heart rate monitor integration

---

<div align="center">

Built with Flutter, fueled by Gemini, and a lot of reps.

**[Report a Bug](../../issues/new)** · **[Request a Feature](../../issues/new)** · **[Start a Discussion](../../discussions)**

---

*"You are good to go!! Go for it CHAMP!!!!"* — Julie

</div>
