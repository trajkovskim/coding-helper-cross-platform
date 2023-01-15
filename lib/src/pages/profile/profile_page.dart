import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/common/user_frame.dart';
import '../../components/common/vertical_list_view.dart';
import '../../i18n/i18n.dart';

const avatarUrl =
    'https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.webp?s=612x612&w=is&k=20&c=PJjJWl0njGyow3AefY7KVNuhkbw5r2skqFiCFM5kyic=';
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

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final t = getTranslation(context, 'profile');

    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UserFrame(),
            VerticalListView(
              children: [
                ListItem(
                    title: t('stats.title'),
                    onTap: () => navigator.pushNamed('/stats')),
                ListItem(
                    title: t('saved.title'),
                    onTap: () => navigator.pushNamed('/saved')),
                ListItem(
                    title: t('history.title'),
                    onTap: () => navigator.pushNamed('/history')),
                ListItem(
                    title: t('settings.title'),
                    onTap: () => navigator.pushNamed('/settings')),
              ],
            ),
            VerticalListView(
              children: [
                ListItem(title: t('logout'), onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
