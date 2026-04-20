# Chicken Tracker - AI Agent Guidelines

## Overview
Offline-first Flutter app for homesteaders tracking chicken flocks, egg production, expenses, and farm operations. Built with clean architecture separating UI features from core business logic.

## Architecture
- **lib/features/**: Feature-specific UI screens (chickens, production, expenses, etc.)
- **lib/core/**: Business logic, data layer, and shared components
  - `database/`: Drift SQLite schema and DAOs
  - `models/`: Domain models with computed properties (age calculations, production metrics)
  - `providers/`: Riverpod state management
  - `repositories/`: Data access layer wrapping database operations
  - `services/`: Business services (notifications, analytics)
  - `theme/`: Material 3 theming with brown farm color scheme
  - `widgets/`: Reusable UI components
- **lib/config/**: App configuration (Go Router navigation)

## Key Patterns
- **State Management**: Riverpod providers in `core/providers/`. Use `ConsumerWidget`/`ConsumerStatefulWidget` for reactive UI.
- **Navigation**: Go Router with named routes in `Routes` class. Pass complex data via `state.extra`.
- **Database**: Drift ORM. Run `flutter pub run build_runner build` after schema changes to generate `*.g.dart` files.
- **Models**: Immutable with `copyWith()` methods. Business logic in getters (e.g., `ChickenModel.isLaying` checks age >140 days).
- **Theming**: Defaults to dark mode for farm use. Brown seed color (`0xFF8B4513`).

## Development Workflow
- **Code Generation**: `flutter pub run build_runner build` (Drift, Riverpod annotations)
- **Icons**: `flutter pub run flutter_launcher_icons:main` (updates app icons across platforms)
- **Linting**: `flutter analyze`
- **Testing**: `flutter test`
- **Running**: `flutter run` or `./scripts/run-android-emulator.ps1` (PowerShell script for emulator setup)

## Conventions
- Feature screens in `lib/features/{feature}/screens/`
- Repository methods return `Future` or `Stream` for async operations
- Use `intl` package for date formatting (e.g., `DateFormat.yMMMd()`)
- Charts via `fl_chart` package for production analytics
- PDF/CSV export via `printing` and `csv` packages
- Notifications via `flutter_local_notifications` with timezone handling

## Common Tasks
- **Add new feature**: Create `lib/features/{name}/screens/` with screen widgets, add route to `config/router.dart`
- **Database changes**: Modify tables in `core/database/app_database.dart`, run build_runner, update schema version
- **New model**: Add to `core/models/`, create repository in `core/repositories/`, provider in `core/providers/`
- **UI component**: Add to `core/widgets/` if reusable across features

## References
- `pubspec.yaml`: Dependencies and build config
- `lib/main.dart`: App initialization with Riverpod ProviderScope
- `lib/core/database/app_database.dart`: Database schema and migrations
- `lib/config/router.dart`: Route definitions
- `lib/core/theme/app_theme.dart`: Theming configuration</content>
<parameter name="filePath">C:\Users\User\Documents\Chicken Tracker\chicken_tracker\AGENTS.md
