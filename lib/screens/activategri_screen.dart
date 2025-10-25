import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trdltool/screens/student_screen.dart';
import 'package:trdltool/services/database_service.dart';

class ActivateGRIScreen extends StatelessWidget {
  const ActivateGRIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final TextEditingController codeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nieuwe GRI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: codeController,
                onChanged: (String value) {
                  sCodeLeerling.value = value.trim();
                },
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                ],
                decoration: const InputDecoration(hintText: 'Voer code in'),
              ),
            ),
            const SizedBox(height: 36),
            InkWell(
              onTap: () async {
                // Check if the code is valid.
                final bool isValid = await databaseService
                    .validateCodeFromDatabase(
                      sCodeLeerling.value,
                    );

                // Navigate to GedeeldeRuimteScreen if valid.
                if (context.mounted && isValid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const StudentScreen();
                      },
                    ),
                  );
                } else {
                  debugPrint('Invalid code entered: ${sCodeLeerling.value}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ongeldige code, probeer het opnieuw.'),
                    ),
                  );
                }
              },
              child: SizedBox(
                width: 160,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // InkWell provides the tap effect.
                  child: Center(
                    child: Text(
                      'Activeer GRI',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
