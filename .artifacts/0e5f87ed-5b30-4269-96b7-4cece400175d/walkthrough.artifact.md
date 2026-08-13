# Overall Statistics Range Selection

Implemented date range filtering for the production statistics on the Analytics Dashboard.

## Changes Made

### Core Logic
- **[analytics_providers.dart](file:///C:/Users/User/StudioProjects/chicken_tracker/lib/core/providers/analytics_providers.dart)**:
    - Added `StatsRange` enum: `sevenDays`, `thirtyDays`, `ninetyDays`, `yearToDate`, `allTime`.
    - Created `statsRangeProvider` to track the user's selection.
    - Updated `productionStatsSummaryProvider` to watch the selected range and filter daily logs accordingly.
    - Renamed the summary field from `totalEggsAllTime` to `totalEggs` to better reflect its dynamic nature.

### UI Enhancements
- **[analytics_dashboard_screen.dart](file:///C:/Users/User/StudioProjects/chicken_tracker/lib/features/production/screens/analytics_dashboard_screen.dart)**:
    - Added a horizontal scrollable range selector using `ChoiceChip`s (7d, 30d, 90d, YTD, All).
    - Updated the "Overall Statistics" grid to reactively display data based on the selected period.

## Verification Results

### Automated Tests
- Ran `flutter analyze`: **Passed (No issues found)**.

### Manual Verification Details
- Verified that switching ranges (e.g., from 'All' to '7d') immediately updates:
    - **Total Eggs**: Sum of eggs in the selected period.
    - **Days Tracked**: Number of daily logs within that period.
    - **Avg/Day & Avg/Hen**: Recalculated based on the period's data.
