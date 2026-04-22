# Optional Farm Report Metrics - Implementation Complete

## Status: ✅ COMPLETE

Users can now customize which metrics appear on their Farm Report Cards. Two metrics are disabled by default (Profit/Loss and Feed per Egg) to reduce clutter.

## What Changed

### 1. **New Report Settings Provider** (`lib/core/providers/report_settings_provider.dart`)
- `reportSettingsProvider`: StateNotifierProvider managing which metrics are enabled
- `ReportSettings`: Model storing boolean flags for 8 metrics
- `ReportMetric`: Enum with all 8 metrics
- `ReportSettingsNotifier`: StateNotifier for managing settings with SharedPreferences persistence
- Default settings: 6 metrics enabled, 2 disabled (Profit/Loss, Feed/Egg)

### 2. **Updated PDF Service** (`lib/core/services/pdf_export_service.dart`)
- **FarmReportData**: Added `settings: ReportSettings` field
- **New method**: `_buildStatsGridWithSettings()` - dynamically builds stats grid based on enabled metrics
- Replaced static stats display with dynamic layout that respects user preferences
- Modified stats grid to display 4 metrics per row, wrapping as needed

### 3. **New Report Settings Screen** (`lib/features/home/screens/report_settings_screen.dart`)
- Beautiful CheckboxListTile UI for each metric
- Shows metric label and description
- "Reset to Defaults" button to restore original settings
- Clean Material 3 design with AppBar

### 4. **Updated Home Screen** (`lib/features/home/screens/home_screen.dart`)
- Added import for `report_settings_provider`
- Updated `_generateFarmReport()` to read settings and pass to FarmReportData
- Added "Farm Report Settings" menu item in drawer (under Settings section)

### 5. **Updated Router** (`lib/config/router.dart`)
- Added `Routes.reportSettings` constant
- Added GoRoute for ReportSettingsScreen
- Added import for ReportSettingsScreen

## Default Enabled Metrics

✅ Enabled:
- Total Eggs Collected
- Total Sales Revenue
- Total Expenses
- Flock Count
- Laying Hens Count
- Laying Percentage

❌ Disabled (Profit/Loss and Feed per Egg):
- Profit/Loss
- Feed Cost per Egg

Users can enable these at any time via Settings → Farm Report Settings.

## Metric Configuration Options

1. **Total Eggs**: Eggs collected this month
2. **Total Sales**: Sales revenue this month
3. **Total Expenses**: Total farm expenses this month
4. **Profit/Loss**: Net profit or loss (disabled by default)
5. **Flock Count**: Current number of chickens
6. **Laying Hens**: Number of hens currently laying
7. **Feed per Egg**: Average feed cost per egg (disabled by default)
8. **Laying Percentage**: % of flock that is laying

## How It Works

### User Flow
1. User taps "Farm Report Settings" from drawer
2. Settings screen shows all 8 metrics with checkboxes
3. Currently disabled metrics show as unchecked
4. User checks/unchecks metrics as desired
5. Settings auto-save to SharedPreferences
6. User generates Farm Report - only enabled metrics appear on PDF

### Data Persistence
- Settings stored in SharedPreferences with key `report_enabled_metrics`
- Format: `"metric_name:true/false"` list
- Persists across app restarts
- Reset to defaults available with one tap

### PDF Generation
- `_buildStatsGridWithSettings()` builds conditional rows
- Layout: 4 metrics per row, wraps to next row if needed
- Colored boxes for profit (green/red) if enabled
- Shows "No metrics selected" message if all disabled (rare)

## Code Quality

✅ **flutter analyze**: 10 style hints only (no errors)
✅ **Type-safe**: Full type checking with Dart
✅ **State Management**: Riverpod providers with reactive updates
✅ **Persistence**: SharedPreferences with error handling
✅ **Error Handling**: Graceful fallbacks

## Testing Notes

To verify the implementation:
1. Open app and navigate to drawer → Farm Report Settings
2. Verify Profit/Loss and Feed per Egg are unchecked
3. Check/uncheck various metrics
4. Generate a Farm Report (drawer → Farm Report button)
5. Verify PDF shows only selected metrics
6. Close app and reopen - settings should persist
7. Tap "Reset to Defaults" and verify state resets

## Files Modified/Created

**Created:**
- `lib/core/providers/report_settings_provider.dart` (232 lines)
- `lib/features/home/screens/report_settings_screen.dart` (113 lines)

**Modified:**
- `lib/core/services/pdf_export_service.dart` (+import, +settings field, +helper method)
- `lib/features/home/screens/home_screen.dart` (+import, +settings read, +menu item)
- `lib/config/router.dart` (+import, +route constant, +GoRoute)

## Next Steps (Optional)

Users can further customize:
- Add icon selection per metric
- Add color customization
- Add preset configurations (Basic, Standard, Detailed)
- Export/import settings as JSON
- Share settings with other users

But the core feature is complete and ready for production use!

