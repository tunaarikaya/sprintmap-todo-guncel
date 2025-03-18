import 'package:flutter/material.dart';

class AppTheme {
  // Renk paleti
  static const Color primaryColor = Color(0xFF2196F3); // Ana mavi
  static const Color secondaryColor = Color(0xFF64B5F6); // Açık mavi
  static const Color accentColor = Color(0xFF1976D2); // Koyu mavi
  static const Color tertiaryColor = Color(0xFF90CAF9); // Pastel mavi
  static const Color quaternaryColor = Color(0xFFBBDEFB); // En açık mavi

  // Tema verileri
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: tertiaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: primaryColor,
      ),
    );
  }

  // Drawer tema renkleri
  static Color getDrawerItemColor(bool isSelected) {
    return isSelected ? secondaryColor : Colors.grey.shade600;
  }

  // Drawer arka plan rengi
  static Color get drawerHeaderColor => primaryColor;

  // Drawer başlık metni rengi
  static Color get drawerHeaderTextColor => Colors.white;

  // Kütüphane marker rengi
  static Color get libraryMarkerColor => accentColor;

  // Kullanıcı konum marker rengi
  static Color get userLocationMarkerColor => secondaryColor;

  // Kart arka plan rengi
  static Color get cardBackgroundColor => Colors.grey.shade50;
}
