import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals.dart';
import 'package:trdltool/timer_service.dart';

final Signal<String> sCodeOpleider = Signal<String>('ABC00');
final Signal<String> sCodeLeerling = Signal<String>('ABC00');

class DatabaseService {
  final _database = FirebaseDatabase.instance.ref();
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
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final Map<String, dynamic> codeData = {'createdAt': now.toIso8601String()};
    _database.child('$formattedDate/${sCodeOpleider.value}').set(codeData);
  }

  Future<bool> validateCodeFromDatabase(String enteredCode) async {
    final DateTime currentTime = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(currentTime);

    try {
      final DatabaseEvent event = await _database
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

  void saveButtonPress(String buttonName, String caller, String state) async {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String formattedTime = DateFormat('HH:mm:ss').format(now);

    final Map<String, dynamic> buttonData = {
      'buttonName': buttonName,
      'state': state, // 'rest', 'calling', 'called', 'active'
      'initiator': caller, // 'opleider' or 'leerling'
      'timestamp': formattedTime, // always set for simplicity
    };

    // Use buttonName as the key so both parties update the same button entry
    await _database
        .child('$formattedDate/${sCodeOpleider.value}/buttons/$buttonName')
        .set(buttonData);
  }
}
