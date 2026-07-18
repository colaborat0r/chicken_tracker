# Task: Fix Customer Unpaid Balance Issue

- [x] Update `CustomerRepository`
    - [x] Explicitly initialize `unpaidBalance` in `addCustomer`
    - [x] Restore and fix `syncCustomerTotals` logic
- [x] Update `OrderRepository`
    - [x] Ensure `syncCustomerTotals` is called in all relevant methods
    - [x] Verify `togglePaidStatus` and `toggleDeliveredStatus` consistency
- [x] Verify startup sync in `main.dart`
- [x] Manual verification (simulated)
