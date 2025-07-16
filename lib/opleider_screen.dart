import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals_flutter.dart';

import 'database_service.dart';

class OpleiderScreen extends StatelessWidget {
  const OpleiderScreen({super.key});

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

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final Map<dynamic, dynamic> data =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          data.forEach((key, value) {
            if (value is Map) {
              final buttonData = Map<String, dynamic>.from(value);
              buttonStates[buttonData['buttonName']] =
                  buttonData['state'] ?? 'rest';
            }
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('OPLEIDER ${sCodeOpleider.watch(context)}'),
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
                          SizedBox(
                            width: double.infinity,
                            child: Builder(
                              builder: (context) {
                                final state =
                                    buttonStates['MKS ALARM'] ?? 'rest';
                                Widget child;
                                Color? backgroundColor;
                                VoidCallback? onPressed;
                                switch (state) {
                                  case 'isCalling':
                                    child = LinearProgressIndicator(
                                      minHeight: 12,
                                      borderRadius: BorderRadius.circular(12),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.onError,
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    );
                                    backgroundColor = Theme.of(
                                      context,
                                    ).colorScheme.error;
                                    onPressed = () {
                                      databaseService.saveButtonPress(
                                        'MKS ALARM',
                                        'OPLEIDER',
                                        'rest',
                                      );
                                    };
                                    break;
                                  case 'isCalled':
                                    child = Text(
                                      'Je wordt gebeld!',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onError,
                                      ),
                                    );
                                    backgroundColor = Theme.of(
                                      context,
                                    ).colorScheme.errorContainer;
                                    onPressed = () {
                                      // Accept call logic here
                                    };
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
                                          'Actief',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onError,
                                          ),
                                        ),
                                        // Optionally add a timer widget here
                                      ],
                                    );
                                    backgroundColor = Theme.of(
                                      context,
                                    ).colorScheme.primary;
                                    onPressed = () {
                                      // End call logic here
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
                                      databaseService.saveButtonPress(
                                        'MKS ALARM',
                                        'OPLEIDER',
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
                          child: Text('ALGEMEEN'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('BEL MCN'),
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
