import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/pages/error.dart';
import 'package:coding_helper_cross_platform/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_bottom_navigation_bar.dart';

class CodeHelpLayout extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  final bottomNavigationRoutes = [
    '/',
    '/problems-overview',
    '/forum-overview',
    '/profile',
  ];

  CodeHelpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (navigatorKey.currentState != null &&
              navigatorKey.currentState!.canPop()) {
            navigatorKey.currentState?.pop();
            return false;
          }
          return true;
        },
        child: Navigator(
          key: navigatorKey,
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => const Error(),
          ),
          onGenerateRoute: (settings) {
            final route = settings.name;
            final builder = routes.entries
                .firstWhere((element) => element.key == route)
                .value;
            return MaterialPageRoute(builder: builder);
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(onChange: (value) {
        navigatorKey.currentState?.popUntil((route) => false);
        navigatorKey.currentState?.pushNamed(bottomNavigationRoutes[value]);
      }),
    );
  }
}
