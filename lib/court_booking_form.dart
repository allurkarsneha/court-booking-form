import 'package:flutter/material.dart';

/*
  ENUM SECTION

  CourtType: defines possible sport/court choices for the booking form.
  Enums limit the possible values to a fixed list, which is safer than using
  plain strings since strings can be misspelled.

  In this form, the user can choose from:
  - tennis
  - badminton
  - pickleball 
*/
enum CourtType { tennis, badminton, pickleball }

/*
  USER MODEL SECTION

  AppUser represents a single user/player object. The dropdown uses a list of 
  AppUser objects, and displays the user's first and last name using the fullName
  getter. 

  Each user has an:
  - id: a unique identfier for the user
  - firstName: the user's first name
  - lastName: the user's last name
*/
class AppUser {
  final int id;
  final String firstName;
  final String lastName;

  AppUser({required this.id, required this.firstName, required this.lastName});

  String get fullName => '$firstName $lastName';

  @override
  String toString() => fullName;
}

/*
  STATEFUL WIDGET SECTION 

  CourtBookingForm is a StatefulWidget because the form values can change while 
  the app is running. 

  This widget receives:
  - users: a list of AppUser objects for the dropdown
  - initialValues: a Map<String, dynamic> containing the initial form values

  The initialValues map allows the form to start with existing data, which is 
  helpful for editing existing court bookings.
*/
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
  /*
    FORM KEY SECTION 

    _formKey is used to control and validate the whole form. When the Save 
    Booking button is pressed, this key lets us call:

    _formKey.currentState!.validate()

    which checks every field in the form that has a validator.
  */
  final _formKey = GlobalKey<FormState>();

  /*
    STATE VARIABLES SECTION 

    These variables store the current values of the form. 

    TextEditingController is used for text fields so we can:
    - set initial text values
    - read the user's typed input
    - clear or modify text if needed

    The checkbox values are booleans, each checkbox is either selected or not selected.

    _selectedParter stores the selected AppUser object from the dropdown.
  */
  late TextEditingController _playerNameController;
  late TextEditingController _courtRatingController;

  late CourtType _selectedCourtType;
  late bool _needsEquipment;
  late bool _needsCoach;
  late bool _makePublic;
  late AppUser? _selectedPartner;

  /*
    INITSTATE SECTION 

    initState() runs one time when the widget is first created.

    This is where the form loads its initial values from the Map<String, dynamic>
    passed into the widget.

    The player name and court rating are placed into TextEditingControllers.
    The checkbox values and dropdown value are copied into state variables.
  */
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

  /*
    DISPOSE SECTION

    dispose() runs when this widget is removed from the screen.

    TextEditingControllers use system resources, so they should be disposed of 
    when the form closes to prevent memory leaks.
  */
  @override
  void dispose() {
    _playerNameController.dispose();
    _courtRatingController.dispose();
    super.dispose();
  }

  /*
    PLAYER NAME VALIDATION SECTION 

    This method validates the Player Name text field.

    Text field requirements:
    - the field cannot be empty
    - the name must be at least 5 characters and no more than 20 characters

    Returning a string shows an error message.
    Returning null means the input is valid.
  */
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

  /*
    COURT RATING VALIDATION SECTION

    This method validates the Court Rating text field.

    Validation requirements:
    - the field cannot be empty
    - the value must be numeric
    - the value must be above 3.00 and below 10.00

    double.tryParse() safely converts the text into a double.
    If the conversion fails, it returns null instead of crashing the app.

    Returning a string displays an error message.
    Returning null means the input is valid.
  */
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

  /*
    COURT TYPE TEXT CONVERSION SECTION

    This helper method converts a CourtType enum value into a readable string.

    Example:
    - CourtType.tennis -> "Tennis"
    - CourtType.badminton -> "Badminton"

    This is helpful for:
    - displaying enum values in the UI
    - printing readable values to the console
    - storing cleaner text values in the booking map
  */
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

  /*
    SAVE BOOKING SECTION - update

    This method runs when the Save Booking button is pressed.

    It first validates the form - if any field is invalid, the method stops.
    
    If the form is valid, it creates a Map<String, dynamic> called bookingValues.
    The map stores:
    - playerName from the TextEditingController
    - courtRating from the initial values
    - courtType from the initial values
    - checkbox values
    - selected partner object

    It then prints the map to the console and shows a Snackbar.
  */
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Booking saved successfully')));
  }

  /*
    PLAYER NAME FIELD UI SECTION 

    This method builds the Player Name TextFormField.

    TextFormField is used because it works with Flutter's Form widget and 
    supports validation. 

    The controller connects this text field to _playerNameController.
    The validator connects it to _validatePlayerName().
  */
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

  /*
    COURT RATING FIELD UI SECTION

    This method builds the Court Rating TextFormField.

    Features:
    - uses TextEditingController to manage the field value
    - uses a numeric keyboard with decimal support
    - validates numeric input using _validateCourtRating()

    The keyboardType helps mobile devices show a number keypad, improving the 
    user experience for numeric input.
  */
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

  /*
    SPORT TYPE RADIO BUTTON SECTION

    This method builds the Sport Type selection area using radio buttons.

    The radio buttons use the CourtType enum as their value type.

    Only one radio button can be selected at a time because they share:
    - the same groupValue
    - the same RadioGroup

    When the user selects a different sport type:
    - setState() updates _selectedCourtType
    - the UI rebuilds automatically

    This section demonstrates enum-based radio button input.
  */
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

  /*
    DROPDOWN SECTION 

    This method builds the partner dropdown. 

    The dropdown uses AppUser as its type: DropdownButtonFormField<AppUser>

    This means the selected value is the full AppUser object, not just the user's 
    name as a string. The dropdown displays user.fullName, but stores the actual
    AppUser.
  */
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

  /*
    BUILD METHOD SECTION

    build() creates the visible UI for the entire screen.

    Main layout structure:
    - Scaffold provides the page structure
    - AppBar displays the screen title
    - GestureDetector dismisses the keyboard when tapping outside fields
    - SafeArea prevents overlap with system UI
    - SingleChildScrollView enables scrolling on smaller screens
    - Card visually groups the form content
    - Form enables validation for all input fields
    - Column arranges widgets vertically

    The form contains:
    - text fields
    - radio buttons
    - checkboxes
    - dropdown menu
    - save button

    Pressing the Save Booking button calls _saveBooking().
  */
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
