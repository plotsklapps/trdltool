import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:trdltool/screens/activategri_screen.dart';
import 'package:trdltool/screens/creategri_screen.dart';
import 'package:trdltool/services/database_service.dart';

class RoleChoiceScreen extends StatelessWidget {
  const RoleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Center(
          child: InkWell(
            onTap: () {
              toastification.show(
                alignment: Alignment.bottomCenter,
                style: ToastificationStyle.flatColored,
                icon: FaIcon(FontAwesomeIcons.rocket),
                title: Text('Functionaliteit zal worden uitgebreid.'),
                description: Text('Kom snel terug voor een nieuwe update!'),
              );
            },
            child: FaIcon(FontAwesomeIcons.bars),
          ),
        ),
        title: Text('TRDLtool', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ik ben...'),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    databaseService.generateCode();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CreateGRIScreen();
                        },
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 160,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // InkWell provides the tap effect.
                      child: Center(child: Text('Opleider')),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ActivateGRIScreen();
                        },
                      ),
                    );
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
                          'Leerling',
                          style: (TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                        ),
                      ),
                    ),
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
