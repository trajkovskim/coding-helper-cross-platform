import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/common/floating_tile.dart';
import '../../components/common/horizontal_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/index.dart';

class ProblemsOverviewPage extends StatefulWidget {
  const ProblemsOverviewPage({super.key});

  @override
  State<ProblemsOverviewPage> createState() => _ProblemsOverviewPageState();
}

class _ProblemsOverviewPageState extends State<ProblemsOverviewPage> {
  final ProblemsService problemsService = const ProblemsService();
  bool loading = false;
  bool init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted) {
      return;
    }
    if (init) {
      return;
    }
    setState(() {
      loading = true;
    });
    final problemsContext =
        Provider.of<ProblemsContext>(context, listen: false);

    problemsService
        .getProblemEntries()
        .then((value) => problemsContext.setProblems(value))
        .onError(
          (error, stackTrace) => handleError(context, ErrorCode.PROBLEMS),
        )
        .whenComplete(
      () {
        init = true;
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final problemsContext = Provider.of<ProblemsContext>(context);
    final problems = problemsContext.entries;

    final t = getTranslation(context, 'problems');

    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (loading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return SingleChildScrollView(
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
                      image: const Icon(Icons.abc, size: 64),
                      onTap: () => navigator.pushNamed('/problems-discover'),
                    ),
                    FloatingTile(
                      title: t('contests.title'),
                      image: const Icon(Icons.abc, size: 64),
                      onTap: () => navigator.pushNamed('/problems-discover'),
                    ),
                    FloatingTile(
                      title: t('discover.title'),
                      image: const Icon(Icons.abc, size: 64),
                      onTap: () => navigator.pushNamed('/problems-discover'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.35,
                child: HorizontalListView(
                  items: problems
                      .map(
                        (entry) => Item(
                          onTap: () {
                            navigator.pushNamed(
                              '/problem-overview',
                              arguments: {'id': entry.id},
                            );
                          },
                        ),
                      )
                      .toList(),
                  title: t('active'),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.35,
                child: HorizontalListView(
                  items: problems
                      .map(
                        (entry) => Item(
                          onTap: () {
                            navigator.pushNamed(
                              '/problem-overview',
                              arguments: {'id': entry.id},
                            );
                          },
                        ),
                      )
                      .toList(),
                  title: t('recommended'),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.35,
                child: HorizontalListView(
                  items: problems
                      .map(
                        (entry) => Item(
                          onTap: () {
                            navigator.pushNamed(
                              '/problem-overview',
                              arguments: {'id': entry.id},
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
        );
      }),
    );
  }
}
