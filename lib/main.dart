import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:trdltool/screens/rolechoice_screen.dart';
import 'package:trdltool/signals/version_signal.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'firebase_options.dart';
import 'theme/flex_theme.dart';

Future<void> main() async {
  // Bind the Flutter framework to the engine.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options for the current platform.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load app version.
  await loadAppVersion();

  // Run Wakelock to keep the screen on.
  await WakelockPlus.enable();

  // Run the application.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TRDLtool',
        theme: cThemeData.watch(context),
        home: const RoleChoiceScreen(),
      ),
    );
  }
}
