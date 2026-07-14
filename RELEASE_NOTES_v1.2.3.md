# Chicken Tracker v1.2.3 Release Notes

## Summary
This release focuses on improving the home screen activity feed, enhancing sales tracking with unit conversions and payment status, and resolving various lint issues.

## Features & Improvements
- **Enhanced Recent Activity Feed**: The home screen now shows a combined feed of production logs, sales, and expenses.
- **Improved Sales Tracking**:
    - **Unit Conversions**: Added automatic conversion for egg sales (Crates and Dozens are now correctly calculated in total egg counts).
    - **Payment Status**: Sales can now be marked as "Paid" or "Pending".
- **Database Migration**: Upgraded database schema to version 7 to support payment status tracking.
- **AI Agent Guidelines**: Updated `AGENTS.md` with a mandatory requirement to run `flutter analyze` after major changes.

## Bug Fixes & Linting
- Resolved multiple lint errors and warnings across the codebase.
- Fixed deprecated property usage in `DropdownButtonFormField`.
- Corrected unit sum calculations in the Sales stats.
- Fixed layout and sorting issues in the activity feed.

## Development
- Incremented version to `1.2.3+6`.
- Verified 0 issues with `flutter analyze`.
