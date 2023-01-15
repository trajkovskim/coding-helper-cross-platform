import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/common/user_frame.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedContext = Provider.of<SharedContext>(context);
    final userData = sharedContext.userData;

    final t = getTranslation(context, 'profile.saved');

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
                    title: 'Test project',
                    subtitle: '${t('language')}: ${'react'}',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
