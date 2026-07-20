# Dynamic Version Fetching Implementation Plan

This plan outlines the steps to replace hardcoded version strings with dynamic fetching using `package_info_plus` in the Chicken Tracker app.

## User Review Required

> [!NOTE]
> The app version will now be fetched directly from `pubspec.yaml` (on Android/iOS it comes from the build configuration). This ensures the "About" page always reflects the actual installed version.

## Proposed Changes

### Dependency Management

#### [MODIFY] [pubspec.yaml](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/pubspec.yaml)
- Add `package_info_plus: ^8.0.0` to the dependencies section.

### Core Providers

#### [NEW] [package_info_provider.dart](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/core/providers/package_info_provider.dart)
- Create a `FutureProvider` that initializes and returns `PackageInfo`.

### Configuration

#### [MODIFY] [app_constants.dart](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/core/config/app_constants.dart)
- Remove hardcoded version constants as they will no longer be used.

### Feature: Settings

#### [MODIFY] [about_screen.dart](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/features/settings/screens/about_screen.dart)
- Update the `AboutScreen` to watch `packageInfoProvider`.
- Display the version and build number (e.g., `1.3.0 (7)`) instead of the hardcoded value.

## Verification Plan

### Manual Verification
- Run `flutter pub get` to install the new dependency.
- Open the app and navigate to **Settings > About**.
- Verify that the version number matches what is in `pubspec.yaml` (currently `1.3.0+7`).
- Check that the UI handles the asynchronous loading state of the version info gracefully (e.g., shows a placeholder or nothing until loaded).
