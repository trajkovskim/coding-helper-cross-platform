import 'dart:convert';

import 'package:coding_helper_cross_platform/src/services/auth_service.dart';
import 'package:coding_helper_cross_platform/src/services/forum/ForumServiceInitializer.dart';
import 'package:coding_helper_cross_platform/src/pages/contests/contests_discover_page.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumOverviewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/components/layout/coding_helper_layout.dart';
import 'src/context/index.dart';
import 'src/pages/initial_page.dart';
import 'src/pages/problems/problem_overview_page.dart';
import 'src/pages/problems/problems_discover_page.dart';
import 'src/pages/problems/problems_overview_page.dart';
import 'src/pages/profile/profile_page.dart';
import 'src/pages/profile/saved_page.dart';
import 'src/pages/profile/settings_page.dart';
import 'src/pages/profile/stats_page.dart';

void main() {
  initializeForumServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final List<Widget> widgets = [
    const InitialPage(),
    const ProblemsOverviewPage(),
    ForumOverviewPage(),
    const ProfilePage(),
  ];
  final authService = const AuthService();

  const MyApp({super.key});

  Future<void> tryLogin(BuildContext context) async {
    final storage = await SharedPreferences.getInstance();
    final sharedContext = Provider.of<SharedContext>(context, listen: false);

    const key = 'user';
    if (storage.containsKey(key)) {
      final userJson = jsonDecode(storage.getString('user')!);
      final user = Credential.fromJson(userJson);
      final tokenResponse = await user.getTokenResponse();
      final token = tokenResponse.accessToken;

      storage.setString('jwttoken', token!);
      storage.setString('logout-url', user.generateLogoutUrl().toString());
      sharedContext.setToken(token);

      final userInfo = await user.getUserInfo();
      sharedContext.setUserData(
        userInfo.preferredUsername,
        userInfo.picture.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SubmissionsContext()),
        ChangeNotifierProvider(create: (context) => ContestsContext()),
        ChangeNotifierProvider(create: (context) => ProblemsContext()),
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
              routes: {
                '/': (context) => CodingHelperLayout(widgets),
                '/problem-overview': (context) => const ProblemOverviewPage(),
                '/problems-discover': (context) => const ProblemsDiscoverPage(),
                '/contest-overview': (context) => const ContestsDiscoverPage(),
                '/contests-discover': (context) => const ContestsDiscoverPage(),
                '/stats': (context) => const StatsPage(),
                '/saved': (context) => const SavedPage(),
                '/settings': (context) => const SettingsPage(),
              },
              builder: FlutterI18n.rootAppBuilder(),
            );
          },
        );
      }),
    );
  }
}
