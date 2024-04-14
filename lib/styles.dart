import 'package:flutter/material.dart';

/*
This file contains all the styles and themes used in the app.
*/

// Colors
Color kPrimaryColor = const Color.fromARGB(255, 8, 176, 227);

// Fonts
TextStyle kTitlePrimary = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: kDarkTheme.copyWith().colorScheme.primary,
);
TextStyle kTitle = const TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
);
TextStyle kSubtitle = const TextStyle(
  fontSize: 18,
);
TextStyle kLabel = TextStyle(
  fontSize: 12,
  color: kDarkTheme.copyWith().colorScheme.onSurfaceVariant,
  fontWeight: FontWeight.bold,
);
// Metrics
double kDefaultSpace = 10.0;

// Theme
bool kIsDarkTheme = true;

ThemeData kDarkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    brightness: kIsDarkTheme ? Brightness.dark : Brightness.light,
  ),
);