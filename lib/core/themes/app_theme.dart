import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/services/server_shared.dart';

class ThemeService {
  final MyServices _myServices = Get.find<MyServices>();
  static const String _darkThemeKey = "isDarkTheme";

  // Theme Colors
  static const Color primaryBlue = Color(0xFF00BCD4);
  static const Color darkBackground = Color(0xFF1C2B35);
  static const Color lightGrey = Color(0xFFF5F7FA);

  // Common Button Style
  static ButtonStyle _createButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      minimumSize: const Size(double.infinity, 50),
    );
  }

  // Common Input Decoration
  static InputDecorationTheme _createInputDecoration({
    required Color fillColor,
    required Color labelColor,
    required Color hintColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: _defaultBorder(),
      enabledBorder: _defaultBorder(),
      focusedBorder: _focusedBorder(),
      labelStyle: TextStyle(color: labelColor),
      hintStyle: TextStyle(color: hintColor),
    );
  }

  static OutlineInputBorder _defaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
  }

  static OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: primaryBlue),
    );
  }

  // Light Theme
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          secondary: primaryBlue,
          surface: Colors.white,
          background: Colors.white,
          error: Color(0xFFE57373),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black87,
          onBackground: Colors.black87,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryBlue),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: _createLightTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: _createButtonStyle(),
        ),
        inputDecorationTheme: _createInputDecoration(
          fillColor: lightGrey,
          labelColor: Colors.black54,
          hintColor: Colors.black38,
        ),
      );

  // Dark Theme
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackground,
        colorScheme: ColorScheme.dark(
          primary: primaryBlue,
          secondary: primaryBlue,
          surface: darkBackground,
          background: darkBackground,
          error: const Color(0xFFCF6679),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: _createDarkTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: _createButtonStyle(),
        ),
        inputDecorationTheme: _createInputDecoration(
          fillColor: darkBackground.withOpacity(0.5),
          labelColor: Colors.white70,
          hintColor: Colors.white54,
        ),
      );

  static TextTheme _createLightTextTheme() {
    return const TextTheme(
      titleLarge: TextStyle(
        color: Colors.black87,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Colors.black54,
        fontSize: 14,
      ),
    );
  }

  static TextTheme _createDarkTextTheme() {
    return const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
    );
  }

  // Theme Management Methods
  void saveThemeData(bool isDarkTheme) {
    _myServices.sharedPreferences.setBool(_darkThemeKey, isDarkTheme);
  }

  bool isSavedDarkTheme() {
    return _myServices.sharedPreferences.getBool(_darkThemeKey) ?? false;
  }

  ThemeMode getThemeMode() {
    return isSavedDarkTheme() ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme() {
    bool newThemeMode = !isSavedDarkTheme();
    saveThemeData(newThemeMode);
    Get.changeThemeMode(newThemeMode ? ThemeMode.dark : ThemeMode.light);
  }
}
