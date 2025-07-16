import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals_flutter.dart';

import 'database_service.dart';

class LeerlingScreen extends StatelessWidget {
  const LeerlingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
    // The leerling uses the sCodeLeerling signal to know which room to listen to.
    final String path = '$formattedDate/${sCodeLeerling.value}/buttons';

    return StreamBuilder<DatabaseEvent>(
      stream: database.child(path).onValue,
      builder: (context, snapshot) {
        Map<String, String> buttonStates = {};
        Map<String, String> buttonInitiators = {};

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
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

        return Scaffold(
          appBar: AppBar(
            title: Text('LEERLING ${sCodeLeerling.watch(context)}'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Builder(
                              builder: (context) {
                                final state =
                                    buttonStates['MKS ALARM'] ?? 'rest';
                                final initiator = buttonInitiators['MKS ALARM'];
                                Widget child;
                                Color? backgroundColor;
                                VoidCallback? onPressed;

                                // Logic for Leerling screen
                                switch (state) {
                                  case 'isCalling':
                                    if (initiator == 'OPLEIDER') {
                                      // Opleider is calling, Leerling can accept
                                      child = Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: LinearProgressIndicator(
                                              minHeight: 20,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.error,
                                                  ),
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.onError,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text('MKS ALARM'),
                                          ),
                                        ],
                                      );
                                      backgroundColor = Theme.of(
                                        context,
                                      ).colorScheme.error;
                                      onPressed = () {
                                        // Leerling accepts the call
                                        databaseService.saveButtonPress(
                                          'MKS ALARM',
                                          'LEERLING',
                                          'isActive',
                                        );
                                      };
                                    } else {
                                      // Leerling is the one calling
                                      child = LinearProgressIndicator(
                                        minHeight: 20,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        valueColor: AlwaysStoppedAnimation(
                                          Theme.of(context).colorScheme.error,
                                        ),
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.onError,
                                      );
                                      backgroundColor = Theme.of(
                                        context,
                                      ).colorScheme.error;
                                      onPressed = () {
                                        // Leerling cancels the call
                                        databaseService.saveButtonPress(
                                          'MKS ALARM',
                                          'LEERLING',
                                          'rest',
                                        );
                                      };
                                    }
                                    break;
                                  case 'isActive':
                                    child = Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onError,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'In gesprek',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onError,
                                          ),
                                        ),
                                      ],
                                    );
                                    backgroundColor = Theme.of(
                                      context,
                                    ).colorScheme.primary;
                                    onPressed = () {
                                      // Both can end the call
                                      databaseService.saveButtonPress(
                                        'MKS ALARM',
                                        'LEERLING',
                                        'rest',
                                      );
                                    };
                                    break;
                                  case 'rest':
                                  default:
                                    child = Text(
                                      'MKS ALARM',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onError,
                                      ),
                                    );
                                    backgroundColor = Theme.of(
                                      context,
                                    ).colorScheme.error;
                                    onPressed = () {
                                      // Leerling starts a call
                                      databaseService.saveButtonPress(
                                        'MKS ALARM',
                                        'LEERLING',
                                        'isCalling',
                                      );
                                    };
                                }

                                return FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: backgroundColor,
                                  ),
                                  onPressed: onPressed,
                                  child: child,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('MKS INFO'),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('AL'),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('OBI'),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('DVL'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('BuurTRDL'),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('Mdw Rangeren'),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('CRA'),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('Brugwachter'),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('MCN 3064'),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('ALGEMEEN'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('BEL MCN'),
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
