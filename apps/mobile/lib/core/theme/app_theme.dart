import 'package:flutter/material.dart';

class BhakthiColors {
  // Backgrounds — warm parchment system
  static const parchment      = Color(0xFFF4F1EC);
  static const parchmentElev  = Color(0xFFEBE6DD);
  static const deepInk        = Color(0xFF1A1814);

  // Semantic palette (roadmap-style)
  static const rust           = Color(0xFFC2533C);
  static const amber          = Color(0xFFD18A2A);
  static const amberLight     = Color(0xFFE3A142);
  static const purple         = Color(0xFF6B4D80);
  static const teal           = Color(0xFF2DA6B3);
  static const tealDeep       = Color(0xFF0D4C5C);
  static const pink           = Color(0xFFE85A7A);
  static const emerald        = Color(0xFF5A8D76);
  static const indigo         = Color(0xFF3A4F7A);
  static const mustard        = Color(0xFFC89234);

  // Text
  static const textPrimary    = Color(0xFF1A1814);
  static const textSecondary  = Color(0xBD1A1814); // 74% opacity
  static const textTertiary   = Color(0x801A1814); // 50% opacity

  // Borders
  static const line           = Color(0x1A1C1814); // 10% opacity
  static const lineStrong     = Color(0x381C1814); // 22% opacity

  // Backwards-compat aliases used in existing widgets
  static const saffron    = rust;
  static const deepRed    = deepInk;
  static const gold       = amber;
  static const creamWhite = parchment;
  static const mutedGold  = amberLight;
  static const auspicious = emerald;
}

class BhakthiTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: BhakthiColors.rust,
      primary: BhakthiColors.rust,
      secondary: BhakthiColors.amber,
      surface: BhakthiColors.parchment,
    ),
    scaffoldBackgroundColor: BhakthiColors.parchment,
    appBarTheme: const AppBarTheme(
      backgroundColor: BhakthiColors.deepInk,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: BhakthiColors.line),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: BhakthiColors.rust,
      unselectedItemColor: Color(0xFF999999),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: BhakthiColors.rust,
      unselectedLabelColor: Color(0xFF999999),
      indicatorColor: BhakthiColors.rust,
      dividerColor: Colors.transparent,
      labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: BhakthiColors.deepInk,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.04 * 32,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        color: BhakthiColors.deepInk,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        color: BhakthiColors.textPrimary,
        fontSize: 17,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        color: BhakthiColors.textSecondary,
        fontSize: 14,
        height: 1.55,
      ),
    ),
  );
}

// Deity color assignments (roadmap data-color system)
const Map<String, Color> deityColors = {
  'ganesha':   BhakthiColors.rust,
  'lakshmi':   BhakthiColors.mustard,
  'saraswati': BhakthiColors.teal,
  'shiva':     BhakthiColors.indigo,
  'vishnu':    BhakthiColors.purple,
  'krishna':   BhakthiColors.teal,
  'rama':      BhakthiColors.emerald,
  'hanuman':   BhakthiColors.amber,
  'murugan':   BhakthiColors.pink,
};
