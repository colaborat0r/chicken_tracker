# WorkManager Implementation Guide

## File Structure

```
lib/
├── main.dart                                    # WorkManager initialization
├── core/
│   ├── services/
│   │   └── reminder_notification_service.dart  # Main implementation
│   └── providers/
│       └── notification_providers.dart         # Riverpod provider (unchanged)
└── features/
    └── settings/screens/
        └── about_screen.dart                   # Diagnostics UI
```

## Key Code Sections

### 1. Background Task Callback (@main module scope)

```dart
@pragma('vm:entry-point')
void reminderCallback() {
  Workmanager().executeTask((task, inputData) async {
    // This runs in a separate Dart isolate
    // Initialize plugin and show notification
    // Return true on success
  });
}
```

**Important**: The `@pragma('vm:entry-point')` annotation is **critical** - it prevents the Dart compiler from tree-shaking this function during build.

### 2. Service Initialization

```dart
Future<void> initialize() async {
  if (!Platform.isAndroid || _isInitialized) return;
  
  // Initialize WorkManager first
  await Workmanager().initialize(reminderCallback);
  
  // Then initialize local notifications
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: androidSettings);
  await _plugin.initialize(settings);
  
  // Create notification channel
  const channel = AndroidNotificationChannel(
    _channelId,
    _channelName,
    description: _channelDescription,
    importance: Importance.high,
  );
  final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(channel);
  
  _isInitialized = true;
}
```

### 3. Task Scheduling

```dart
await Workmanager().registerOneOffTask(
  uniqueName,                          // Unique ID for this task
  _reminderTaskName,                   // Task type (used to identify task)
  inputData: inputData,                // Data to pass to background function
  initialDelay: delay,                 // When to fire (Duration)
);
```

**Notes**:
- `uniqueName` must be unique across all scheduled tasks
- `_reminderTaskName` should match the constant used in callback routing
- `inputData` is passed as a Map to the background function
- `initialDelay` is calculated as `fireAt - DateTime.now()`

### 4. Task Cancellation

```dart
await _clearScheduledReminderTasks() {
  await Workmanager().cancelAll();  // Cancels all tasks at once
}
```

## Android Configuration

### AndroidManifest.xml
```xml
<manifest xmlns:android="..."
          xmlns:tools="http://schemas.android.com/tools">
  
  <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
  
  <application>
    <!-- WorkManager provider (suppresses automatic initialization) -->
    <provider
        android:name="androidx.startup.InitializationProvider"
        android:authorities="${applicationId}.androidx-startup"
        android:exported="false"
        tools:node="merge">
      <meta-data
          android:name="androidx.work.WorkManagerInitializer"
          android:value="androidx.startup"
          tools:node="remove" />
    </provider>
  </application>
</manifest>
```

## Diagnostics Data Flow

### Capturing Diagnostics:
1. `getDiagnostics()` is called
2. Checks WorkManager initialization state
3. Returns `ReminderNotificationDiagnostics` object with:
   - `workManagerInitialized`: Whether service initialized successfully
   - `notificationsGranted`: User permission status
   - `scheduledTasks`: List of currently scheduled task names
   - `lastScheduleError`: Error message from last scheduling attempt

### Displaying in UI:
```dart
_DiagnosticRow(
  label: 'WorkManager initialized',
  value: _boolLabel(diagnostics?.workManagerInitialized),
),
```

## Common Issues & Solutions

### Issue 1: Tasks not firing after device reboot
**Solution**: WorkManager automatically persists and reschedules tasks. No action needed.

### Issue 2: Background callback not executing
**Cause**: Missing `@pragma('vm:entry-point')` or method tree-shaken by compiler
**Solution**: Ensure pragma annotation is present and exactly as shown

### Issue 3: "isInDebugMode is deprecated"
**Solution**: Remove `isInDebugMode` parameter from `Workmanager().initialize()`

### Issue 4: App crashes when initializing WorkManager
**Cause**: WorkManager not initialized before calling other methods
**Solution**: Ensure `Workmanager().initialize()` is called in `main()` before `ProviderScope`

## Performance Considerations

- **Memory**: WorkManager runs in a separate isolate; notifications are displayed without keeping app in memory
- **Battery**: WorkManager respects system battery optimization and doze mode
- **Reliability**: System manages retries with exponential backoff
- **Scale**: Can handle hundreds of scheduled tasks without performance degradation

## Testing Tips

1. **Immediate notification**: Set `initialDelay` to `Duration(seconds: 5)` for quick testing
2. **Logcat filtering**: `adb logcat | grep -i workmanager`
3. **Manual reschedule**: Use "Re-sync reminders" button in About screen
4. **Check permissions**: Verify both `SCHEDULE_EXACT_ALARM` and `POST_NOTIFICATIONS` are granted
5. **Device state**: Ensure device is not in Doze mode during testing

## References
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [workmanager](https://pub.dev/packages/workmanager)
- [Android WorkManager](https://developer.android.com/develop/background-work/background-tasks/persistent-scheduled-work)

