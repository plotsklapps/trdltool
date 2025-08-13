import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:signals/signals.dart';
import 'package:trdltool/services/timer_service.dart';

final Signal<String> sCodeOpleider = Signal<String>(
  'ABC00',
  debugLabel: 'sCodeOpleider',
);
final Signal<String> sCodeLeerling = Signal<String>(
  'ABC00',
  debugLabel: 'sCodeLeering',
);

class DatabaseService {
  // 1. Create a static, private instance of the class.
  static final DatabaseService _instance = DatabaseService._internal();

  // 2. Create a factory constructor that returns the private instance.
  factory DatabaseService() {
    return _instance;
  }

  // 3. Create a private, named constructor.
  DatabaseService._internal();

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

    // Initial button states
    final List<String> buttonNames = [
      'MKS ALARM',
      'MKS INFO',
      'AL',
      'OBI',
      'DVL',
      'BuurTRDL',
      'Mdw Rangeren',
      'CRA',
      'Brugwachter',
      'MCN 3064',
      'ALARM',
      'ALGEMEEN',
      'BEL MCN',
    ];
    final Map<String, dynamic> buttons = {
      for (var name in buttonNames)
        name: {
          'buttonName': name,
          'state': 'rest',
          'initiator': null,
          'timestamp': null,
          'mcnNumber': null,
        },
    };

    _database.child('$formattedDate/${sCodeOpleider.value}').set({
      ...codeData,
      'buttons': buttons,
    });
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

  void saveButtonPress(
    String buttonName,
    String caller,
    String state, {
    String? mcnNumber,
  }) async {
    Logger().i(
      'Button pressed: $buttonName, MCN: $mcnNumber, Caller: $caller, New '
      'state: $state,',
    );
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String formattedTime = DateFormat('HH:mm:ss').format(now);

    final Map<String, dynamic> buttonData = {
      'buttonName': buttonName,
      'state': state, // 'rest', 'calling', 'called', 'active'
      'initiator': caller, // 'opleider' or 'leerling'
      'timestamp': formattedTime, // always set for simplicity
      'mcnNumber': mcnNumber, // only for 'MCN' button
    };

    // Determine the correct code to use based on the caller's role.
    final String code = (caller == 'LEERLING')
        ? sCodeLeerling.value
        : sCodeOpleider.value;

    // Use buttonName as the key so both parties update the same button
    // entry under the correct code.
    await _database
        .child('$formattedDate/$code/buttons/$buttonName')
        .set(buttonData);
  }
}
