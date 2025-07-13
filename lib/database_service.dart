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
    // 1. Get a reference to the Firebase Realtime Database root.
    //    `FirebaseDatabase.instance` gets the singleton instance of the Firebase Database.
    //    `.ref()` gets a DatabaseReference to the root of your database.
    //    This 'database' object is now the entry point for all database operations (read/write).
    final database = FirebaseDatabase.instance.ref();

    // 2. Get the current date and time.
    //    `DateTime.now()` creates a DateTime object representing the exact moment
    //    this line of code is executed.
    final DateTime now = DateTime.now();

    // 3. Format the current date into a "yyyy-MM-dd" string.
    //    `DateFormat('yyyy-MM-dd')` creates a formatter object from the 'intl' package.
    //    `.format(now)` uses this formatter to convert the 'now' DateTime object
    //    into a string like "2023-11-15". This formatted date will be used as part
    //    of the database path, allowing codes to be organized by the day they were created.
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // 4. Explicitly define the data structure to be saved.
    //    A Map named `codeData` is created. This map will hold the information
    //    associated with the generated code.
    //    It's typed as `Map<String, dynamic>` which means its keys are Strings,
    //    and its values can be of any type (dynamic).
    final Map<String, dynamic> codeData = {
      // 4a. Add a 'createdAt' field to the map.
      //     The value of 'createdAt' is the current date and time converted to an
      //     ISO 8601 string format (e.g., "2023-11-15T10:00:00.000Z").
      //     This standardized format is useful for storing and later parsing timestamps.
      'createdAt': now.toIso8601String(),
      // You could add other fields here if needed, e.g., 'isValid': true
      // For example, if you wanted to store if the code is initially valid,
      // you could add: 'isValid': true
    };

    // 5. Write the `codeData` to the Firebase Realtime Database.
    //    `database.child('$formattedDate/${sCodeOpleider.value}')` constructs the specific
    //    path in the database where the data will be stored.
    //    - `database.child(...)` navigates to a child node.
    //    - `'$formattedDate'` uses the formatted date string (e.g., "2023-11-15").
    //    - `'/${sCodeOpleider.value}'` appends the actual code (e.g., "ABCDE") from
    //      the `sCodeOpleider` signal.
    //    So, if formattedDate is "2023-11-15" and sCodeOpleider.value is "ABCDE",
    //    the path will be "/2023-11-15/ABCDE".
    //
    //    `.set(codeData)` writes (or overwrites if it already exists) the `codeData` map
    //    at this specified path. Firebase will store this map as a JSON object.
    database.child('$formattedDate/${sCodeOpleider.value}').set(codeData);
  }

  Future<bool> validateCodeFromDatabase(String enteredCode) async {
    // 1. Get a reference to the Firebase Realtime Database.
    final database = FirebaseDatabase.instance.ref();

    // 2. Get the current time. This will be used for two purposes:
    //    a. To construct the database path (codes are stored under the current date).
    //    b. To compare with the code's creation time to check its validity.
    final DateTime currentTime = DateTime.now();

    // 3. Format the current date as "yyyy-MM-dd".
    //    This ensures we're looking for the code under the correct date node in the database.
    //    Example: If today is November 15th, 2023, formattedDate will be "2023-11-15".
    final String formattedDate = DateFormat('yyyy-MM-dd').format(currentTime);

    try {
      // 4. Attempt to fetch the data from the database ONCE.
      //    The path is constructed using the formattedDate and the enteredCode.
      //    Example: If formattedDate is "2023-11-15" and enteredCode is "XN4GP",
      //    it tries to read from "/2023-11-15/XN4GP".
      //    .once() returns a DatabaseEvent which contains the snapshot of the data.
      final DatabaseEvent event = await database
          .child('$formattedDate/$enteredCode')
          .once();

      // 5. Get the DataSnapshot from the event.
      //    The snapshot contains the actual data (if it exists) at the specified path.
      final DataSnapshot codeSnapshot = event.snapshot;

      // 6. Check if the code actually exists in the database and has a value.
      //    codeSnapshot.exists is true if there's data at that path.
      //    codeSnapshot.value != null is an additional check that there's some content.
      if (codeSnapshot.exists && codeSnapshot.value != null) {
        // 7. Convert the snapshot's value to a Dart Map.
        //    Firebase data often comes as a Map<Object?, Object?> or similar.
        //    Map<String, dynamic>.from() is a safe way to convert it to the expected
        //    Map<String, dynamic> structure. If the conversion is not possible
        //    (e.g., if the data is not a map), this could throw an error,
        //    but it's less likely for the structure we're saving.
        final Map<String, dynamic> codeData = Map<String, dynamic>.from(
          codeSnapshot.value
              as Map, // We cast to `Map` first, then `from` handles the rest.
        );

        // 8. Retrieve the 'createdAt' timestamp string from the codeData map.
        //    We expect 'createdAt' to be a String (ISO 8601 format).
        final String? createdAtString = codeData['createdAt'] as String?;

        // 9. Check if 'createdAtString' was actually found and is not null.
        if (createdAtString != null) {
          try {
            // 10. Parse the 'createdAtString' into a DateTime object.
            //     This converts the stored string timestamp back into a usable DateTime.
            final DateTime createdAt = DateTime.parse(createdAtString);

            // 11. Validate the code's age.
            //     Calculate the difference between the current time and the code's creation time.
            //     If the difference is 5 minutes or less, the code is considered valid.
            return currentTime.difference(createdAt).inMinutes <= 5;
          } catch (e) {
            // 12. If parsing the 'createdAtString' fails (e.g., it's not a valid date format),
            //     print an error and treat the code as invalid.
            print('Error parsing createdAt date: $e');
            return false;
          }
        }
      }
    } catch (e) {
      // 13. If any error occurs during the database fetch operation itself
      //     (e.g., network issue, permissions problem), print the error
      //     and treat the code as invalid.
      print('Error fetching code from database: $e');
      return false;
    }

    // 14. If the code does not exist (step 6 failed), or if 'createdAt' was missing (step 9 failed),
    //     or if any other unhandled case led here, the code is considered invalid.
    return false;
  }

  Future<void> initializeSession(String sessionCode) async {
    final database = FirebaseDatabase.instance.ref();
    if (sessionCode.isEmpty) {
      print('Session code cannot be empty. Aborting...');
      return;
    }
    try {
      await database
          .child('sessions/$sessionCode/buttons')
          .set(<String, dynamic>{});
      print('Session initialized with code: $sessionCode');
    } catch (e) {
      print('Error initializing session: $e');
    }
  }

  Future<void> updateButtonState(
    String sessionCode,
    String buttonId,
    String state,
  ) async {
    final database = FirebaseDatabase.instance.ref();

    await database.child('sessions/$sessionCode/buttons/$buttonId').update({
      'state': state,
    });
  }

  Future<void> startTimer(String sessionCode, String buttonId) async {
    final database = FirebaseDatabase.instance.ref();

    final ref = database.child('sessions/$sessionCode/buttons/$buttonId');
    await ref.update({'state': 'timer', 'timer': 0});

    for (int i = 1; i <= 60; i++) {
      await Future.delayed(const Duration(seconds: 1));
      await ref.update({'timer': i});
    }
  }

  Stream<Map<String, dynamic>> listenButtonState(String sessionCode) {
    final database = FirebaseDatabase.instance.ref();

    return database.child('sessions/$sessionCode/buttons').onValue.map((event) {
      return Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }
}
