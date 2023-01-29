import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/common/user_frame.dart';
import '../../i18n/i18n.dart';

const avatarUrl =
    'https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.webp?s=612x612&w=is&k=20&c=PJjJWl0njGyow3AefY7KVNuhkbw5r2skqFiCFM5kyic=';
const username = 'Username';

class StatsPage extends StatelessWidget {
  static const List<Map<String, String>> data = [
    {
      'problemsSolved': '90',
      'easy': '56',
      'medium': '23',
      'hard': '11',
    },
    {
      'coursesFinished': '90',
      'easy': '56',
      'medium': '23',
      'hard': '11',
    },
    {
      'comments': '35',
      'posts': '12',
    },
  ];

  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'profile.stats');

    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // ignore: prefer_const_constructors
          children: [
            const UserFrame(),
            ...data
                .map(
                  (m) => Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: m.entries
                            .map(
                              (entry) => [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(t(entry.key)),
                                    Text(entry.value),
                                  ],
                                ),
                                const Divider()
                              ],
                            )
                            .expand((element) => element)
                            .take(2 * m.length - 1)
                            .toList(),
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
