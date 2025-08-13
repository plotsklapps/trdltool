import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/phone_button.dart';

// Displays a modal bottom sheet for making MCN calls.
// This sheet contains a text field for the MCN number
// and a button to initiate the call.
void showMcnCallSheet({
  // The context from which the sheet is shown.
  required BuildContext context,
  // The role of the current user, e.g., 'LEERLING'.
  required String userRole,
  // The Firebase path to listen for button state changes.
  required String databasePath,
  // The controller for the MCN number text field.
  required TextEditingController mcnController,
  // The title displayed at the top of the sheet.
  required String title,
  // The hint text for the text field.
  required String hintText,
}) {
  showModalBottomSheet(
    showDragHandle: true,
    context: context,
    // Allows the sheet to resize when the keyboard appears.
    isScrollControlled: true,
    builder: (BuildContext context) {
      // StreamBuilder listens to real-time database changes.
      return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child(databasePath).onValue,
        builder: (context, snapshot) {
          Map<String, String> buttonStates = {};
          Map<String, String> buttonInitiators = {};
          Map<String, String?> buttonMcnNumbers = {};

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
                  buttonMcnNumbers[buttonName] = buttonData['mcnNumber'];
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
                  buttonMcnNumbers: buttonMcnNumbers,
                  databaseService: DatabaseService(),
                  onPressed: () {
                    final mcnNumber = mcnController.text;
                    // Only make the call if a number is entered.
                    if (mcnNumber.isNotEmpty) {
                      DatabaseService().saveButtonPress(
                        'MCN',
                        userRole,
                        'isCalling',
                        mcnNumber: mcnNumber,
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
