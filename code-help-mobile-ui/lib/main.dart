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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SharedContext()),
      ],
      child: Builder(builder: (context) {
        tryLogin(context);
        return Consumer<SharedContext>(
          builder: (context, sharedContext, child) {
            final activeLocale = sharedContext.locale;

            return MaterialApp(
              title: 'Code help',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
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
              home: CodeHelpLayout(),
              builder: FlutterI18n.rootAppBuilder(),
            );
          },
        );
      }),
    );
  }
}
