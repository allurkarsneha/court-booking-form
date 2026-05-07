# Court Booking Form

A Flutter form input demo for a court booking screen. The app lets users enter booking details, choose a sport type, select booking options, pick a partner, and save the final values into a `Map<String, dynamic>`.

## Topic

Form Input in Flutter

## Features

- Initial values loaded from a `Map<String, dynamic>`
- `TextEditingController` used for text fields and disposed properly
- Player name validation: 5-20 characters
- Court rating validation: numeric, above 3.00 and below 10.00
- Radio buttons for sport type: Tennis, Badminton, Pickleball
- Three checkboxes: Need equipment, Need coach, Make match public
- Dropdown with 10 `AppUser` objects
- Selected partner is stored as an `AppUser` object
- Final form values are saved into a `Map<String, dynamic>` and printed to console

## Files

lib/
- main.dart
- court_booking_form.dart

## How to Run

flutter pub get
flutter run

## Example Console Output

Saved Court Booking:
{playerName: John Smith, courtRating: 8.5, courtType: CourtType.tennis, courtTypeText: Tennis, needsEquipment: true, needsCoach: false, makePublic: true, partner: Monica Geller}
