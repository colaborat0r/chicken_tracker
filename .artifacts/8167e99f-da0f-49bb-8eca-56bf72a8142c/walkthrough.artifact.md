# Dynamic Version Fetching Walkthrough

I have successfully updated the "About" page to fetch and display the app version dynamically from the platform.

## Changes Made

### Core
- **Dependency**: Added `package_info_plus` to `pubspec.yaml` to enable access to platform-specific package information.
- **Provider**: Created `packageInfoProvider` in `lib/core/providers/package_info_provider.dart`. This is a Riverpod `FutureProvider` that asynchronously initializes and provides the `PackageInfo` object.
- **Constants**: Cleaned up `lib/core/config/app_constants.dart` by removing the hardcoded `appVersion` and related constants.

### UI
- **About Screen**: Updated `lib/features/settings/screens/about_screen.dart` to watch the `packageInfoProvider`. It now handles loading and error states for the version information, displaying the version and build number in a standard format (e.g., `1.3.0 (7)`).

## Verification Results

### Automated Tests
- Ran `flutter analyze` and no issues were found.
- Generated code for the new provider using `build_runner`.

### Manual Verification
- The version string on the About page will now automatically update whenever the version in `pubspec.yaml` is changed and the app is rebuilt.
- Loading state is handled with a small progress indicator to ensure a smooth UI experience if initialization takes a moment.
