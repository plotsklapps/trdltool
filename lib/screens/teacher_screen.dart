import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/alarm_button.dart';
import 'package:trdltool/widgets/alarm_call_sheet.dart';
import 'package:trdltool/widgets/general_button.dart';
import 'package:trdltool/widgets/general_call_sheet.dart';
import 'package:trdltool/widgets/mcn_button.dart';
import 'package:trdltool/widgets/mcn_call_sheet.dart';
import 'package:trdltool/widgets/phone_button.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() {
    return _TeacherScreenState();
  }
}

class _TeacherScreenState extends State<TeacherScreen> {
  final AudioPlayer _alarmtoonPlayer = AudioPlayer();
  final AudioPlayer _beltoonPlayer = AudioPlayer();
  Map<String, String> _previousButtonStates = <String, String>{};
  final TextEditingController _mcnController = TextEditingController();
  final TextEditingController _alarmMcnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-load the phone sounds for faster playback.
    _alarmtoonPlayer.setAsset('assets/mp3/alarmtoon.mp3');
    _beltoonPlayer.setAsset('assets/mp3/beltoon.mp3');
    // Set the release mode to loop so the sound plays continuously.
    _alarmtoonPlayer.setLoopMode(LoopMode.one);
    _beltoonPlayer.setLoopMode(LoopMode.one);
  }

  @override
  void dispose() {
    // Stop and release the audio player's resources when the screen is disposed.
    _alarmtoonPlayer.dispose();
    _beltoonPlayer.dispose();
    _mcnController.dispose();
    _alarmMcnController.dispose();
    super.dispose();
  }

  void _handleButtonStateChanges(
    Map<String, String> newButtonStates,
    Map<String, String> newButtonInitiators,
  ) {
    const String userRole = 'OPLEIDER';

    // Iterate over all buttons to check for state changes.
    newButtonStates.forEach((String buttonName, String newState) {
      final String? previousState = _previousButtonStates[buttonName];
      final String? initiator = newButtonInitiators[buttonName];

      // A button is being called, and this user is not the one who started it.
      if (newState == 'isCalling' &&
          previousState != 'isCalling' &&
          initiator != userRole) {
        // Decide which sound to play based on the button name.
        if (buttonName == 'MKS ALARM' || buttonName == 'ALARM') {
          _alarmtoonPlayer.play();
        } else {
          _beltoonPlayer.play();
        }
      }
      // A call was answered or cancelled.
      else if (newState != 'isCalling' && previousState == 'isCalling') {
        // Stop the corresponding player.
        if (buttonName == 'MKS ALARM' || buttonName == 'ALARM') {
          _alarmtoonPlayer.stop();
        } else {
          _beltoonPlayer.stop();
        }
      }
    });

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
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        final Map<String, String> buttonStates = <String, String>{};
        final Map<String, String> buttonInitiators = <String, String>{};
        final Map<String, String?> buttonDetails = <String, String?>{};

        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.snapshot.value != null) {
          (snapshot.data!.snapshot.value! as Map<dynamic, dynamic>).forEach((
            dynamic key,
            dynamic value,
          ) {
            if (value is Map) {
              final Map<String, dynamic> buttonData = Map<String, dynamic>.from(
                value,
              );
              final String? buttonName = buttonData['buttonName'] as String?;
              if (buttonName != null) {
                buttonStates[buttonName] =
                    (buttonData['state'] as String?) ?? 'rest';
                buttonInitiators[buttonName] =
                    (buttonData['initiator'] as String?) ?? '';
                buttonDetails[buttonName] = buttonData['details'] as String?;
              }
            }
          });
          // After parsing the new data, check for the state change.
          _handleButtonStateChanges(buttonStates, buttonInitiators);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'OPLEIDER GRI ${sCodeOpleider.watch(context)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          PhoneButton(
                            buttonName: 'MKS ALARM',
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
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
                            buttonDetails: buttonDetails,
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
                            buttonDetails: buttonDetails,
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
                            buttonDetails: buttonDetails,
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
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: <Widget>[
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
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
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
                            buttonDetails: buttonDetails,
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
                            buttonDetails: buttonDetails,
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
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          McnButton(
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                            onShowMcnCallSheet: () async {
                              await showMcnCallSheet(
                                context: context,
                                userRole: 'OPLEIDER',
                                databasePath: path,
                                mcnController: _mcnController,
                                title: 'Bel als MCN van...',
                                hintText: 'TREIN',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AlarmButton(
                        userRole: 'OPLEIDER',
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        buttonDetails: buttonDetails,
                        databaseService: databaseService,
                        onPressed: () async {
                          await showAlarmCallSheet(
                            context: context,
                            userRole: 'OPLEIDER',
                            databasePath: path,
                            mcnController: _alarmMcnController,
                            title: 'Alarmeer als MCN van...',
                            hintText: 'TREIN',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GeneralButton(
                        userRole: 'OPLEIDER',
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        buttonDetails: buttonDetails,
                        databaseService: databaseService,
                        onPressed: () async {
                          await showGeneralCallSheet(
                            context: context,
                            userRole: 'OPLEIDER',
                            databasePath: path,
                            mcnController: _mcnController,
                            title: 'Algemene Oproep',
                            hintText: 'TREIN',
                          );
                        },
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
