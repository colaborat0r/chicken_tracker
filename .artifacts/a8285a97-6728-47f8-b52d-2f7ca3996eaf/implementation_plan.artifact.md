# Implementation Plan - Fix Automatic "Growing" to "Laying" Transition

This plan addresses the issue where birds are not automatically transitioning from "Growing" to "Laying" status after 140 days, even though the logic exists in the repository.

## User Review Required

> [!NOTE]
> The transition will now be triggered whenever you open the **My Flock** page, in addition to app startup. This ensures that even if you leave the app open for days, the statuses will refresh when you check your flock.

## Proposed Changes

### Core Repositories

#### [MODIFY] [chicken_repository.dart](file:///C:/Users/User/Documents/Chicken%20Tracker/chicken_tracker/lib/core/repositories/chicken_repository.dart)
- Update `autoUpdateGrowingBirds` to be slightly more efficient by using a single batch update if possible, or keeping it as is but ensuring it's robust. (Current implementation is fine but I'll double check the `ageInDays` consistency).

### Core Models

#### [MODIFY] [chicken_model.dart](file:///C:/Users/User/Documents/Chicken%20Tracker/chicken_tracker/lib/core/models/chicken_model.dart)
- Simplify the `isLaying` getter to rely solely on the `status` field.
- **Reasoning**: The `status` field is intended to be the source of truth for the bird's lifecycle. The "automatic update" logic's job is to keep this field correct based on age. Checking age again in the UI can cause "disappearing" birds if the status was updated but the age calculation differs slightly by a few seconds.

### Chickens Feature

#### [MODIFY] [chicken_list_screen.dart](file:///C:/Users/User/Documents/Chicken%20Tracker/chicken_tracker/lib/features/chickens/screens/chicken_list_screen.dart)
- Call `ref.read(chickenRepositoryProvider).autoUpdateGrowingBirds()` in `initState` to ensure the flock is maintained whenever the screen is visited.
- Update `_AgeStatusSummary` to use the simplified `isLaying` property (or just `status == 'laying'`).

## Verification Plan

### Manual Verification
1.  **Test Update**: I will simulate a bird reaching 140 days by manually setting a "Growing" bird's hatch date in the database to 141 days ago (if I had DB access, but I'll describe this for the user).
2.  **Verify UI**:
    - Open "My Flock" page.
    - Check if "Laying" count in Hero matches "Laying" count in Breakdown card.
    - Verify that birds older than 140 days are correctly labeled as "Laying".
