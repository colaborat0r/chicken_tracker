# Fix Customer Unpaid Balance Issue

The "Sales & CRM" customer list incorrectly displays "$0.00 Unpaid" for customers who have unpaid orders. This is likely due to the database `unpaid_balance` column not being correctly updated or initialized.

## User Review Required

> [!IMPORTANT]
> A startup synchronization task will run once to fix any existing incorrect balances in the database. This might cause a slight delay on the first launch after this update.

## Proposed Changes

### [Customer Repository](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/core/repositories/customer_repository.dart)

#### [MODIFY] [customer_repository.dart](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/core/repositories/customer_repository.dart)
- Ensure `syncCustomerTotals` correctly calculates and saves the `unpaidBalance`.
- Add explicit initialization for `unpaidBalance` in `addCustomer` (though default should work, explicit is safer).

### [Order Repository](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/core/repositories/order_repository.dart)

#### [MODIFY] [order_repository.dart](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/core/repositories/order_repository.dart)
- Ensure `syncCustomerTotals` is called *after* all order modifications (status changes, payment toggles).
- Move `syncCustomerTotals` out of transaction blocks if they were accidentally nested in a way that prevents data visibility.

### [Main App Initialization](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/main.dart)

#### [MODIFY] [main.dart](file:///C:/Users/User/Documents/Chicken Tracker/chicken_tracker/lib/main.dart)
- Verify that `syncAllCustomers()` is correctly called on startup to repair any legacy data issues.

## Verification Plan

### Automated Tests
- N/A (Unit tests could be added for `syncCustomerTotals` logic).

### Manual Verification
1.  Open the app and go to the "Sales & CRM" page.
2.  Create a new customer.
3.  Add a new order for that customer (orders are unpaid by default).
4.  Verify that the customer list now shows the correct unpaid balance.
5.  Go to the order detail, mark it as "Paid", and verify the balance goes to $0.00.
6.  Mark it back as "Unpaid" and verify it returns to the correct amount.
