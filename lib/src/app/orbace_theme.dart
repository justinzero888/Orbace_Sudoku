import 'package:flutter/material.dart';

class OrbaceTheme {
  const OrbaceTheme._();

  static const Color ink = Color(0xFF1F2522);
  static const Color paper = Color(0xFFF7F3EA);
  static const Color ricePaper = Color(0xFFFFFCF5);
  static const Color celadon = Color(0xFF8FAF9B);
  static const Color vermilion = Color(0xFFB64A35);
  static const Color mutedInk = Color(0xFF46524B);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: celadon,
      brightness: Brightness.light,
      surface: paper,
      primary: ink,
      secondary: vermilion,
      onSurface: ink,
      onSurfaceVariant: mutedInk,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: paper,
      textTheme: _textTheme(ink),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: ricePaper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE6DED0)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: ink,
        iconColor: ink,
        subtitleTextStyle: TextStyle(
          color: mutedInk,
          fontSize: 14,
          height: 1.4,
          letterSpacing: 0,
        ),
      ),
    );
  }

  static ThemeData dark() {
    const darkPaper = Color(0xFF171B19);
    const darkPanel = Color(0xFF202622);
    const warmText = Color(0xFFEDE6D7);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: celadon,
      brightness: Brightness.dark,
      surface: darkPaper,
      primary: warmText,
      secondary: vermilion,
      onSurface: warmText,
      onSurfaceVariant: warmText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkPaper,
      textTheme: _textTheme(warmText),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkPaper,
        foregroundColor: warmText,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: darkPanel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF313A35)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: warmText,
        iconColor: warmText,
        subtitleTextStyle: TextStyle(
          color: warmText,
          fontSize: 14,
          height: 1.4,
          letterSpacing: 0,
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color color) {
    return TextTheme(
      headlineMedium: TextStyle(
        color: color,
        fontSize: 30,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        color: color,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        color: color,
        fontSize: 16,
        height: 1.45,
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        color: color,
        fontSize: 14,
        height: 1.4,
        letterSpacing: 0,
      ),
    );
  }
}
