import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - تدرجات البنفسجي والأزرق
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8B83FF);
  
  // Secondary Colors - تدرجات الوردي والبرتقالي
  static const Color secondary = Color(0xFFFF6B9D);
  static const Color secondaryDark = Color(0xFFE55A87);
  static const Color secondaryLight = Color(0xFFFF8FB3);
  
  // Accent Colors - تدرجات الذهبي والبرتقالي
  static const Color accent = Color(0xFFFFB347);
  static const Color accentDark = Color(0xFFFF8C42);
  static const Color accentLight = Color(0xFFFFD93D);
  
  // Background Colors - Light Mode
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  
  // Background Colors - Dark Mode
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2D2D2D);
  
  // Text Colors - Light Mode
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFF95A5A6);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Text Colors - Dark Mode
  static const Color textPrimaryDark = Color(0xFFE1E1E1);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textTertiaryDark = Color(0xFF808080);
  
  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFE67E22);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);
  
  // Chat Colors
  static const Color myMessage = Color(0xFF6C63FF);
  static const Color otherMessage = Color(0xFFE8E8E8);
  static const Color otherMessageDark = Color(0xFF2D2D2D);
  static const Color online = Color(0xFF27AE60);
  static const Color offline = Color(0xFF95A5A6);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF8B83FF),
      Color(0xFFFF6B9D),
    ],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B9D),
      Color(0xFFE55A87),
      Color(0xFF6C63FF),
    ],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFB347),
      Color(0xFFFFD93D),
      Color(0xFF3498DB),
    ],
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2C3E50),
      Color(0xFF34495E),
      Color(0xFF5A52D5),
    ],
  );
  
  // Helper methods for theme-aware colors
  static Color getBackgroundColor(bool isDark) {
    return isDark ? backgroundDark : background;
  }
  
  static Color getSurfaceColor(bool isDark) {
    return isDark ? surfaceDark : surface;
  }
  
  static Color getTextPrimaryColor(bool isDark) {
    return isDark ? textPrimaryDark : textPrimary;
  }
  
  static Color getTextSecondaryColor(bool isDark) {
    return isDark ? textSecondaryDark : textSecondary;
  }
  
  static LinearGradient getMainGradient(bool isDark) {
    return isDark ? darkGradient : primaryGradient;
  }
}