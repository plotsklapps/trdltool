import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trdltool/screens/leerling_screen.dart';
import 'package:trdltool/services/database_service.dart';

class ActivateGRIScreen extends StatelessWidget {
  const ActivateGRIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final TextEditingController codeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                controller: codeController,
                onChanged: (value) {
                  sCodeLeerling.value = value.trim();
                },
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[A-Z0-9]")),
                ],
                decoration: const InputDecoration(hintText: 'Voer code in'),
              ),
            ),
            const SizedBox(height: 36),
            FilledButton(
              onPressed: () async {
                // Check if the code is valid.
                final isValid = await databaseService.validateCodeFromDatabase(
                  sCodeLeerling.value,
                );

                // Navigate to GedeeldeRuimteScreen if valid.
                if (context.mounted && isValid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LeerlingScreen();
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
              child: const Text('Activeer GRI'),
            ),
          ],
        ),
      ),
    );
  }
}
