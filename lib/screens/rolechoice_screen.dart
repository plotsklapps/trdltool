import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trdltool/screens/activategri_screen.dart';
import 'package:trdltool/screens/creategri_screen.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/theme/flex_theme.dart';
import 'package:web/web.dart' as web;

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
              showModalBottomSheet(
                showDragHandle: true,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Instellingen'),
                        Divider(),
                        ListTile(
                          title: Text('Thema'),
                          subtitle: Text('Verander de app kleur'),
                          trailing: Icon(Icons.refresh),
                          onTap: () {
                            if (sFlexScheme.value == FlexScheme.redWine) {
                              sFlexScheme.value = FlexScheme.money;
                            } else if (sFlexScheme.value == FlexScheme.money) {
                              sFlexScheme.value = FlexScheme.blueWhale;
                            } else {
                              sFlexScheme.value = FlexScheme.redWine;
                            }
                          },
                        ),
                        ListTile(
                          title: Text('Versie 0.0.2 beta'),
                          subtitle: Text(
                            'Herlaad de app om nieuwe updates te installeren',
                          ),
                          trailing: Icon(Icons.refresh),
                          onTap: () {
                            web.window.location.reload();
                          },
                        ),
                      ],
                    ),
                  );
                },
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
