import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/database_service.dart';

class OpleiderScreen extends StatelessWidget {
  const OpleiderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final String sessionCode = sCodeOpleider.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('GRI ${sCodeOpleider.watch(context)}'),
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
                    spacing: 16,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'MKS_ALARM',
                              'pressed',
                            );
                          },
                          child: Text(
                            'MKS ALARM',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onError,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'MKS_INFO',
                              'pressed',
                            );
                          },
                          child: const Text('MKS INFO'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'AL',
                              'pressed',
                            );
                          },
                          child: const Text('AL'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'OBI',
                              'pressed',
                            );
                          },
                          child: const Text('OBI'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'DVL',
                              'pressed',
                            );
                          },
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
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'BUUR_TRDL',
                              'pressed',
                            );
                          },
                          child: const Text('BuurTRDL'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'MDW_RANG',
                              'pressed',
                            );
                          },
                          child: const Text('Mdw Rangeren'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'CRA',
                              'pressed',
                            );
                          },
                          child: const Text('CRA'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'BRUG',
                              'pressed',
                            );
                          },
                          child: const Text('Brugwachter'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            databaseService.updateButtonState(
                              sessionCode,
                              'MCN_####',
                              'pressed',
                            );
                          },
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
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
                    child: Text('ALGEMEEN'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('BEL MCN'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
