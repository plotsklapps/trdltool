import 'package:flutter/material.dart';
import 'package:trdltool/services/database_service.dart';

import 'phone_button.dart';

// A dynamic button for MCN calls that changes its
// appearance and behavior based on the call state.
// It can show an active call button or a passive one.
class McnButton extends StatelessWidget {
  // Role of the current user, e.g., 'LEERLING'.
  final String userRole;

  // Map with the current state of all buttons.
  // e.g., 'isCalling', 'isActive'.
  final Map<String, String> buttonStates;

  // Map with the initiator for each call.
  final Map<String, String> buttonInitiators;

  // Map with the MCN number for a call, if any.
  final Map<String, String?> buttonMcnNumbers;

  // Instance of the database service.
  // Used for Firebase communication.
  final DatabaseService databaseService;

  // Callback to show the MCN call sheet.
  final VoidCallback onShowMcnCallSheet;

  const McnButton({
    super.key,
    required this.userRole,
    required this.buttonStates,
    required this.buttonInitiators,
    required this.buttonMcnNumbers,
    required this.databaseService,
    required this.onShowMcnCallSheet,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current state and initiator for the MCN call.
    final mcnCallState = buttonStates['MCN'] ?? 'rest';
    final mcnCallInitiator = buttonInitiators['MCN'] ?? '';

    // Determine the role of the other user.
    final String oppositeRole = userRole == 'LEERLING'
        ? 'OPLEIDER'
        : 'LEERLING';

    // If there is an incoming call from the other user,
    // or the call is active, show the active PhoneButton.
    if ((mcnCallState == 'isCalling' && mcnCallInitiator == oppositeRole) ||
        mcnCallState == 'isActive') {
      return PhoneButton(
        buttonName: 'MCN',
        overrideLabel: buttonMcnNumbers['MCN'],
        userRole: userRole,
        buttonStates: buttonStates,
        buttonInitiators: buttonInitiators,
        buttonMcnNumbers: buttonMcnNumbers,
        databaseService: databaseService,
        buttonColor: Theme.of(context).colorScheme.primary,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        progressIndicatorColor: Theme.of(context).colorScheme.onPrimary,
      );
    } else {
      // Otherwise, show a passive button to start a new call.
      return SizedBox(
        width: double.infinity,
        height: 80,
        child: ElevatedButton(
          onPressed: onShowMcnCallSheet,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          child: Text(
            'MCN',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
    }
  }
}
