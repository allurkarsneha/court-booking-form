import 'package:flutter/material.dart';

enum CourtType { tennis, badminton, pickleball }

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

  late TextEditingController _playerNameController;
  late TextEditingController _courtRatingController;

  late CourtType _selectedCourtType;
  late bool _needsEquipment;
  late bool _needsCoach;
  late bool _makePublic;
  late AppUser? _selectedPartner;

  @override
  void initState() {
    super.initState();

    _playerNameController = TextEditingController(
      text: widget.initialValues['playerName']?.toString() ?? '',
    );

    _courtRatingController = TextEditingController(
      text: widget.initialValues['courtRating']?.toString() ?? '',
    );

    _selectedCourtType = widget.initialValues['courtType'] as CourtType;
    _needsEquipment = widget.initialValues['needsEquipment'] as bool;
    _needsCoach = widget.initialValues['needsCoach'] as bool;
    _makePublic = widget.initialValues['makePublic'] as bool;
    _selectedPartner = widget.initialValues['partner'] as AppUser;
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _courtRatingController.dispose();
    super.dispose();
  }

  String? _validatePlayerName(String? value) {
    final playerName = value?.trim() ?? '';

    if (playerName.isEmpty) {
      return 'Please enter a player name';
    }

    if (playerName.length < 5) {
      return 'Minimum 5 characters required';
    }

    if (playerName.length > 20) {
      return 'Maximum 20 characters allowed';
    }

    return null;
  }

  String? _validateCourtRating(String? value) {
    final ratingText = value?.trim() ?? '';

    if (ratingText.isEmpty) {
      return 'Please enter court rating';
    }

    final rating = double.tryParse(ratingText);

    if (rating == null) {
      return 'Court rating must be a valid number';
    }

    if (rating <= 3.00) {
      return 'Court rating must be above 3.00';
    }

    if (rating >= 10.00) {
      return 'Court rating must be below 10.00';
    }

    return null;
  }

  String? _validatePartner(AppUser? value) {
    if (value == null) {
      return 'Please select a partner';
    }

    return null;
  }

  String _courtTypeText(CourtType courtType) {
    switch (courtType) {
      case CourtType.tennis:
        return 'Tennis';
      case CourtType.badminton:
        return 'Badminton';
      case CourtType.pickleball:
        return 'Pickleball';
    }
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
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final Map<String, dynamic> bookingValues = {
      'playerName': _playerNameController.text.trim(),
      'courtRating': double.parse(_courtRatingController.text.trim()),
      'courtType': _selectedCourtType,
      'courtTypeText': _courtTypeText(_selectedCourtType),
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

  Widget _buildPlayerNameField() {
    return TextFormField(
      controller: _playerNameController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Player Name',
        hintText: 'Enter 5 to 20 characters',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: _validatePlayerName,
    );
  }

  Widget _buildCourtRatingField() {
    return TextFormField(
      controller: _courtRatingController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: 'Court Rating',
        hintText: 'Enter value above 3.00 and below 10.00',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.star),
      ),
      validator: _validateCourtRating,
    );
  }

  Widget _buildSportTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sport Type',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        RadioGroup<CourtType>(
          groupValue: _selectedCourtType,
          onChanged: (value) {
            setState(() {
              _selectedCourtType = value!;
            });
          },
          child: Column(
            children: [
              RadioListTile<CourtType>(
                title: const Text('Tennis'),
                value: CourtType.tennis,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<CourtType>(
                title: const Text('Badminton'),
                value: CourtType.badminton,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<CourtType>(
                title: const Text('Pickleball'),
                value: CourtType.pickleball,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Options',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Court Booking Form'),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

                      _buildPlayerNameField(),

                      const SizedBox(height: 18),

                      _buildCourtRatingField(),

                      const SizedBox(height: 24),

                      _buildSportTypeSection(),

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
                        'Selected sport: ${_courtTypeText(_selectedCourtType)}',
                        style: const TextStyle(fontSize: 13),
                      ),

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
      ),
    );
  }
}