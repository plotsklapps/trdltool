import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/database_service.dart';
import 'package:trdltool/opleider_screen.dart';
import 'package:trdltool/timer_service.dart';

class NieuweRuimteScreen extends StatelessWidget {
  const NieuweRuimteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final TimerService timerService = TimerService();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(sTimer.watch(context)),
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
                const SizedBox(width: 36),
                IconButton(
                  onPressed: () {
                    databaseService.generateCode();
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              sCodeOpleider.watch(context),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    databaseService.saveCodeToDatabase();

                    timerService.cancelTimer();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const OpleiderScreen();
                        },
                      ),
                    );
                  },
                  child: const Text('Creëer Nieuwe Ruimte'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final DateTime time = DateTime(0, 0, 0, 0, minutes, secs);
    return DateFormat('mm:ss').format(time);
  }
}
