import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trdltool/services/database_service.dart';

// A button that handles different call states.
// It can show an idle, calling, or active call state.
class PhoneButton extends StatefulWidget {
  const PhoneButton({
    required this.buttonName,
    required this.userRole,
    required this.buttonStates,
    required this.buttonInitiators,
    required this.buttonDetails,
    required this.databaseService,
    required this.buttonColor,
    required this.labelColor,
    required this.progressIndicatorColor,
    this.onPressed,
    this.onCallEnded,
    this.overrideLabel,
    super.key,
  });
  // Unique name of the button: 'MKS ALARM'.
  final String buttonName;
  // Role of current user: 'LEERLING'.
  final String userRole;
  // Map with current state of all buttons.
  final Map<String, String> buttonStates;
  // Map with initiator for each call.
  final Map<String, String> buttonInitiators;
  // Optional map with details for a call.
  final Map<String, String?> buttonDetails;
  // Instance of database service for Firebase.
  final DatabaseService databaseService;
  // Color of button.
  final Color buttonColor;
  // Color of label text.
  final Color labelColor;
  // Color of progress indicator.
  final Color progressIndicatorColor;
  // Optional custom action on buttonpress.
  final VoidCallback? onPressed;
  // Optional callback when call ends.
  final VoidCallback? onCallEnded;
  // Optional label to override default button name.
  final String? overrideLabel;

  @override
  State<PhoneButton> createState() {
    return _PhoneButtonState();
  }
}

class _PhoneButtonState extends State<PhoneButton> {
  // Timer for active call duration.
  Timer? _timer;
  // Seconds elapsed during an active call.
  int _secondsElapsed = 0;

  @override
  void didUpdateWidget(PhoneButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Get new and old state for this button.
    final String newState = widget.buttonStates[widget.buttonName] ?? 'rest';
    final String oldState = oldWidget.buttonStates[widget.buttonName] ?? 'rest';

    // If call just became active, start timer.
    if (newState == 'isActive' && oldState != 'isActive') {
      _startTimer();
    } else if (newState != 'isActive') {
      // If call is no longer active, stop timer.
      _stopTimer();
      if (oldState == 'isActive' && widget.onCallEnded != null) {
        // Trigger onCallEnded callback if provided.
        widget.onCallEnded!();
      }
    }
  }

  // Start call timer.
  void _startTimer() {
    // Reset counter to 0.
    _secondsElapsed = 0;

    // Cancel any previous timer.
    _timer?.cancel();

    // Start new periodic timer.
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        // Increment counter and update UI.
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  // Stop call timer.
  void _stopTimer() {
    _timer?.cancel();

    // Reset counter to 0.
    _secondsElapsed = 0;
  }

  @override
  void dispose() {
    // Kill timer.
    _timer?.cancel();
    super.dispose();
  }

  // Format seconds into mm:ss.
  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    final DateTime time = DateTime(0, 0, 0, 0, minutes, secs);
    return DateFormat('mm:ss').format(time);
  }

  @override
  Widget build(BuildContext context) {
    // Get state and initiator for this specific button.
    final String state = widget.buttonStates[widget.buttonName] ?? 'rest';
    final String initiator = widget.buttonInitiators[widget.buttonName] ?? '';

    // Optionally fetch details.
    final String? details = widget.buttonDetails[widget.buttonName];

    // Use overrideLabel if provided, otherwise buttonName.
    // If details are available, join the Strings.
    String labelText = widget.overrideLabel ?? widget.buttonName;
    if (details != null && details.isNotEmpty) {
      labelText = '$labelText $details';
    }

    Widget child;
    Color? backgroundColor;
    VoidCallback? onPressed;

    // Determine button's appearance and action based
    // on its current state.
    switch (state) {
      case 'isCalling':
        // The button is in the "calling" state.
        // Show a progress indicator.
        child = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              LinearProgressIndicator(
                minHeight: 32,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                valueColor: AlwaysStoppedAnimation<Color?>(
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
          // If user started the call, they can cancel.
          onPressed = () async {
            await widget.databaseService.saveButtonPress(
              widget.buttonName,
              widget.userRole,
              'rest',
            );
          };
        } else {
          // If user is being called, they can accept.
          onPressed = () async {
            await widget.databaseService.saveButtonPress(
              widget.buttonName,
              widget.userRole,
              'isActive',
              details: widget.buttonDetails[widget.buttonName],
            );
          };
        }
      case 'isActive':
        // Call is now active. Show timer.
        child = Text(
          _formatTime(_secondsElapsed),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
        backgroundColor = Theme.of(context).colorScheme.secondary;
        // User can end call.
        onPressed = () async {
          await widget.databaseService.saveButtonPress(
            widget.buttonName,
            widget.userRole,
            'rest',
          );
        };
      case 'rest':
      default:
        // Button is default state.
        child = Text(labelText, style: TextStyle(color: widget.labelColor));
        backgroundColor = widget.buttonColor;
        // Use provided onPressed, or start a new call.
        onPressed =
            widget.onPressed ??
            () async {
              await widget.databaseService.saveButtonPress(
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
