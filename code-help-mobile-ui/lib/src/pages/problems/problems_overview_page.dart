import 'package:flutter/material.dart';

import '../../components/common/floating_tile.dart';
import '../../components/common/horizontal_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/codehelp/index.dart';

class ProblemsOverviewPage extends StatelessWidget {
  const ProblemsOverviewPage({super.key});

  final ProblemsService problemsService = const ProblemsService();

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    final t = getTranslation(context, 'problems');
    final tContests = getTranslation(context, 'contests');

    const listHeightFactor = 0.25;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: FutureBuilder(
        future: problemsService.getProblemEntries(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            throw ErrorCode.PROBLEMS_OVERVIEW;
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return LayoutBuilder(builder: (context, constraints) {
            final problems = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.17,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingTile(
                            title: t('recent.title'),
                            image: const Icon(Icons.calendar_today, size: 32),
                            onTap: () =>
                                navigator.pushNamed('/problems-discover'),
                          ),
                          FloatingTile(
                            title: tContests('title'),
                            image: const Icon(Icons.people, size: 32),
                            onTap: () =>
                                navigator.pushNamed('/contests-discover'),
                          ),
                          FloatingTile(
                            title: t('discover.title'),
                            image: const Icon(Icons.store, size: 32),
                            onTap: () =>
                                navigator.pushNamed('/problems-discover'),
                          ),
                        ],
                      ),
                    ),
                    if (problems.isNotEmpty)
                      SizedBox.fromSize(size: const Size.fromHeight(20)),
                    if (problems.isNotEmpty)
                      SizedBox(
                        height: constraints.maxHeight * 0.25,
                        child: HorizontalListView(
                          items: problems
                              .map(
                                (entry) => Item(
                                  onTap: () {
                                    navigator.pushNamed(
                                      '/problem-overview',
                                      arguments: {'id': entry.id.toString()},
                                    );
                                  },
                                ),
                              )
                              .toList(),
                          title: t('active'),
                        ),
                      ),
                    if (problems.isNotEmpty)
                      SizedBox.fromSize(size: const Size.fromHeight(20)),
                    if (problems.isNotEmpty)
                      SizedBox(
                        height: constraints.maxHeight * listHeightFactor,
                        child: HorizontalListView(
                          items: problems
                              .map(
                                (entry) => Item(
                                  onTap: () {
                                    navigator.pushNamed(
                                      '/problem-overview',
                                      arguments: {'id': entry.id.toString()},
                                    );
                                  },
                                ),
                              )
                              .toList(),
                          title: t('recommended'),
                        ),
                      ),
                    if (problems.isNotEmpty)
                      SizedBox.fromSize(size: const Size.fromHeight(20)),
                    if (problems.isNotEmpty)
                      SizedBox(
                        height: constraints.maxHeight * listHeightFactor,
                        child: HorizontalListView(
                          items: problems
                              .map(
                                (entry) => Item(
                                  title: entry.name,
                                  onTap: () {
                                    navigator.pushNamed(
                                      '/problem-overview',
                                      arguments: {'id': entry.id.toString()},
                                    );
                                  },
                                ),
                              )
                              .toList(),
                          title: t('recommended'),
                        ),
                      )
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
