# Overall Statistics Range Selection

Add date range filtering options to the "Overall Statistics" section of the Analytics Dashboard to allow users to see production metrics for specific periods (7d, 30d, 90d, YTD, All Time).

## User Review Required

> [!NOTE]
> I am proposing a horizontal scrolling list of `ChoiceChip`s for range selection to accommodate 5 options (7d, 30d, 90d, YTD, All Time) comfortably on mobile screens.

## Proposed Changes

### Core Analytics

#### [MODIFY] [analytics_providers.dart](file:///C:/Users/User/StudioProjects/chicken_tracker/lib/core/providers/analytics_providers.dart)
- Define `StatsRange` enum.
- Add `statsRangeProvider` (StateProvider).
- Update `productionStatsSummaryProvider` to watch `statsRangeProvider` and filter the logs by the selected date range.
- Rename `totalEggsAllTime` to `totalEggs` in the record returned by `productionStatsSummaryProvider`.

### UI Features

#### [MODIFY] [analytics_dashboard_screen.dart](file:///C:/Users/User/StudioProjects/chicken_tracker/lib/features/production/screens/analytics_dashboard_screen.dart)
- Add a range selector (using `ChoiceChip` in a horizontal `ListView`) under the "Overall Statistics" title.
- Update `StatCard` usage to use the renamed `totalEggs` field.
- Ensure the UI reactively updates when the range is changed.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no breaking changes in record field names.

### Manual Verification
- Open Analytics Dashboard.
- Toggle between 7d, 30d, and All Time.
- Verify that "Total Eggs", "Avg/Day", and "Avg/Hen" update correctly.
- Verify that "Days Tracked" correctly reflects the number of days in the selected range (e.g., max 7 for 7d).
