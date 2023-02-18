import 'package:coding_helper_cross_platform/src/components/common/horizontal_list_view.dart';
import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/services/codehelp/index.dart';
import 'package:flutter/material.dart';

import '../i18n/i18n.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  final ContestsService contestsService = const ContestsService();

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'home');
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: FutureBuilder(
          future: contestsService.getContestEntries(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              throw ErrorCode.HOME;
            }
            return LayoutBuilder(builder: (context, constraints) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              final contests = snapshot.data!;
              return Column(
                children: [
                  if (contests.isNotEmpty)
                    SizedBox(
                      height: constraints.maxHeight * 0.20,
                      child: HorizontalListView(
                        title: t('activeContests'),
                        items: contests
                            .map(
                              (contest) => Item(
                                onTap: () => navigator.pushNamed(
                                  '/contest-overview',
                                  arguments: {'id': contest.id.toString()},
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                ],
              );
            });
          }),
    );
  }
}
