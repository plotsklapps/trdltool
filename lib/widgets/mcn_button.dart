import 'package:flutter/material.dart';
import 'package:trdltool/services/database_service.dart';

import 'phone_button.dart';

class McnButton extends StatelessWidget {
  final String userRole;
  final Map<String, String> buttonStates;
  final Map<String, String> buttonInitiators;
  final Map<String, String?> buttonDetails;
  final DatabaseService databaseService;
  final VoidCallback onShowMcnCallSheet;

  const McnButton({
    super.key,
    required this.userRole,
    required this.buttonStates,
    required this.buttonInitiators,
    required this.buttonDetails,
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
        overrideLabel: buttonDetails['MCN'],
        userRole: userRole,
        buttonStates: buttonStates,
        buttonInitiators: buttonInitiators,
        buttonDetails: buttonDetails,
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
