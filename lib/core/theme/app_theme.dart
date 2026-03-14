import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color(0xFF1DB954);
  // Tema oscuro
  static const Color _surfaceDark = Color(0xFF121212);
  static const Color _surfaceVariantDark = Color(0xFF282828);

  // Tema claro
  static const Color _surfaceLight = Color(0xFFFAFAFA);
  static const Color _surfaceVariantLight = Color(0xFFF0F0F0);
  static const Color _onSurfaceLight = Color(0xFF1A1A1A);
  static const Color _onSurfaceVariantLight = Color(0xFF5C5C5C);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _primary,
        surface: _surfaceDark,
        surfaceContainerHighest: _surfaceVariantDark,
        onPrimary: Colors.black,
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white70,
      ),
      scaffoldBackgroundColor: _surfaceDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: _surfaceVariantDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _primary,
        surface: _surfaceLight,
        surfaceContainerHighest: _surfaceVariantLight,
        onPrimary: Colors.white,
        onSurface: _onSurfaceLight,
        onSurfaceVariant: _onSurfaceVariantLight,
      ),
      scaffoldBackgroundColor: _surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceLight,
        elevation: 0,
        foregroundColor: _onSurfaceLight,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _onSurfaceLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
