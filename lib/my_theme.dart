import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,

  // Colors
  primaryColor: const Color(0xFF4A392D), // Dark brown
  scaffoldBackgroundColor: const Color(0xFFFDF6EC), // Soft cream
  canvasColor: const Color(0xFFFDF6EC),
  cardColor: const Color(0xFFFFFBF5), // Slightly different cream for cards

  // Typography
  fontFamily: 'Georgia',
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF4A392D)),
    headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF4A392D)),
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4A392D)),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF4A392D)),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A392D)),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
    bodySmall: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF6B4C3B)),
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF4A392D),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),

  // Elevated Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4A392D),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: const TextStyle(fontFamily: 'Georgia', fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  // Outlined Buttons
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF4A392D),
      side: const BorderSide(color: Color(0xFF4A392D), width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontFamily: 'Georgia', fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  // Text Buttons
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF4A392D),
      textStyle: const TextStyle(fontFamily: 'Georgia', fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),

  // Input Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFFFBF5),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF4A392D)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF4A392D), width: 2),
    ),
    labelStyle: const TextStyle(
      fontFamily: 'Georgia',
      fontSize: 16,
      color: Color(0xFF4A392D),
    ),
  ),

  // Chips
  chipTheme: ChipThemeData(
    backgroundColor: Colors.brown.shade100.withOpacity(0.3),
    selectedColor: const Color(0xFF6B4C3B),
    secondarySelectedColor: const Color(0xFF6B4C3B),
    disabledColor: Colors.grey.shade200,
    labelStyle: const TextStyle(
      fontFamily: 'Georgia',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF4A392D),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: Colors.brown.shade300),
    ),
  ),

  // Cards (used in sections, not full screen top-card anymore)
  cardTheme: CardTheme(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: const Color(0xFFFFFBF5),
  ),

  // Divider
  dividerTheme: DividerThemeData(
    color: Colors.brown.shade200,
    thickness: 1,
    space: 24,
  ),

  // Icons
  iconTheme: const IconThemeData(
    color: Color(0xFF6B4C3B),
    size: 22,
  ),

  // Scrollbar
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(const Color(0xFF6B4C3B).withOpacity(0.6)),
    trackColor: MaterialStateProperty.all(const Color(0xFFF3EDE0)),
    radius: const Radius.circular(8),
    thickness: MaterialStateProperty.all(6),
  ),

  // Dialogs
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFFFFFBF5),
    titleTextStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF4A392D),
    ),
    contentTextStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 16,
      color: Colors.black87,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);

// Optional: Extension for section headers
extension ThemeExtras on ThemeData {
  TextStyle get sectionHeaderTextStyle => const TextStyle(
        fontFamily: 'Georgia',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A392D),
      );
}
