# SINHA RIDE — Android starter project

Brand: SINHA RIDE  
Tagline: Your Ride, Your Way.  
Theme: Black + Yellow  
Initial market plan: Bihar  
Vehicle categories: Car, Auto, Bike

## What is included

- Flutter customer-app starter (Android-first)
- Home screen with pickup/drop text fields
- Car, Auto and Bike selection
- Form validation
- Local demo booking flow
- My Rides list (stored in app memory only)
- Profile placeholder screen
- Black-and-yellow branding

## Important status

This is the first runnable app foundation, **not yet a live ride-hailing service**.
Bookings currently stay only in the app's memory. There is no real driver matching,
GPS tracking, OTP authentication, server database, online payment, or admin panel yet.
The displayed fares are illustrative placeholders and must not be used as actual prices.

## Run on Android

1. Install Flutter SDK and Android Studio.
2. Extract this ZIP.
3. In a terminal, open the `sinha_ride` folder.
4. Run:

   ```bash
   flutter create . --platforms=android
   flutter pub get
   flutter run
   ```

`flutter create` generates the standard Android runner files for your local SDK.
Connect an Android phone with USB debugging enabled or start an Android emulator.

## Next development milestones

1. Create secure backend API and database.
2. Add customer phone OTP authentication.
3. Build a separate driver app and driver onboarding/document review.
4. Connect a maps provider and location permissions.
5. Add live driver availability, dispatch and trip state management.
6. Add payment gateway only after merchant onboarding and compliance review.
7. Build admin web dashboard, audit logs, support and safety workflows.
8. Test in one city with a small, verified pilot fleet before expanding across Bihar.

## Production requirements

Before accepting real rides, arrange appropriate business/aggregator permissions,
vehicle and driver document checks, insurance/permit verification, privacy policy,
terms, support process, emergency escalation, secure secrets management, and
Google Play / Apple developer accounts. Do not put API keys or passwords in source control.
