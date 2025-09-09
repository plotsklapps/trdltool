import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trdltool/services/database_service.dart';

// A button that handles different call states.
// It can show an idle, calling, or active call state.
class PhoneButton extends StatefulWidget {
  // The unique name of the button, e.g., 'MKS ALARM'.
  final String buttonName;
  // The role of the current user, e.g., 'LEERLING'.
  final String userRole;
  // Map with the current state of all buttons.
  final Map<String, String> buttonStates;
  // Map with the initiator for each call.
  final Map<String, String> buttonInitiators;
  // Map with the MCN number for a call, if any.
  final Map<String, String?> buttonMcnNumbers;
  // Instance of the database service for Firebase.
  final DatabaseService databaseService;
  // The base color of the button.
  final Color buttonColor;
  // The color of the label text.
  final Color labelColor;
  // The color of the progress indicator.
  final Color progressIndicatorColor;
  // Optional custom action when the button is pressed.
  final VoidCallback? onPressed;
  // Optional callback when a call ends.
  final VoidCallback? onCallEnded;
  // Optional label to override the default button name.
  final String? overrideLabel;

  const PhoneButton({
    super.key,
    required this.buttonName,
    required this.userRole,
    required this.buttonStates,
    required this.buttonInitiators,
    required this.buttonMcnNumbers,
    required this.databaseService,
    required this.buttonColor,
    required this.labelColor,
    required this.progressIndicatorColor,
    this.onPressed,
    this.onCallEnded,
    this.overrideLabel,
  });

  @override
  State<PhoneButton> createState() {
    return _PhoneButtonState();
  }
}

class _PhoneButtonState extends State<PhoneButton> {
  // Timer for the active call duration.
  Timer? _timer;
  // Seconds elapsed during an active call.
  int _secondsElapsed = 0;

  @override
  void didUpdateWidget(PhoneButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Get the new and old state for this button.
    final newState = widget.buttonStates[widget.buttonName] ?? 'rest';
    final oldState = oldWidget.buttonStates[widget.buttonName] ?? 'rest';

    // If the call just became active, start the timer.
    if (newState == 'isActive' && oldState != 'isActive') {
      _startTimer();
    } else if (newState != 'isActive') {
      // If the call is no longer active, stop the timer.
      _stopTimer();
      if (oldState == 'isActive' && widget.onCallEnded != null) {
        // Trigger the onCallEnded callback if provided.
        widget.onCallEnded!();
      }
    }
  }

  // Starts the call timer.
  void _startTimer() {
    // Reset the counter to 0.
    _secondsElapsed = 0;

    // Cancel any previous timer.
    _timer?.cancel();

    // Start a new periodic timer that fires every second.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Increment the counter and update the UI.
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  // Stops the call timer.
  void _stopTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
  }

  @override
  void dispose() {
    // Make sure to cancel the timer when the widget is removed.
    _timer?.cancel();
    super.dispose();
  }

  // Formats seconds into a mm:ss time string.
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final DateTime time = DateTime(0, 0, 0, 0, minutes, secs);
    return DateFormat('mm:ss').format(time);
  }

  @override
  Widget build(BuildContext context) {
    // Get the state and initiator for this specific button.
    final state = widget.buttonStates[widget.buttonName] ?? 'rest';
    final initiator = widget.buttonInitiators[widget.buttonName] ?? '';
    // Use overrideLabel if provided, otherwise buttonName.
    final String labelText = widget.overrideLabel ?? widget.buttonName;

    Widget child;
    Color? backgroundColor;
    VoidCallback? onPressed;

    // Determine the button's appearance and action based
    // on its current state.
    switch (state) {
      case 'isCalling':
        // The button is in the "calling" state.
        // Show a progress indicator.
        child = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              LinearProgressIndicator(
                minHeight: 32,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                valueColor: AlwaysStoppedAnimation(
                  widget.progressIndicatorColor,
                ),
                backgroundColor: widget.buttonColor,
              ),
              Text(labelText),
            ],
          ),
        );
        backgroundColor = widget.buttonColor;
        if (initiator == widget.userRole) {
          // If the user started the call, they can cancel it.
          onPressed = () {
            widget.databaseService.saveButtonPress(
              widget.buttonName,
              widget.userRole,
              'rest',
            );
          };
        } else {
          // If the user is being called, they can accept.
          onPressed = () {
            widget.databaseService.saveButtonPress(
              widget.buttonName,
              widget.userRole,
              'isActive',
              mcnNumber: widget.buttonMcnNumbers[widget.buttonName],
            );
          };
        }
        break;
      case 'isActive':
        // The call is active. Show the timer.
        child = Text(
          _formatTime(_secondsElapsed),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
        backgroundColor = Theme.of(context).colorScheme.secondary;
        // The user can end the call.
        onPressed = () {
          widget.databaseService.saveButtonPress(
            widget.buttonName,
            widget.userRole,
            'rest',
          );
        };
        break;
      case 'rest':
      default:
        // The button is in its default, idle state.
        child = Text(labelText, style: TextStyle(color: widget.labelColor));
        backgroundColor = widget.buttonColor;
        // Use the provided onPressed, or start a new call.
        onPressed =
            widget.onPressed ??
            () {
              widget.databaseService.saveButtonPress(
                widget.buttonName,
                widget.userRole,
                'isCalling',
              );
            };
    }

    return SizedBox(
      width: double.infinity,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        // InkWell provides the tap effect.
        child: InkWell(
          onTap: onPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}
