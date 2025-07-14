import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals.dart';
import 'package:trdltool/timer_service.dart';

final Signal<String> sCodeOpleider = Signal<String>('ABC00');
final Signal<String> sCodeLeerling = Signal<String>('ABC00');

class DatabaseService {
  final TimerService _timerService = TimerService();

  void generateCode() {
    const characters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final newCode = List.generate(5, (index) {
      return characters[Random().nextInt(characters.length)];
    }).join();
    sCodeOpleider.value = newCode;
    _timerService.startTimer(() {
      generateCode();
    });
  }

  void saveCodeToDatabase() {
    final database = FirebaseDatabase.instance.ref();
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final Map<String, dynamic> codeData = {'createdAt': now.toIso8601String()};
    database.child('$formattedDate/${sCodeOpleider.value}').set(codeData);
  }

  Future<bool> validateCodeFromDatabase(String enteredCode) async {
    final database = FirebaseDatabase.instance.ref();
    final DateTime currentTime = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(currentTime);

    try {
      final DatabaseEvent event = await database
          .child('$formattedDate/$enteredCode')
          .once();
      final DataSnapshot codeSnapshot = event.snapshot;

      if (codeSnapshot.exists && codeSnapshot.value != null) {
        final Map<String, dynamic> codeData = Map<String, dynamic>.from(
          codeSnapshot.value as Map,
        );
        final String? createdAtString = codeData['createdAt'] as String?;

        if (createdAtString != null) {
          try {
            final DateTime createdAt = DateTime.parse(createdAtString);
            return currentTime.difference(createdAt).inMinutes <= 5;
          } catch (e) {
            print('Error parsing createdAt date: $e');
            return false;
          }
        }
      }
    } catch (e) {
      print('Error fetching code from database: $e');
      return false;
    }
    return false;
  }
}
