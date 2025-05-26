import 'package:coding_helper_cross_platform/src/components/common/horizontal_list_view.dart';
import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/services/codehelp/index.dart';
import 'package:coding_helper_cross_platform/src/services/forum/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../i18n/i18n.dart';
import 'forum/ForumCommunityPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final ContestsService contestsService = const ContestsService();
  final ProblemsService problemsService = const ProblemsService();

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'home');
    final tRoot = getTranslation(context);
    final navigator = Navigator.of(context);

    final heightFactor = 0.225;

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
                  height: constraints.maxHeight * heightFactor,
                  child: FutureBuilder(
                    future: problemsService.getCategories(),
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
                        title: t('explore'),
                        empty: tRoot('empty'),
                        items: entries
                            .map(
                              (entry) => Item(
                                title: entry.name,
                                image: Icon(Icons.abc),
                                onTap: () => navigator.pushNamed(
                                  '/problems-discover',
                                  arguments: {'category': entry.name},
                            ),
                          ),
                        ).toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: constraints.maxHeight * heightFactor,
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
                        empty: tRoot('empty'),
                        items: entries
                            .map(
                              (entry) => Item(
                                title: entry.name,
                                image: Icon(Icons.hourglass_bottom),
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
                  height: constraints.maxHeight * heightFactor,
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
                        empty: tRoot('empty'),
                        items: entries
                            .map(
                              (entry) => Item(
                                title: entry.name,
                                image: Icon(Icons.abc),
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
                const SizedBox(height: 10),
                Consumer<SharedContext>(builder: (context, value, _) {

                  if (!value.isAuthenticated) {
                    return SizedBox();
                  }

                  return SizedBox(
                    height: constraints.maxHeight * heightFactor,
                    child: FutureBuilder(
                      future: CommunityService
                          .getInstance()
                          .getAllCommunities(),
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
                          title: t('communities'),
                          items: entries.communities
                              .map(
                                (entry) =>
                                Item(
                                  title: entry.name,
                                  image: Icon(Icons.book),
                                  onTap: () =>
                                      ForumCommunityPage.navigate(context,
                                          CommunityPageArguments(
                                              communityName: entry.name)),
                                ),
                          )
                              .toList(),
                        );
                      },
                    )
                  );
                })
              ],
            ),
          ),
        );
      }),
    );
  }
}
