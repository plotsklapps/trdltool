import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:trdltool/screens/activategri_screen.dart';
import 'package:trdltool/screens/creategri_screen.dart';
import 'package:trdltool/services/database_service.dart';

class RolKeuzeScreen extends StatelessWidget {
  const RolKeuzeScreen({super.key});

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
                FilledButton(
                  onPressed: () {
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
                  child: Text('Opleider'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ActivateGRIScreen();
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
