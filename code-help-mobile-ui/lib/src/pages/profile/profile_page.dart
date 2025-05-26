import 'dart:convert';

import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:openid_client/openid_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_frame.dart';
import '../../components/common/vertical_list_view.dart';
import '../../i18n/i18n.dart';

const username = 'Username';

class ProfilePage extends StatelessWidget {
  static const List<Map<String, String>> data = [
    {
      'Problems solved': '90',
      'Easy': '56',
      'Medium': '23',
      'Hard': '11',
    },
    {
      'Courses finished': '90',
      'Easy': '56',
      'Medium': '23',
      'Hard': '11',
    },
    {
      'Comments': '35',
      'Posts': '12',
    },
  ];

  final authService = const AuthService();

  const ProfilePage({super.key});

  Future<void> handleLogout(SharedContext sharedContext) async {
    final storage = await SharedPreferences.getInstance();
    final userJson = jsonDecode(storage.getString('user')!);
    final user = Credential.fromJson(userJson);

    authService.logout(user.generateLogoutUrl().toString());

    storage.remove('jwttoken');
    storage.remove('user');

    sharedContext.setUserData(null, null);
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final sharedContext = Provider.of<SharedContext>(context);
    final t = getTranslation(context, 'profile');

    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UserFrame(),
            SizedBox.fromSize(size: const Size.fromHeight(10)),
            VerticalListView(
              children: [
                if (sharedContext.isAuthenticated) ListItem(
                    title: t('stats.title'),
                    onTap: () => navigator.pushNamed('/stats')),
                if (sharedContext.isAuthenticated)  ListItem(
                    title: t('saved.title'),
                    onTap: () => navigator.pushNamed('/saved')),
                if (sharedContext.isAuthenticated)  ListItem(
                    title: t('history.title'),
                    onTap: () => navigator.pushNamed('/history')),
                ListItem(
                    title: t('settings.title'),
                    onTap: () => navigator.pushNamed('/settings')),
              ],
            ),
            SizedBox.fromSize(size: const Size.fromHeight(10)),
            if (sharedContext.isAuthenticated)
              VerticalListView(
                children: [
                  ListItem(
                    title: t('logout'),
                    onTap: () => handleLogout(sharedContext),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
