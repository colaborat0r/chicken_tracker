# Optional Farm Report Metrics - Quick Start Guide

## Summary
Users can now customize which metrics appear on their monthly Farm Report Cards. By default, 6 metrics are shown, and 2 are hidden (Profit/Loss and Feed per Egg).

## Key Features

✨ **User-Customizable Metrics**
- 8 total metrics to choose from
- Toggle each metric on/off with a checkbox
- Settings persist across app sessions
- Reset to defaults with one tap

📊 **Default Configuration**
- ✅ Total Eggs, Sales, Expenses, Flock Count, Laying Count, Laying %
- ❌ Profit/Loss and Feed per Egg (hidden to reduce clutter)

🎨 **Beautiful UI**
- Clean settings screen with descriptions
- Material 3 design
- Organized in Settings menu

## How to Use

### Access Settings
1. Open the app drawer (hamburger menu)
2. Under "Settings" section, tap "Farm Report Settings"

### Customize Metrics
1. Each metric has a checkbox
2. Tap checkbox to enable/disable
3. Settings auto-save immediately
4. Tap "Reset to Defaults" to restore original settings

### Generate Report with New Settings
1. Go to drawer → "Farm Report" button
2. Choose where to share/save
3. PDF will only show enabled metrics

## Available Metrics

| Metric | Default | Description |
|--------|---------|-------------|
| 🥚 Total Eggs | ✅ | Total eggs collected this month |
| 💰 Total Sales | ❌ | Total sales revenue this month |
| 💸 Total Expenses | ❌ | Total farm expenses this month |
| 📊 Profit/Loss | ❌ | Net profit or loss for the month |
| 🐔 Flock Count | ✅ | Current number of chickens |
| 🥚 Laying Count | ✅ | Number of hens currently laying |
| 🌾 Feed per Egg | ❌ | Average feed cost per egg |
| 📈 Laying % | ✅ | Percentage of flock that is laying |

## Technical Details

**Storage**: SharedPreferences (persists across app restarts)
**Location**: Settings → Farm Report Settings
**Route**: `/report-settings`

## Implementation Files

- `lib/core/providers/report_settings_provider.dart` - Settings state management
- `lib/features/home/screens/report_settings_screen.dart` - Settings UI
- `lib/core/services/pdf_export_service.dart` - Dynamic PDF generation
- `lib/config/router.dart` - Route configuration

## Example PDF Layout

With default settings, Farm Report shows in two rows:

**Row 1 (4 metrics):**
🥚 Eggs | 💰 Sales | 💸 Expenses | 🐔 Flock

**Row 2 (2 metrics):**
🥚 Layers | 📈 Lay %

If user enables Profit/Loss and Feed/Egg, it becomes:

**Row 1:** 🥚 Eggs | 💰 Sales | 💸 Expenses | 📊 Profit
**Row 2:** 🐔 Flock | 🥚 Layers | 🌾 Feed/Egg | 📈 Lay %

## Testing Checklist

- [ ] Navigate to Settings → Farm Report Settings
- [ ] Verify Profit/Loss and Feed/Egg are unchecked
- [ ] Toggle metrics on/off
- [ ] Generate a Farm Report and verify PDF layout
- [ ] Close and reopen app - settings should persist
- [ ] Test "Reset to Defaults" button
- [ ] Try different metric combinations

## Future Enhancements

- Preset configurations (Basic, Standard, Detailed)
- Custom metric order/sorting
- Color customization per metric
- Metric visibility preferences per report type
- Export/import settings

---

**Status**: Ready for production use ✅
**Last Updated**: April 22, 2026

