import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/widgets/phone_button.dart';

import 'database_service.dart';

class OpleiderScreen extends StatefulWidget {
  const OpleiderScreen({super.key});

  @override
  State<OpleiderScreen> createState() {
    return _OpleiderScreenState();
  }
}

class _OpleiderScreenState extends State<OpleiderScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Map<String, String> _previousButtonStates = {};

  @override
  void initState() {
    super.initState();
    // Pre-load the phone sounds for faster playback.
    _audioPlayer.setAsset('assets/mp3/alarmtoon.mp3');
    // Set the release mode to loop so the sound plays continuously.
    _audioPlayer.setLoopMode(LoopMode.one);
  }

  @override
  void dispose() {
    // Stop and release the audio player's resources when the screen is disposed.
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleButtonStateChanges(
    Map<String, String> newButtonStates,
    Map<String, String> newButtonInitiators,
  ) {
    const String alarmButton = 'MKS ALARM';
    const String userRole = 'OPLEIDER';

    final String? newState = newButtonStates[alarmButton];
    final String? previousState = _previousButtonStates[alarmButton];
    final String? initiator = newButtonInitiators[alarmButton];

    // Check if the state has changed to 'isCalling' AND if this user is not the one who started the call.
    if (newState == 'isCalling' &&
        previousState != 'isCalling' &&
        initiator != userRole) {
      // This user is being called. Start playing the alarm sound.
      _audioPlayer.play();
    }
    // Check if the state has changed away from 'isCalling'
    else if (newState != 'isCalling' && previousState == 'isCalling') {
      // The call was answered or cancelled. Stop the alarm sound.
      _audioPlayer.stop();
    }

    // Update the previous states for the next comparison.
    _previousButtonStates = Map.from(newButtonStates);
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
    final String path = '$formattedDate/${sCodeOpleider.value}/buttons';

    return StreamBuilder<DatabaseEvent>(
      stream: database.child(path).onValue,
      builder: (context, snapshot) {
        Map<String, String> buttonStates = {};
        Map<String, String> buttonInitiators = {};

        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.snapshot.value != null) {
          final Map<dynamic, dynamic> data =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          data.forEach((key, value) {
            if (value is Map) {
              final buttonData = Map<String, dynamic>.from(value);
              buttonStates[buttonData['buttonName']] =
                  buttonData['state'] ?? 'rest';
              buttonInitiators[buttonData['buttonName']] =
                  buttonData['initiator'] ?? '';
            }
          });
          // After parsing the new data, check for the state change.
          _handleButtonStateChanges(buttonStates, buttonInitiators);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'OPLEIDER GRI ${sCodeOpleider.watch(context)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          PhoneButton(
                            buttonName: 'MKS ALARM',
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                            buttonColor: Theme.of(context).colorScheme.primary,
                            labelColor: Theme.of(context).colorScheme.onPrimary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'MKS INFO',
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'AL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'OBI',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'DVL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          PhoneButton(
                            buttonName: 'Tunnel Operator',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8.0),
                          PhoneButton(
                            buttonName: 'BuurTRDL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'Mdw Rangeren',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'Brugwachter',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'MCN 3064',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            databaseService: databaseService,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          child: Text(
                            'ALARM',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onError,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('ALGEMEEN'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('BEL MCN'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
