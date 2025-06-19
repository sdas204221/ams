import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,

  // Colors
  primaryColor: const Color(0xFF0D47A1),            // Dark navy blue (AppBar + selected menus)
  scaffoldBackgroundColor: const Color(0xFFE3F2FD),  // Very light blue background
  canvasColor: const Color(0xFFE3F2FD),
  cardColor: const Color(0xFFFFFFFF),               // White cards

  // Typography
  fontFamily: 'Georgia',
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
    headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF0D47A1)),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
    bodySmall: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF1565C0)),
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0D47A1),
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

  // Elevated Buttons (“Join Now”, etc.)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFC107),   // Amber accent instead of purple
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: const TextStyle(fontFamily: 'Georgia', fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  // Outlined Buttons (borders in primary blue)
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF0D47A1),
      side: const BorderSide(color: Color(0xFF0D47A1), width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontFamily: 'Georgia', fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  // Text Buttons (blue text)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF0D47A1),
      textStyle: const TextStyle(fontFamily: 'Georgia', fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),

  // Input Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0D47A1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
    ),
    labelStyle: const TextStyle(
      fontFamily: 'Georgia',
      fontSize: 16,
      color: Color(0xFF0D47A1),
    ),
  ),

  // Chips
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFFBBDEFB).withOpacity(0.5), // light blue
    selectedColor: const Color(0xFF1565C0),
    secondarySelectedColor: const Color(0xFF1565C0),
    disabledColor: Colors.grey.shade200,
    labelStyle: const TextStyle(
      fontFamily: 'Georgia',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF0D47A1),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Color(0xFF90CAF9)),
    ),
  ),

  // Cards
  cardTheme: CardTheme(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: const Color(0xFFFFFFFF),
  ),

  // Divider
  dividerTheme: DividerThemeData(
    color: const Color(0xFF90CAF9),
    thickness: 1,
    space: 24,
  ),

  // Icons
  iconTheme: const IconThemeData(
    color: Color(0xFF1565C0),
    size: 22,
  ),

  // Scrollbar
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(const Color(0xFF1565C0).withOpacity(0.6)),
    trackColor: MaterialStateProperty.all(const Color(0xFFE3F2FD)),
    radius: const Radius.circular(8),
    thickness: MaterialStateProperty.all(6),
  ),

  // Dialogs
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFFFFFFFF),
    titleTextStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF0D47A1),
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
        color: Color(0xFF0D47A1),
      );
}
