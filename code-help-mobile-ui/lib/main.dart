import 'dart:convert';

import 'package:coding_helper_cross_platform/src/components/layout/coding_helper_layout.dart';
import 'package:coding_helper_cross_platform/src/pages/error.dart';
import 'package:coding_helper_cross_platform/src/pages/coding_helper_initial_page.dart';
import 'package:coding_helper_cross_platform/src/services/auth_service.dart';
import 'package:coding_helper_cross_platform/src/services/forum/ForumServiceInitializer.dart';
import 'package:coding_helper_cross_platform/src/services/interceptors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/context/index.dart';

void main() {
  ErrorWidget.builder = (details) {
    return const Error();
  };

  initializeForumServices();
  runApp(const MyApp());
}

const Map<String, ThemeMode> THEMES_MAP = {
  'light': ThemeMode.light,
  'dark': ThemeMode.dark,
  'system': ThemeMode.system,
};

const Map<String, MaterialColor> COLORS_MAP = {
  'purple': Colors.purple,
  'blue': Colors.blue,
  'red': Colors.red,
};

class MyApp extends StatelessWidget {
  final authService = const AuthService();

  const MyApp({super.key});

  Future<void> tryLogin(SharedContext sharedContext) async {
    final storage = await SharedPreferences.getInstance();

    const userKey = 'user';
    const tokenKey = 'jwttoken';
    if (storage.containsKey(userKey)) {
      final userJson = jsonDecode(storage.getString(userKey)!);
      final user = Credential.fromJson(userJson);

      user
          .getTokenResponse(true)
          .then((response) async {
            storage.setString(tokenKey, response.accessToken!);

            final userInfo = await user.getUserInfo();
            sharedContext.setUserData(
              userInfo.preferredUsername,
              userInfo.picture.toString(),
            );
          })
          .then((value) => UserToken.initialize())
          .onError((error, stackTrace) {
            storage.remove(userKey);
            storage.remove(tokenKey);
          });
    }
  }

  Future<void> init(SharedContext sharedContext) async {
    final storage = await SharedPreferences.getInstance();

    sharedContext.setAppSettings(
      storage.getString('default-language') ?? DEFAULT_LANGUAGES[0],
      storage.getString('accent-color') ?? ACCENT_COLORS[0],
      storage.getString('theme') ?? THEMES[0],
      storage.getString('locale') ?? APPLICATION_LANGUAGES[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SharedContext()),
      ],
      child: Builder(
        builder: (context) {
          final sharedContext = Provider.of<SharedContext>(context, listen: false);

          return FutureBuilder(
            future:
                Future.wait([tryLogin(sharedContext), init(sharedContext), Future.delayed(const Duration(seconds: 2))]),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return MaterialApp(
                  home: const CodingHelperInitialPage(),
                  darkTheme: ThemeData.dark(),
                  theme: ThemeData.light(),
                  themeMode: ThemeMode.system,
                );
              }

              return Consumer<SharedContext>(
                builder: (context, sharedContext, child) {
                  String activeLocale = sharedContext.locale;
                  String? theme = sharedContext.appSettings?.theme;
                  String? accentColor = sharedContext.appSettings?.accentColor;

                  return MaterialApp(
                    title: 'CodingHelper',
                    darkTheme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: COLORS_MAP[accentColor]!,
                        brightness: Brightness.dark,
                      ),
                    ),
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: COLORS_MAP[accentColor]!,
                      ),
                    ),
                    themeMode: THEMES_MAP[theme],
                    localizationsDelegates: [
                      FlutterI18nDelegate(
                        missingTranslationHandler: (key, locale) => key,
                        translationLoader: FileTranslationLoader(
                          basePath: "assets/i18n",
                          fallbackFile: activeLocale,
                          forcedLocale: Locale(activeLocale),
                        ),
                      ),
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    home: const CodingHelperLayout(),
                    builder: FlutterI18n.rootAppBuilder(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
