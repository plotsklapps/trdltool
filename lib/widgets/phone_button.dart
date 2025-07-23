import 'package:flutter/material.dart';
import 'package:trdltool/database_service.dart';

class PhoneButton extends StatelessWidget {
  final String buttonName;
  final String userRole;
  final Map<String, String> buttonStates;
  final Map<String, String> buttonInitiators;
  final DatabaseService databaseService;

  const PhoneButton({
    super.key,
    required this.buttonName,
    required this.userRole,
    required this.buttonStates,
    required this.buttonInitiators,
    required this.databaseService,
  });

  @override
  Widget build(BuildContext context) {
    final state = buttonStates[buttonName] ?? 'rest';
    final initiator = buttonInitiators[buttonName] ?? '';

    Widget child;
    Color? backgroundColor;
    VoidCallback? onPressed;

    switch (state) {
      case 'isCalling':
        if (initiator == userRole) {
          // Current user is the caller
          child = Stack(
            alignment: Alignment.center,
            children: [
              LinearProgressIndicator(
                minHeight: 20,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.error,
                ),
                backgroundColor: Theme.of(context).colorScheme.onError,
              ),
              Text(buttonName),
            ],
          );
          backgroundColor = Theme.of(context).colorScheme.error;
          onPressed = () {
            // Cancel the call
            databaseService.saveButtonPress(buttonName, userRole, 'rest');
          };
        } else {
          // Current user is the callee
          child = Text(
            'Je wordt gebeld!',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          );
          backgroundColor = Theme.of(context).colorScheme.errorContainer;
          onPressed = () {
            // Accept call
            databaseService.saveButtonPress(buttonName, userRole, 'isActive');
          };
        }
        break;
      case 'isActive':
        child = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.call, color: Theme.of(context).colorScheme.onError),
            const SizedBox(width: 8),
            Text(
              userRole == 'OPLEIDER' ? 'Actief' : 'In gesprek',
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
          ],
        );
        backgroundColor = Theme.of(context).colorScheme.primary;
        onPressed = () {
          // End call
          databaseService.saveButtonPress(buttonName, userRole, 'rest');
        };
        break;
      case 'rest':
      default:
        child = Text(
          buttonName,
          style: TextStyle(color: Theme.of(context).colorScheme.onError),
        );
        backgroundColor = Theme.of(context).colorScheme.error;
        onPressed = () {
          databaseService.saveButtonPress(buttonName, userRole, 'isCalling');
        };
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(backgroundColor: backgroundColor),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
