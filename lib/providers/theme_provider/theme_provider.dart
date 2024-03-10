import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // Constant key for storing theme preference
  static const themeStatus = 'Theme_Status';

  // Private variable to store current theme state
  bool _isDarkMode = false;

  // Constructor: Load theme preference on initialization
  ThemeProvider() {
    _loadTheme();
  }

  // Public getter for theme state
  bool get isDarkMode => _isDarkMode;

  // Method to toggle theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode; // Switch theme
    await _saveTheme(); // Save preference
    notifyListeners(); // Notify listeners about change
  }

  // Helper method to save theme preference
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, _isDarkMode);
  }

  // Helper method to load theme preference
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(themeStatus) ?? false;
  }
}
