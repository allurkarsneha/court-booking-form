import 'package:flutter/material.dart';
import 'court_booking_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final List<AppUser> users = [
    AppUser(id: 1, firstName: 'Monica', lastName: 'Geller'),
    AppUser(id: 2, firstName: 'Rachel', lastName: 'Green'),
    AppUser(id: 3, firstName: 'Chandler', lastName: 'Bing'),
    AppUser(id: 4, firstName: 'Ross', lastName: 'Geller'),
    AppUser(id: 5, firstName: 'Joey', lastName: 'Tribbiani'),
    AppUser(id: 6, firstName: 'Phoebe', lastName: 'Buffay'),
    AppUser(id: 7, firstName: 'Mike', lastName: 'Hannigan'),
    AppUser(id: 8, firstName: 'Janice', lastName: 'Litman-Goralnik'),
    AppUser(id: 9, firstName: 'Regina', lastName: 'Phalange'),
    AppUser(id: 10, firstName: 'Gunther', lastName: 'Central Perk'),
  ];  //This creates 10 AppUser objects. These users are used in the Select Partner dropdown.

  static final Map<String, dynamic> initialBookingValues = {
    'playerName': 'John Smith',
    'courtRating': 8.5,
    'courtType': CourtType.tennis,
    'needsEquipment': true,
    'needsCoach': false,
    'makePublic': true,
    'partner': users[0],
  };  //This map provides the default values when the form first opens.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Court Booking Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E4B)),
        useMaterial3: true,
      ),
      home: CourtBookingForm(
        users: users,
        initialValues: initialBookingValues,   //main.dart sends the user list and initial values map to the form screen.
      ),
    );
  }
}