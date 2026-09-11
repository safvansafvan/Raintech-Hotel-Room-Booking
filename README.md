# Hotel Room Booking

A responsive Flutter booking calculator created for the Raintech Software Limited coding exercise. Users can choose check-in and check-out dates, select a hotel room, and immediately see the number of nights and total stay price.

## Features

- Five rooms from the supplied coding-test dataset
- Check-in and check-out date pickers
- Validation for past check-ins, missing dates, same-day stays, and reversed date ranges
- Single-room selection with clear visual feedback
- Guest-count filtering based on room capacity
- Conflict detection against hardcoded existing bookings
- Disabled room selection with a clear `Booked` status
- Automatic night and total-price calculation
- Indian Rupee formatting with Indian digit grouping through `intl`
- Responsive desktop, tablet, and mobile layouts
- Accessible status messages for incomplete, invalid, and valid selections

## Technology

- Flutter and Dart
- Material 3 widgets with a custom Raintech-inspired theme
- `intl` for currency and date presentation
- `flutter_test` for unit and widget tests

No backend, database, authentication, payment processing, or booking persistence is used. Room data is stored locally as required by the exercise.

## Run locally

Install a current Flutter SDK and confirm that Flutter is available:

```bash
flutter doctor
```

From the project directory, install dependencies:

```bash
flutter pub get
```

Run the web application in Chrome:

```bash
flutter run -d chrome
```

The project can also run on another configured Flutter target:

```bash
flutter devices
flutter run -d <device-id>
```

## Quality checks

Run static analysis and the complete test suite:

```bash
flutter analyze
flutter test
```

Create a production web build:

```bash
flutter build web
```

The generated web application is written to `build/web`.

## Project structure

```text
lib/
├── data/       Hardcoded room and existing-booking datasets
├── models/     Room and booking domain models
├── screens/    Booking-page state and composition
├── services/   Validation, availability, and price calculations
├── theme/      Application colors and Material theme
├── utils/      Date and INR presentation formatters
└── widgets/    Reusable booking interface components

test/
├── data/       Sample-data tests
├── models/     Domain-model tests
├── services/   Date, night, and price calculation tests
├── utils/      Formatting tests
└── widget_test.dart
```

Business logic is kept outside the widgets so it can be tested without rendering the interface. The page owns only the current date and room selections.

## Booking rules and assumptions

- Check-in may be today or a future date, but not a past date.
- Check-out must be later than check-in.
- Check-out is exclusive: checking in on 15 September and checking out on 18 September is three nights.
- Night counts use calendar dates rather than elapsed hours, avoiding time-of-day and daylight-saving errors.
- Prices are stored as whole Rupees and formatted only at the presentation boundary.
- Selecting a different room immediately recalculates the total.
- Only rooms that can accommodate the selected number of guests are shown.
- Date ranges use check-out-exclusive overlap rules, so back-to-back bookings are allowed.
- Room R101 is booked from 15–18 January 2027, and R201 is booked from 20–23 January 2027. These ranges can be used to review the availability behaviour.

## Improvements with more time

- Load room inventory and bookings from an API instead of hardcoded data.
- Preserve the current booking draft when the page is refreshed.
- Add golden tests for visual regression and broader accessibility testing.
- Add localization support beyond English and INR.
- Introduce persisted bookings and an API only if the product scope later requires them.
