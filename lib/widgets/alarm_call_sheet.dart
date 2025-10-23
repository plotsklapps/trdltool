import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/phone_button.dart';

Future<void> showAlarmCallSheet({
  required BuildContext context,
  required String userRole,
  required String databasePath,
  required TextEditingController mcnController,
  required String title,
  required String hintText,
}) async {
  Future<void> handleAlarmAreaPressed(String area) async {
    await DatabaseService().saveButtonPress(
      'ALARM',
      userRole,
      'isCalling',
      details: area,
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  await showModalBottomSheet<void>(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      // UI for the student with area selection.
      if (userRole == 'LEERLING') {
        // Padding to avoid the keyboard.
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Alarm Oproep'),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  // Invisible placeholder to match the middle row's structure
                  Expanded(child: Container()),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PhoneButton(
                      buttonName: 'NOORD',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('NOORD');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Invisible placeholder
                  Expanded(child: Container()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: PhoneButton(
                      buttonName: 'WEST',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('WEST');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PhoneButton(
                      buttonName: 'CENTRUM',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('CENTRUM');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PhoneButton(
                      buttonName: 'OOST',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('OOST');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  // Invisible placeholder to match the middle row's structure
                  Expanded(child: Container()),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PhoneButton(
                      buttonName: 'ZUID',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('ZUID');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Invisible placeholder
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
        );
      } else {
        // UI for the teacher, similar to mcn_call_sheet.
        // Use Streambuilder to listen for changes in the database.
        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref().child(databasePath).onValue,
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                final Map<String, String> buttonStates = <String, String>{};
                final Map<String, String> buttonInitiators = <String, String>{};
                final Map<String, String?> buttonDetails = <String, String?>{};

                // Check if the snapshot has valid data.
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.snapshot.value != null) {
                  // Parse the data from the snapshot.
                  (snapshot.data!.snapshot.value! as Map<dynamic, dynamic>)
                      .forEach((dynamic key, dynamic value) {
                        if (value is Map) {
                          final Map<String, dynamic> buttonData =
                              Map<String, dynamic>.from(value);
                          final String? buttonName =
                              buttonData['buttonName'] as String?;
                          if (buttonName != null) {
                            // Populate the maps with button data.
                            buttonStates[buttonName] =
                                (buttonData['state'] as String?) ?? 'rest';
                            buttonInitiators[buttonName] =
                                (buttonData['initiator'] as String?) ?? '';
                            buttonDetails[buttonName] =
                                buttonData['details'] as String?;
                          }
                        }
                      });
                }

                // Padding to avoid the keyboard.
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    left: 16,
                    right: 16,
                    top: 16,
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
                      PhoneButton(
                        buttonName: 'ALARM',
                        overrideLabel: 'ALARMEER',
                        userRole: userRole,
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        buttonDetails: buttonDetails,
                        databaseService: DatabaseService(),
                        onPressed: () async {
                          final String details = mcnController.text;
                          // Only make the call if a number is entered.
                          if (details.isNotEmpty) {
                            await DatabaseService().saveButtonPress(
                              'ALARM',
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
      }
    },
  );
}
