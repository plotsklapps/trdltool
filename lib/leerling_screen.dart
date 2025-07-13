import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import 'database_service.dart';

class LeerlingScreen extends StatelessWidget {
  const LeerlingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final String sessionCode = sCodeOpleider.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('GRI ${sCodeOpleider.watch(context)}'),
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
                                  ? () => databaseService.startTimer(
                                      sessionCode,
                                      'MKS_ALARM',
                                    )
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
                                  ? () => databaseService.startTimer(
                                      sessionCode,
                                      'MKS_INFO',
                                    )
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
                              onPressed: () {},
                              child: const Text('AL'),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('OBI'),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('DVL'),
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
                              onPressed: () {},
                              child: const Text('BuurTRDL'),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('Mdw Rangeren'),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('CRA'),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('Brugwachter'),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('MCN 3064'),
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
                      child: ElevatedButton(
                        onPressed: buttons['ALARM']?['state'] == 'pressed'
                            ? () => databaseService.startTimer(
                                sessionCode,
                                'ALARM',
                              )
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              buttons['ALARM']?['state'] == 'pressed'
                              ? Colors.green
                              : Theme.of(context).colorScheme.error,
                        ),
                        child: Text(
                          buttons['ALARM']?['state'] == 'timer'
                              ? '${buttons['ALARM']?['timer'] ~/ 60}:${(buttons['ALARM']?['timer'] % 60).toString().padLeft(2, '0')}'
                              : 'ALARM',
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
