import 'package:coding_helper_cross_platform/src/pages/contests/contest_overview_page.dart';
import 'package:coding_helper_cross_platform/src/pages/contests/contests_discover_page.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumOverviewPage.dart';
import 'package:coding_helper_cross_platform/src/pages/initial_page.dart';
import 'package:coding_helper_cross_platform/src/pages/problems/problem_arena_page.dart';
import 'package:coding_helper_cross_platform/src/pages/problems/problem_overview_page.dart';
import 'package:coding_helper_cross_platform/src/pages/problems/problems_discover_page.dart';
import 'package:coding_helper_cross_platform/src/pages/problems/problems_overview_page.dart';
import 'package:coding_helper_cross_platform/src/pages/profile/profile_page.dart';
import 'package:coding_helper_cross_platform/src/pages/profile/saved_page.dart';
import 'package:coding_helper_cross_platform/src/pages/profile/settings_page.dart';
import 'package:coding_helper_cross_platform/src/pages/profile/stats_page.dart';


final routes = {
  '/': (context) => const InitialPage(),
  '/profile': (context) => const ProfilePage(),
  '/forum-overview': (context) => ForumOverviewPage(),
  '/problem-arena': (context) => const ProblemArenaPage(),
  '/problems-overview': (context) => const ProblemsOverviewPage(),
  '/problem-overview': (context) => const ProblemOverviewPage(),
  '/problems-discover': (context) => const ProblemsDiscoverPage(),
  '/contest-overview': (context) => const ContestOverviewPage(),
  '/contests-discover': (context) => const ContestsDiscoverPage(),
  '/stats': (context) => const StatsPage(),
  '/saved': (context) => const SavedPage(),
  '/settings': (context) => const SettingsPage(),
};
