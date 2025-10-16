import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

final Signal<ThemeMode> sThemeMode = Signal(
  ThemeMode.light,
  debugLabel: 'sThemeMode',
);
