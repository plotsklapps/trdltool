import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trdltool/signals/version_signal.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionModal extends StatelessWidget {
  const VersionModal({super.key});

  static final Uri _githubUrl = Uri.parse(
    'https://github.com/plotsklapps/trdltool',
  );

  Future<void> _launchGitHub() async {
    if (!await launchUrl(_githubUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_githubUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Huidige versie: ${sVersion.value}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ListTile(
              onTap: _launchGitHub,
              leading: const Icon(LucideIcons.github),
              title: const Text('Versie 0.0.1+8 20260122'),
              subtitle: const Text(
                '- Flutter downgrade naar 3.38 (stable);\n'
                '- Dependencies geupgraded;\n'
                '- Type Error gefixed, codes weer beschikbaar.',
              ),
            ),
            ListTile(
              onTap: _launchGitHub,
              leading: const Icon(LucideIcons.github),
              title: const Text('Versie 0.0.1+7 20260107'),
              subtitle: const Text('- Flutter upgrade naar 3.40 (master).'),
            ),
            ListTile(
              onTap: _launchGitHub,
              leading: const Icon(LucideIcons.github),
              title: const Text('Versie 0.0.1+6 20251129'),
              subtitle: const Text('- Dependencies geupgraded.'),
            ),
            ListTile(
              onTap: _launchGitHub,
              leading: const Icon(LucideIcons.github),
              title: const Text('Versie 0.0.1+5 20251025'),
              subtitle: const Text(
                '- Refactored naar very_good_analysis;\n'
                '- BO-Alarm toon toegevoegd!;\n'
                '- Van MP3 naar WAV format (kleiner & sneller);\n'
                '- Nieuwe backend logica, herinstallatie noodzakelijk.',
              ),
            ),
            ListTile(
              onTap: _launchGitHub,
              leading: const Icon(LucideIcons.github),
              title: const Text('Versie 0.0.1+4 20251023'),
              subtitle: const Text(
                '- flutter_lints ingewisseld voor very_good_analysis;\n'
                '- iOS/macOS/Android/Linux en Windows folders verwijderd;\n'
                '- Appnaam TRDLtool ipv trdltool.',
              ),
            ),
            ListTile(
              onTap: _launchGitHub,
              leading: const Icon(LucideIcons.github),
              title: const Text('Versie 0.0.1+3 20251016'),
              subtitle: const Text(
                "- Thema's en letterypen aanpasbaar;\n"
                '- Nieuw versioning systeem (pubspec.yaml);\n'
                '- url_launcher toegevoegd;\n'
                '- WakeLockPlus toegevoegd (scherm blijft aan).',
              ),
            ),
            ListTile(
              onTap: _launchGitHub,
              leading: const Icon(LucideIcons.github),
              title: const Text('Versie 0.0.1+2 20250909'),
              subtitle: const Text(
                '- Geluiden toegevoegd (just_audio);\n'
                '- Dependencies geüpgraded;\n'
                '- Themawisselaar toegevoegd (flex_color_scheme).',
              ),
            ),
            ListTile(
              onTap: _launchGitHub,
              leading: const Icon(LucideIcons.github),
              title: const Text('Versie 0.0.1+1 20250707'),
              subtitle: const Text('- Eerste release.'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showAboutDialog(context: context);
                    },
                    child: const Text('Licenties'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Pop the bottomsheet.
                      Navigator.pop(context);
                    },
                    child: const Text('Terug'),
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
