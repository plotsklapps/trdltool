import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';

// Signal to hold the AppThemeColor.
final Signal<FlexScheme> sFlexScheme = Signal<FlexScheme>(
  FlexScheme.redWine,
  debugLabel: 'sFlexScheme',
);

// Signal to hold the AppTheme.
final Computed<ThemeData> cThemeData = Computed(() {
  return FlexThemeData.light(
    scheme: sFlexScheme.value,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 11,
    appBarOpacity: 0.85,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnLevel: 12,
      thinBorderWidth: 1.5,
      thickBorderWidth: 3.0,
      switchThumbFixedSize: true,
      sliderTrackHeight: 6,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      tooltipRadius: 4,
      tooltipSchemeColor: SchemeColor.inverseSurface,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      appBarCenterTitle: true,
      navigationRailUseIndicator: true,
    ),
    keyColors: const FlexKeyColors(),
    visualDensity: VisualDensity.compact,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    fontFamily: GoogleFonts.inter().fontFamily,
  );
});
