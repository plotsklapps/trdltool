import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trdltool/logic/modal_logic.dart';
import 'package:trdltool/modals/reload_modal.dart';
import 'package:trdltool/modals/theme_modal.dart';
import 'package:trdltool/modals/version_modal.dart';
import 'package:trdltool/signals/version_signal.dart';

class MenuModal extends StatelessWidget {
  const MenuModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Instellingen'),
          Divider(),
          ListTile(
            title: Text('Thema'),
            subtitle: Text('Verander het uiterlijk van de app'),
            trailing: Icon(LucideIcons.chevronRight),
            onTap: () {
              showModal(context: context, child: ThemeModal());
            },
          ),
          ListTile(
            title: Text('Over TRDLtool'),
            subtitle: Text('Meer informatie over deze app'),
            trailing: Icon(LucideIcons.chevronRight),
            onTap: () {
              showModal(context: context, child: VersionModal());
            },
          ),
          ListTile(
            title: Text('Versie: ${sVersion.value}'),
            subtitle: Text('Herlaad de app om nieuwe updates te installeren'),
            trailing: Icon(LucideIcons.chevronRight),
            onTap: () {
              showModal(context: context, child: ReloadModal());
            },
          ),
        ],
      ),
    );
  }
}
