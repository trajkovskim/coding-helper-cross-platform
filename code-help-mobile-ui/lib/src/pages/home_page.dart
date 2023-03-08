import 'package:coding_helper_cross_platform/src/components/common/horizontal_list_view.dart';
import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/services/codehelp/index.dart';
import 'package:flutter/material.dart';

import '../i18n/i18n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final ContestsService contestsService = const ContestsService();
  final ProblemsService problemsService = const ProblemsService();

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'home');
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.20,
                  child: FutureBuilder(
                    future: contestsService.getContestEntries(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        throw ErrorCode.HOME;
                      }

                      if (!snapshot.hasData) {
                        return const Card(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                      final entries = snapshot.data!;

                      return HorizontalListView(
                        title: t('activeContests'),
                        items: entries
                            .map(
                              (entry) => Item(
                                onTap: () => navigator.pushNamed(
                                  '/contest-overview',
                                  arguments: {'id': entry.id.toString()},
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: constraints.maxHeight * 0.20,
                  child: FutureBuilder(
                    future: problemsService.getTop10ProblemEntries(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        throw ErrorCode.HOME;
                      }

                      if (!snapshot.hasData) {
                        return const Card(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                      final entries = snapshot.data!;

                      return HorizontalListView(
                        title: t('top10Problems'),
                        items: entries
                            .map(
                              (entry) => Item(
                                onTap: () => navigator.pushNamed(
                                  '/problem-overview',
                                  arguments: {'id': entry.id.toString()},
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
