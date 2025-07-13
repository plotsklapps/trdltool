import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import 'bestaanderuimte_screen.dart';
import 'database_service.dart';

class LeerlingScreen extends StatelessWidget {
  const LeerlingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final String sessionCode = sCodeLeerling.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('GRI ${sCodeLeerling.watch(context)}'),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: databaseService.listenButtonState(sessionCode),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final buttons = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 16,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed:
                                  buttons['MKS_ALARM']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'MKS_ALARM',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['MKS_ALARM']?['state'] == 'timer'
                                    ? '${buttons['MKS_ALARM']?['timer'] ~/ 60}:${(buttons['MKS_ALARM']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'MKS ALARM',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  buttons['MKS_INFO']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'MKS_INFO',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['MKS_INFO']?['state'] == 'timer'
                                    ? '${buttons['MKS_INFO']?['timer'] ~/ 60}:${(buttons['MKS_INFO']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'MKS INFO',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: buttons['AL']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'AL',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['AL']?['state'] == 'timer'
                                    ? '${buttons['AL']?['timer'] ~/ 60}:${(buttons['AL']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'AL',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: buttons['AL']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'AL',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['OBI']?['state'] == 'timer'
                                    ? '${buttons['OBI']?['timer'] ~/ 60}:${(buttons['OBI']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'OBI',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: buttons['DVL']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'DVL',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['DVL']?['state'] == 'timer'
                                    ? '${buttons['DVL']?['timer'] ~/ 60}:${(buttons['DVL']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'DVL',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        spacing: 16,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed:
                                  buttons['BUUR_TRDL']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'BUUR_TRDL',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['BUUR_TRDL']?['state'] == 'timer'
                                    ? '${buttons['BUUR_TRDL']?['timer'] ~/ 60}:${(buttons['BUUR_TRDL']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'BuurTRDL',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed:
                                  buttons['MDW_RANG']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'MDW_RANG',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['MDW_RANG']?['state'] == 'timer'
                                    ? '${buttons['MDW_RANG']?['timer'] ~/ 60}:${(buttons['MDW_RANG']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'Mdw Rangeren',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: buttons['CRA']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'CRA',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['CRA']?['state'] == 'timer'
                                    ? '${buttons['CRA']?['timer'] ~/ 60}:${(buttons['CRA']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'CRA',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: buttons['BRUG']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'BRUG',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['BRUG']?['state'] == 'timer'
                                    ? '${buttons['BRUG']?['timer'] ~/ 60}:${(buttons['BRUG']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'Brugwachter',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed:
                                  buttons['MCN_####']?['state'] == 'pressed'
                                  ? () {
                                      databaseService.startTimer(
                                        sessionCode,
                                        'MCN_####',
                                      );
                                    }
                                  : null,
                              child: Text(
                                buttons['MCN_####']?['state'] == 'timer'
                                    ? '${buttons['MCN_####']?['timer'] ~/ 60}:${(buttons['MCN_####']?['timer'] % 60).toString().padLeft(2, '0')}'
                                    : 'MCN 3064',
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
          );
        },
      ),
    );
  }
}
