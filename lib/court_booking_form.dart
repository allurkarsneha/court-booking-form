import 'package:flutter/material.dart';

enum CourtType { tennis, basketball, pickleball }

class AppUser {
  final int id;
  final String firstName;
  final String lastName;

  AppUser({required this.id, required this.firstName, required this.lastName});

  String get fullName => "$firstName $lastName";

  @override
  String toString() {
    return fullName;
  }
}

class CourtBookingForm extends StatefulWidget {
  final Map<String, dynamic> initialValues;

  const CourtBookingForm({super.key, required this.initialValues});

  @override
  State<CourtBookingForm> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
