import 'dart:convert';

import 'package:coding_helper_cross_platform/src/components/layout/coding_helper_layout.dart';
import 'package:coding_helper_cross_platform/src/pages/error.dart';
import 'package:coding_helper_cross_platform/src/services/auth_service.dart';
import 'package:coding_helper_cross_platform/src/services/forum/ForumServiceInitializer.dart';
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
  'red': Colors.red
};

class MyApp extends StatelessWidget {
  final authService = const AuthService();

  const MyApp({super.key});

  Future<void> tryLogin(BuildContext context) async {
    final storage = await SharedPreferences.getInstance();
    final sharedContext = Provider.of<SharedContext>(context, listen: false);

    const key = 'user';
    if (storage.containsKey(key)) {
      final userJson = jsonDecode(storage.getString('user')!);
      final user = Credential.fromJson(userJson);

      user.getTokenResponse().then((response) async {
        storage.setString('jwttoken', response.accessToken!);
        storage.setString('logout-url', user.generateLogoutUrl().toString());
        sharedContext.setToken(response.accessToken);

        final userInfo = await user.getUserInfo();
        sharedContext.setUserData(
          userInfo.preferredUsername,
          userInfo.picture.toString(),
        );
      }).onError((error, stackTrace) {
        storage.remove('user');
        storage.remove('jwttoken');
        storage.remove('logout-url');
      });
    }
  }

  Future<void> init(BuildContext context) async {
    final storage = await SharedPreferences.getInstance();
    final sharedContext = Provider.of<SharedContext>(context, listen: false);

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
      child: Builder(builder: (context) {
        init(context);
        tryLogin(context);
        return Consumer<SharedContext>(
          builder: (context, sharedContext, child) {
            final activeLocale = sharedContext.locale;
            final theme = sharedContext.appSettings?.theme;
            final accentColor = sharedContext.appSettings?.accentColor;

            return MaterialApp(
              title: 'Codehelp',
              darkTheme: ThemeData(
                primarySwatch: COLORS_MAP[accentColor],
              ),
              theme: ThemeData(
                primarySwatch: COLORS_MAP[accentColor],
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
              home: const CodeHelpLayout(),
              builder: FlutterI18n.rootAppBuilder(),
            );
          },
        );
      }),
    );
  }
}
