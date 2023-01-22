import 'package:coding_helper_cross_platform/src/components/common/horizontal_list_view.dart';
import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/services/contests_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../i18n/i18n.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final ContestsService contestsService = const ContestsService();
  bool init = false;
  bool loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      return;
    }
    setState(() {
      loading = true;
    });
    final contestsContext =
        Provider.of<ContestsContext>(context, listen: false);
    contestsService
        .getContestEntries()
        .then((entries) => contestsContext.setContests(entries))
        .onError(
          (error, stackTrace) => handleError(context, ErrorCode.CONTESTS),
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
    final t = getTranslation(context, 'home');
    final contestsContext = Provider.of<ContestsContext>(context);
    final navigator = Navigator.of(context);
    final contests = contestsContext.entries;

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

        return Column(
          children: [
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
      }),
    );
  }
}
