import 'package:flutter/material.dart';

enum CourtType {
  tennis,
  badminton,
  pickleball,
}

class AppUser {
  final int id;
  final String firstName;
  final String lastName;

  AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  @override
  String toString() => fullName;
}

class CourtBookingForm extends StatefulWidget {
  final List<AppUser> users;
  final Map<String, dynamic> initialValues;

  const CourtBookingForm({
    super.key,
    required this.users,
    required this.initialValues,
  });

  @override
  State<CourtBookingForm> createState() => _CourtBookingFormState();
}

class _CourtBookingFormState extends State<CourtBookingForm> {
  final _formKey = GlobalKey<FormState>();

  late bool _needsEquipment;
  late bool _needsCoach;
  late bool _makePublic;
  late AppUser? _selectedPartner;

  @override
  void initState() {
    super.initState();

    _needsEquipment = widget.initialValues['needsEquipment'] as bool;
    _needsCoach = widget.initialValues['needsCoach'] as bool;
    _makePublic = widget.initialValues['makePublic'] as bool;
    _selectedPartner = widget.initialValues['partner'] as AppUser;
  }

  String? _validatePartner(AppUser? value) {
    if (value == null) {
      return 'Please select a partner';
    }

    return null;
  }

  Map<String, dynamic> getBookingOptionsData() {
    return {
      'needsEquipment': _needsEquipment,
      'needsCoach': _needsCoach,
      'makePublic': _makePublic,
      'partner': _selectedPartner,
    };
  }

  void _saveBooking() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final Map<String, dynamic> bookingValues = {
      'playerName': widget.initialValues['playerName'],
      'courtRating': widget.initialValues['courtRating'],
      'courtType': widget.initialValues['courtType'],
      ...getBookingOptionsData(),
    };

    debugPrint('Saved Court Booking:');
    debugPrint(bookingValues.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking saved successfully'),
      ),
    );
  }

  Widget _buildBookingOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Options',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        CheckboxListTile(
          title: const Text('Need equipment'),
          value: _needsEquipment,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {
            setState(() {
              _needsEquipment = value ?? false;
            });
          },
        ),

        CheckboxListTile(
          title: const Text('Need coach'),
          value: _needsCoach,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {
            setState(() {
              _needsCoach = value ?? false;
            });
          },
        ),

        CheckboxListTile(
          title: const Text('Make match public'),
          value: _makePublic,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {
            setState(() {
              _makePublic = value ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPartnerDropdown() {
    return DropdownButtonFormField<AppUser>(
      initialValue: _selectedPartner,
      decoration: const InputDecoration(
        labelText: 'Select Partner',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.group),
      ),
      items: widget.users.map((user) {
        return DropdownMenuItem<AppUser>(
          value: user,
          child: Text(user.fullName),
        );
      }).toList(),
      validator: _validatePartner,
      onChanged: (value) {
        setState(() {
          _selectedPartner = value;
        });
      },
    );
  }

  Widget _buildPlaceholder(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Court Booking Form'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Central Court Booking',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Enter booking details and choose a playing partner.',
                      style: TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 24),

                    _buildPlaceholder(
                      'Player Name, Court Rating, and Sport Type fields will be added here.',
                    ),

                    const SizedBox(height: 24),

                    _buildBookingOptionsSection(),

                    const SizedBox(height: 18),

                    _buildPartnerDropdown(),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveBooking,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Booking'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Selected partner: ${_selectedPartner?.fullName ?? 'None'}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}