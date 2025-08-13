import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/phone_button.dart';

class OpleiderScreen extends StatefulWidget {
  const OpleiderScreen({super.key});

  @override
  State<OpleiderScreen> createState() {
    return _OpleiderScreenState();
  }
}

class _OpleiderScreenState extends State<OpleiderScreen> {
  final AudioPlayer _alarmtoonPlayer = AudioPlayer();
  final AudioPlayer _beltoonPlayer = AudioPlayer();
  Map<String, String> _previousButtonStates = {};
  final TextEditingController _mcnController = TextEditingController();

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
    super.dispose();
  }

  void _handleButtonStateChanges(
    Map<String, String> newButtonStates,
    Map<String, String> newButtonInitiators,
  ) {
    const String userRole = 'OPLEIDER';

    // Iterate over all buttons to check for state changes.
    newButtonStates.forEach((buttonName, newState) {
      final previousState = _previousButtonStates[buttonName];
      final initiator = newButtonInitiators[buttonName];

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

  void _showMcnCallSheet() {
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
    final String path = '$formattedDate/${sCodeOpleider.value}/buttons';

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
            }
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Bel als MCN van...'),
                      Divider(),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _mcnController,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Treinnummer',
                          counterText: '',
                        ),
                        onChanged: (value) {
                          setState(() {}); // Rebuild to update the PhoneButton
                        },
                      ),
                      const SizedBox(height: 16),
                      PhoneButton(
                        buttonName: 'MCN',
                        userRole: 'OPLEIDER',
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        databaseService: DatabaseService(),
                        onPressed: () {
                          final mcnNumber = _mcnController.text;
                          if (mcnNumber.isNotEmpty) {
                            DatabaseService().saveButtonPress(
                              'MCN',
                              'OPLEIDER',
                              'isCalling',
                              mcnNumber: mcnNumber,
                            );
                          }
                        },
                        onCallEnded: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        buttonColor: Theme.of(context).colorScheme.primary,
                        labelColor: Theme.of(context).colorScheme.onPrimary,
                        progressIndicatorColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
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
                          SizedBox(
                            width: double.infinity,
                            height: 80,
                            child: ElevatedButton(
                              onPressed: () {
                                _showMcnCallSheet();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                'MCN 3064',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
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
