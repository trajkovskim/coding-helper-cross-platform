import 'dart:ffi';

import 'package:coding_helper_cross_platform/src/pages/error.dart';
import 'package:coding_helper_cross_platform/src/routes.dart';
import 'package:coding_helper_cross_platform/src/services/interceptors.dart';
import 'package:flutter/material.dart';

import 'custom_bottom_navigation_bar.dart';

class CodingHelperLayout extends StatefulWidget {
  const CodingHelperLayout({super.key});

  @override
  State<CodingHelperLayout> createState() => _CodingHelperLayoutState();
}

class NamedRoute {
  final String name;
  final Function() condition;

  static isTrue() {
    return true;
  }

  NamedRoute({required this.name, this.condition = isTrue});
}

class _CodingHelperLayoutState extends State<CodingHelperLayout> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final allRoutes = [
    '/',
    '/problems-overview',
    '/forum-overview',
    '/profile',
  ];

  final authenticated = ['/forum-overview'];

  List<String> actualRoutes = [];
  bool hasToken = false;

  Function()? unsub = null;

  @override
  void initState() {
    setState(() {
      actualRoutes = allRoutes.where((element) => !authenticated.contains(element)).toList();
    });

    super.initState();
  }

  getCurrentPage(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }

  updateIndex(List<String> newRoutes) {}

  int pageIndex = 0;

  unsubscribe() {
    if (unsub != null) {
      unsub!();
      unsub = null;
    }
  }

  resubscribe(BuildContext context) {
    unsubscribe();

    unsub = UserToken.subscribe((data) {
      final currentPage = actualRoutes[pageIndex];

      setState(() {
        hasToken = data.hasToken();
        actualRoutes = allRoutes
            .where(
                (element) => !authenticated.contains(element) || (authenticated.contains(element) && data.hasToken()))
            .toList();

        pageIndex = actualRoutes.indexOf(currentPage);
      });
    });
  }

  @override
  void dispose() {
    unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    resubscribe(context);

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (navigatorKey.currentState != null && navigatorKey.currentState!.canPop()) {
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
            final route = settings.name ?? '/';
            final builder = routes.entries.firstWhere((element) => element.key == route).value;

            return MaterialPageRoute(
              builder: (context) {
                return RefreshIndicator(
                  onRefresh: () async {
                    navigatorKey.currentState?.popAndPushNamed(
                      route,
                      arguments: settings.arguments,
                    );
                  },
                  child: builder(context),
                );
              },
              settings: settings,
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        pageIndex: pageIndex,
        onChange: (value) {
          navigatorKey.currentState?.popUntil((route) => false);
          navigatorKey.currentState?.pushNamed(actualRoutes[value]);
          setState(() {
            pageIndex = value;
          });
        },
        hasToken: hasToken,
      ),
    );
  }
}
