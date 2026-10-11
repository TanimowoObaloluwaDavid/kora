# Kora

**A modern social & chat app built with Flutter.**

Kora is a polished, fully-featured social networking experience: a story-driven feed,
real-time-feeling chat, exploration, rich profiles and a beautiful ad-free UI — all
running on clean, dependency-light Flutter with an offline mock backend.

> Built as a complete, production-shaped Flutter project: custom theming, a hand-drawn
> vector brand mark, light & dark modes, state management with `provider`, and a full
> screen flow from splash to settings.

---

## ✨ Features

- **Branded splash** — animated logo with pulsing rings.
- **Onboarding** — three illustrated slides with page indicators.
- **Auth** — login & sign-up with validation, password visibility, and social buttons.
- **Home feed** — stories bar with a live story viewer (segmented progress, tap nav,
  auto-advance), rich post cards, double-tap to like with a heart burst, comments.
- **Explore** — people/tag/post search, trending tags, follow suggestions, and an
  explore grid.
- **Chats** — conversation list with unread badges, "active now" row, message bubbles
  with delivery/read receipts, and a simulated auto-reply.
- **Profiles** — animated cover + avatar, stats, edit profile, and Posts / Saved /
  Tagged tabs.
- **Notifications** — activity feed with typed icons and read/unread state.
- **Settings** — persisted light/dark theme toggle, account and support sections.
- **Light & dark themes** built on Material 3 with a custom colour extension.
- **No image assets required** — every avatar and photo is a hashed gradient,
  generated at runtime.

## 📱 Screens

| Splash | Onboarding | Feed | Chats | Profile |
| --- | --- | --- | --- | --- |
| Animated logo | 3 slides | Stories + posts | List + thread | Cover + tabs |

## 🏗️ Architecture

```
lib/
├── main.dart                  # entry point
├── app.dart                   # MaterialApp, routes, providers
├── core/
│   ├── branding/              # KoraLogo (CustomPainter), wordmark
│   ├── theme/                 # colours, Material 3 theme, ThemeExtension
│   └── utils/                 # relative-time & number formatters
├── data/
│   ├── models/                # AppUser, Post, Story, ChatThread, Message, ...
│   └── mock_data.dart         # seed content (no backend needed)
├── state/
│   ├── app_state.dart         # ChangeNotifier app store
│   └── theme_controller.dart  # light/dark controller
├── widgets/                   # GradientAvatar, GradientArt, PostGrid, ...
└── features/
    ├── splash/  onboarding/  auth/
    ├── shell/                 # bottom-nav shell + create-post sheet
    ├── feed/                  # feed, story viewer, post detail, post card
    ├── search/                # explore
    ├── chats/                 # list + conversation
    ├── profile/               # profile, edit profile, settings
    └── notifications/
```

**State management:** [`provider`](https://pub.dev/packages/provider) with a single
`AppState` `ChangeNotifier`. All data is seeded in-memory, so the app runs with zero
setup and no backend.

## 🚀 Getting started

```bash
# 1. Get dependencies
flutter pub get

# 2. Run (pick a device: chrome, an emulator, or a physical device)
flutter run

# Optional: run the tests
flutter test

# Optional: check for issues
flutter analyze
```

Requires **Flutter 3.41+ / Dart 3.11+**.

## 🎨 Design system

- **Brand gradient:** `#6C4DF6 → #FF5C8A` (violet → pink)
- **Accent:** `#2BE0A8` (mint)
- **Typeface:** Plus Jakarta Sans (via `google_fonts`)
- **Radius / spacing:** soft 16–28px radii, generous spacing

## 🛠️ Built with

- Flutter & Dart
- `provider` — state management
- `google_fonts` — typography
- Hand-authored `CustomPainter` for the logo and media placeholders

## 📄 License

MIT © Tanimowo Obaloluwa
