import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ErrorCode {
  PROBLEMS(1000);

  final int value;
  const ErrorCode(this.value);
}

class UserData {
  String username;
  String image;

  UserData(this.username, this.image);
}

class AppSettings {
  String? locale = 'en';
  String? defaultLanguage;
  String? accentColor;
  String? theme;
}

enum Language {
  EN('en'),
  DE('de'),
  MK('mk');

  final String value;

  const Language(this.value);
}

class SharedContext extends ChangeNotifier {
  String? _jwttoken;
  int? _errorCode;
  UserData? _userData;
  final AppSettings _settings = AppSettings();

  bool get isAuthenticated => jwttoken != null;

  String? get jwttoken => _jwttoken;

  int? get errorCode => _errorCode;

  UserData? get userData => _userData;

  AppSettings? get appSettings => _settings;

  String get locale => _settings.locale ?? 'en';

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

  void setUserData(String username, String image) {
    _userData = UserData(username, image);
    notifyListeners();
  }

  void setToken(String jwttoken) {
    _jwttoken = jwttoken;
    notifyListeners();
  }

  void setErrorCode(ErrorCode errorCode) {
    _errorCode = errorCode.value;
    notifyListeners();
  }
}

void handleError(context, ErrorCode errorCode) {
  final sharedContext = Provider.of<SharedContext>(context, listen: false);
  sharedContext.setErrorCode(errorCode);
}
