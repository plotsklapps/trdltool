import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/phone_button.dart';

void showMcnCallSheet({
  required BuildContext context,
  required String userRole,
  required String databasePath,
  required TextEditingController mcnController,
  required String title,
  required String hintText,
}) {
  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      // Use Streambuilder to listen for changes in the database.
      return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child(databasePath).onValue,
        builder: (context, snapshot) {
          Map<String, String> buttonStates = {};
          Map<String, String> buttonInitiators = {};
          Map<String, String?> buttonDetails = {};

          // Check if the snapshot has valid data.
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.snapshot.value != null) {
            // Parse the data from the snapshot.
            final Map<dynamic, dynamic> data =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            data.forEach((key, value) {
              if (value is Map) {
                final buttonData = Map<String, dynamic>.from(value);
                final buttonName = buttonData['buttonName'];
                if (buttonName != null) {
                  // Populate the maps with button data.
                  buttonStates[buttonName] = buttonData['state'] ?? 'rest';
                  buttonInitiators[buttonName] = buttonData['initiator'] ?? '';
                  buttonDetails[buttonName] = buttonData['details'];
                }
              }
            });
          }

          // Padding to avoid the keyboard.
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title),
                const Divider(),
                const SizedBox(height: 8),
                // Text field for entering the MCN number.
                TextField(
                  controller: mcnController,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: hintText,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 16),
                // The phone button to initiate the call.
                PhoneButton(
                  buttonName: 'MCN',
                  userRole: userRole,
                  buttonStates: buttonStates,
                  buttonInitiators: buttonInitiators,
                  buttonDetails: buttonDetails,
                  databaseService: DatabaseService(),
                  onPressed: () {
                    final details = mcnController.text;
                    // Only make the call if a number is entered.
                    if (details.isNotEmpty) {
                      DatabaseService().saveButtonPress(
                        'MCN',
                        userRole,
                        'isCalling',
                        details: details,
                      );
                    }
                  },
                  onCallEnded: () {
                    // Close the sheet when the call ends.
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  buttonColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.onPrimary,
                  progressIndicatorColor: Theme.of(
                    context,
                  ).colorScheme.onPrimary,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
