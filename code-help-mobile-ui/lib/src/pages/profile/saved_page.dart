import 'package:flutter/material.dart';

import '../../components/common/vertical_list_view.dart';
import '../../i18n/i18n.dart';
import 'user_frame.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {

    final t = getTranslation(context, 'profile.saved');

    return Scaffold(
        appBar: AppBar(
          title: Text(t('title')),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const UserFrame(),
                VerticalListView(
                  children: [
                    ListItem(
                      title: 'Test project',
                      subtitle: '${t('language')}: ${'react'}',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
