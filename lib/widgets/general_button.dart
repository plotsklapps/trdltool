import 'package:flutter/material.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/phone_button.dart';

class GeneralButton extends StatelessWidget {
  final String userRole;
  final Map<String, String> buttonStates;
  final Map<String, String> buttonInitiators;
  final Map<String, String?> buttonDetails;
  final DatabaseService databaseService;
  final VoidCallback onPressed;

  const GeneralButton({
    super.key,
    required this.userRole,
    required this.buttonStates,
    required this.buttonInitiators,
    required this.buttonDetails,
    required this.databaseService,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PhoneButton(
      buttonName: 'ALGEMEEN',
      userRole: userRole,
      buttonStates: buttonStates,
      buttonInitiators: buttonInitiators,
      buttonDetails: buttonDetails,
      databaseService: databaseService,
      onPressed: onPressed,
      buttonColor: Theme.of(context).colorScheme.primary,
      labelColor: Theme.of(context).colorScheme.onPrimary,
      progressIndicatorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
