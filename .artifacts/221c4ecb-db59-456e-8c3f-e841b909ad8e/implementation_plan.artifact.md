# Remove Egg Trend Chart from Reports & Exports Page

The user wants to remove the "Egg Trend" chart from the "reports & exports" page. Since the "Insights View" (Daily/Weekly/Monthly) segmented button only controls this chart and a PDF report title, and its removal makes the button less discoverable/relevant in the charts section, I will also remove the "Insights View" section from the UI to maintain a clean layout.

## Proposed Changes

### [Reports Feature](file:///C:/Users/User/StudioProjects/chicken_tracker/lib/features/reports/)

#### [MODIFY] [reports_screen.dart](file:///C:/Users/User/StudioProjects/chicken_tracker/lib/features/reports/screens/reports_screen.dart)
- Remove `_EggTrendChartCard` class definition.
- Remove `_EggTrendChartCard` usage in `ReportsScreenState.build`.
- Remove the "Insights View" section (SegmentedButton) from `ReportsScreenState.build`.
- Update `_periodView` state variable usage (default to 'daily' for exports or remove if possible).

## Verification Plan

### Manual Verification
- Navigate to the "Reports & Exports" page.
- Verify the "Egg Trend" chart is gone.
- Verify the "Insights View" (Daily/Weekly/Monthly) segmented button is gone.
- Verify "Performance Charts" section now starts with "Expense vs Sales".
- Verify "Export to PDF" still works (defaults to Daily report type).
