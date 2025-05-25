import 'package:flutter/material.dart';

enum ErrorCode {
  HOME(0000),
  PROBLEMS_OVERVIEW(1000),
  PROBLEM_OVERVIEW(2000),
  PROBLEM_DISCOVER(3000),
  PROBLEM_ARENA(4000),
  CONTESTS_OVERVIEW(5000),
  CONTESTS_DISCOVER(6000),
  FORUM_OVERVIEW(7000),
  PROFILE(8000);

  final int value;
  const ErrorCode(this.value);
}

enum Language {
  EN('en'),
  DE('de'),
  MK('mk');

  final String value;

  const Language(this.value);
}

final ACCENT_COLORS = ['purple', 'blue', 'red'];
final APPLICATION_LANGUAGES = ['en', 'de', 'mk'];
final THEMES = ['light', 'dark', 'system'];
final DEFAULT_LANGUAGES = ['javascript', 'java'];

class UserData {
  String? username;
  String? image;

  UserData(this.username, this.image);
}

class AppSettings {
  String? locale = APPLICATION_LANGUAGES[0];
  String? defaultLanguage = DEFAULT_LANGUAGES[0];
  String? accentColor = ACCENT_COLORS[0];
  String? theme = THEMES[2];
}

class SharedContext extends ChangeNotifier {
  int? _errorCode;
  UserData? _userData;
  final AppSettings _settings = AppSettings();

  bool get isAuthenticated => _userData != null;

  int? get errorCode => _errorCode;

  UserData? get userData => _userData;

  AppSettings? get appSettings => _settings;

  String get locale => _settings.locale ?? Language.EN.value;

  void setErrorCode(int? errorCode) {
    _errorCode = errorCode;
    notifyListeners();
  }

  void setLocale(String? language) {
    _settings.locale = language;
    notifyListeners();
  }

  void setAccentColor(String? accentColor) {
    _settings.accentColor = accentColor;
    notifyListeners();
  }

  void setTheme(String? theme) {
    _settings.theme = theme;
    notifyListeners();
  }

  void setDefaultLanguage(String? language) {
    _settings.defaultLanguage = language;
    notifyListeners();
  }

  void setAppSettings(
    String? defaultLanguage,
    String? accentColor,
    String? theme,
    String? locale,
  ) {
    _settings
      ..accentColor = accentColor
      ..defaultLanguage = defaultLanguage
      ..locale = locale
      ..theme = theme;
    notifyListeners();
  }

  void setUserData(String? username, String? image) {
    if (username == null && image == null) {
      _userData = null;
    } else {
      _userData = UserData(username, image);
    }
    notifyListeners();
  }
}
