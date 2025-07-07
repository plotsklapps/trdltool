import 'package:flutter/material.dart';
import 'package:trdltool/database_service.dart';
import 'package:trdltool/nieuweruimte_screen.dart';

import 'bestaanderuimte_screen.dart';

class RolKeuzeScreen extends StatelessWidget {
  const RolKeuzeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ik ben...'),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: () {
                    databaseService.generateCode();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const NieuweRuimteScreen();
                        },
                      ),
                    );
                  },
                  child: Text('Opleider'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const BestaandeRuimteScreen();
                        },
                      ),
                    );
                  },
                  child: Text('Leerling'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
