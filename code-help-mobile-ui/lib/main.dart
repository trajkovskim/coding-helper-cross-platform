import 'package:coding_helper_cross_platform/src/forum/service/ForumServiceInitializer.dart';
import 'package:coding_helper_cross_platform/src/pages/contests/contests_discover_page.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumOverviewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

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

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SubmissionsContext()),
        ChangeNotifierProvider(create: (context) => ContestsContext()),
        ChangeNotifierProvider(create: (context) => ProblemsContext()),
        ChangeNotifierProvider(create: (context) => SharedContext()),
      ],
      child: Consumer<SharedContext>(
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
      ),
    );
  }
}
