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
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child(databasePath).onValue,
        builder: (context, snapshot) {
          Map<String, String> buttonStates = {};
          Map<String, String> buttonInitiators = {};
          Map<String, String?> buttonMcnNumbers = {};

          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.snapshot.value != null) {
            final Map<dynamic, dynamic> data =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            data.forEach((key, value) {
              if (value is Map) {
                final buttonData = Map<String, dynamic>.from(value);
                final buttonName = buttonData['buttonName'];
                if (buttonName != null) {
                  buttonStates[buttonName] = buttonData['state'] ?? 'rest';
                  buttonInitiators[buttonName] = buttonData['initiator'] ?? '';
                  buttonMcnNumbers[buttonName] = buttonData['mcnNumber'];
                }
              }
            });
          }
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
                PhoneButton(
                  buttonName: 'MCN',
                  userRole: userRole,
                  buttonStates: buttonStates,
                  buttonInitiators: buttonInitiators,
                  buttonMcnNumbers: buttonMcnNumbers,
                  databaseService: DatabaseService(),
                  onPressed: () {
                    final mcnNumber = mcnController.text;
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
