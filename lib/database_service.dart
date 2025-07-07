import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals.dart';
import 'package:trdltool/timer_service.dart';

final Signal<String> sCodeOpleider = Signal<String>('ABC00');

class DatabaseService {
  final TimerService _timerService = TimerService();

  void generateCode() {
    // Characters to use in the code.
    const characters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    // Generate a random code of length 5.
    final newCode = List.generate(5, (index) {
      return characters[Random().nextInt(characters.length)];
    }).join();

    // Update the Signal.
    sCodeOpleider.value = newCode;

    // Start the timer.
    _timerService.startTimer(() {
      generateCode(); // Auto-refresh by generating a new code.
    });
  }

  void saveCodeToDatabase() {
    // Create instance of FirebaseDatabase and get the current date.
    final database = FirebaseDatabase.instance.ref();
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Save the code to the database under the current date and code.
    database.child('$formattedDate/${sCodeOpleider.value}').set({
      'createdAt': now.toIso8601String(),
    });
  }

  Future<bool> validateCodeFromDatabase(String enteredCode) async {
    // Create instance of FirebaseDatabase and check if the code exists.
    final database = FirebaseDatabase.instance.ref();
    final codeSnapshot = await database.child('codes/$enteredCode').get();

    if (codeSnapshot.exists) {
      final data = codeSnapshot.value as Map;
      final createdAt = DateTime.parse(data['createdAt']);
      final now = DateTime.now();

      // Check if the code is not older than 5 minutes.
      return now.difference(createdAt).inMinutes <= 5;
    }

    // Code does not exist
    return false;
  }
}
