/// Definición del tema visual de la aplicación MusicPlayer.
///
/// Este archivo centraliza todos los colores y estilos de la app para que
/// sea fácil cambiar el aspecto visual desde un solo lugar.
///
/// **Uso:**
/// En [MusicPlayer] (main.dart) se pasa `AppTheme.light` al parámetro `theme`
/// del [GetMaterialApp]. Para habilitar el tema oscuro, se usaría `AppTheme.dark`
/// en el parámetro `darkTheme`.

import 'package:flutter/material.dart';

/// Contiene los temas claro y oscuro de la aplicación.
///
/// Todos los miembros son estáticos (`static`) para poder usarlos sin
/// crear una instancia de la clase: `AppTheme.light`, `AppTheme.dark`.
class AppTheme {
  /// Color primario de la aplicación: verde de Spotify (#1DB954).
  ///
  /// Se usa en botones, el slider de progreso, íconos de play y otros
  /// elementos de énfasis visual.
  static const Color _primary = Color(0xFF1DB954);

  // ── Colores del tema oscuro ─────────────────────────────────────────────

  /// Color de fondo principal en el tema oscuro (casi negro: #121212).
  static const Color _surfaceDark = Color(0xFF121212);

  /// Color de fondo de tarjetas y contenedores en el tema oscuro (#282828).
  static const Color _surfaceVariantDark = Color(0xFF282828);

  // ── Colores del tema claro ──────────────────────────────────────────────

  /// Color de fondo principal en el tema claro (blanco suave: #FAFAFA).
  static const Color _surfaceLight = Color(0xFFFAFAFA);

  /// Color de fondo de tarjetas y contenedores en el tema claro (#F0F0F0).
  static const Color _surfaceVariantLight = Color(0xFFF0F0F0);

  /// Color de texto principal sobre fondos claros (casi negro: #1A1A1A).
  static const Color _onSurfaceLight = Color(0xFF1A1A1A);

  /// Color de texto secundario sobre fondos claros (gris: #5C5C5C).
  static const Color _onSurfaceVariantLight = Color(0xFF5C5C5C);

  /// Tema oscuro de la aplicación.
  ///
  /// Construye un [ThemeData] con Material 3 habilitado y una paleta de
  /// colores oscura inspirada en Spotify.
  ///
  /// **Llamado desde:** [MusicPlayer.build] (actualmente no se asigna al
  /// `darkTheme`, pero está disponible para futuras implementaciones).
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  /// Tema claro de la aplicación (activo por defecto).
  ///
  /// Construye un [ThemeData] con Material 3 habilitado y una paleta de
  /// colores claros con el verde primario de la app.
  ///
  /// **Llamado desde:** [MusicPlayer.build] → `theme: AppTheme.light`.
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
