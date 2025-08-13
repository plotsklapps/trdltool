import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trdltool/services/database_service.dart';

class PhoneButton extends StatefulWidget {
  final String buttonName;
  final String userRole;
  final Map<String, String> buttonStates;
  final Map<String, String> buttonInitiators;
  final DatabaseService databaseService;
  final Color buttonColor;
  final Color labelColor;
  final Color progressIndicatorColor;
  final VoidCallback? onPressed;
  final VoidCallback? onCallEnded;

  const PhoneButton({
    super.key,
    required this.buttonName,
    required this.userRole,
    required this.buttonStates,
    required this.buttonInitiators,
    required this.databaseService,
    required this.buttonColor,
    required this.labelColor,
    required this.progressIndicatorColor,
    this.onPressed,
    this.onCallEnded,
  });

  @override
  State<PhoneButton> createState() {
    return _PhoneButtonState();
  }
}

class _PhoneButtonState extends State<PhoneButton> {
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void didUpdateWidget(PhoneButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newState = widget.buttonStates[widget.buttonName] ?? 'rest';
    final oldState = oldWidget.buttonStates[widget.buttonName] ?? 'rest';

    if (newState == 'isActive' && oldState != 'isActive') {
      _startTimer();
    } else if (newState != 'isActive') {
      _stopTimer();
      if (oldState == 'isActive' && widget.onCallEnded != null) {
        widget.onCallEnded!();
      }
    }
  }

  void _startTimer() {
    // Reset the counter.
    _secondsElapsed = 0;

    // Kill a possible previous timer.
    _timer?.cancel();

    // Start the timer.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  void _stopTimer() {
    // Kill the timer and reset the counter.
    _timer?.cancel();
    _secondsElapsed = 0;
  }

  @override
  void dispose() {
    // Kill the timer on dispose.
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final DateTime time = DateTime(0, 0, 0, 0, minutes, secs);
    return DateFormat('mm:ss').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.buttonStates[widget.buttonName] ?? 'rest';
    final initiator = widget.buttonInitiators[widget.buttonName] ?? '';

    Widget child;
    Color? backgroundColor;
    VoidCallback? onPressed;

    switch (state) {
      case 'isCalling':
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
              Text(widget.buttonName),
            ],
          ),
        );
        backgroundColor = widget.buttonColor;
        if (initiator == widget.userRole) {
          // Current user is making the call..
          onPressed = () {
            // Cancel the call
            widget.databaseService.saveButtonPress(
              widget.buttonName,
              widget.userRole,
              'rest',
            );
          };
        } else {
          // Current user is being called.
          onPressed = () {
            // Accept the call
            widget.databaseService.saveButtonPress(
              widget.buttonName,
              widget.userRole,
              'isActive',
            );
          };
        }
        break;
      case 'isActive':
        child = Text(
          _formatTime(_secondsElapsed),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
        backgroundColor = Theme.of(context).colorScheme.secondary;
        onPressed = () {
          // End call
          widget.databaseService.saveButtonPress(
            widget.buttonName,
            widget.userRole,
            'rest',
          );
        };
        break;
      case 'rest':
      default:
        child = Text(
          widget.buttonName,
          style: TextStyle(color: widget.labelColor),
        );
        backgroundColor = widget.buttonColor;
        onPressed = widget.onPressed ??
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
        child: InkWell(
          onTap: onPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}
