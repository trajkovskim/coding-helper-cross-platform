import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/common/code_editor.dart';
import '../../components/common/dropdown.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/index.dart';
import 'problem_arena_page.dart';

class ProblemOverviewPage extends StatefulWidget {
  const ProblemOverviewPage({super.key});

  @override
  State<ProblemOverviewPage> createState() => _ProblemOverviewPageState();
}

class _ProblemOverviewPageState extends State<ProblemOverviewPage> {
  final ProblemsService problemsService = const ProblemsService();
  final SubmissionsService submissionsService = const SubmissionsService();
  ProblemByLikes? entry;
  String? id;
  bool init = false;
  bool loading = false;

  String selectedLanguage = CodeEditor.EDITOR_LANGUAGES.keys.first;

  void handleTapStart() {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => const ProblemArenaPage(),
        settings: RouteSettings(
          arguments: {
            'problem': entry?.problem,
            'language': selectedLanguage,
          },
        ),
      ),
    );
  }

  void handleChangeLanguage(String? language) {
    setState(() {
      selectedLanguage = language as String;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      return;
    }

    setState(() {
      loading = true;
    });

    final params =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    id = params['id'];

    if (id == null) {
      throw Error();
    }

    final submissionsContext = Provider.of<SubmissionsContext>(context);

    GetSubmissionsRequestBuilder builder = GetSubmissionsRequestBuilder()
      ..problemId = int.parse(id!);

    Future.wait([
      problemsService
          .getProblemEntry(id!)
          .then((entry) => setState(() {
                this.entry = entry;
              }))
          .onError(
            (error, stackTrace) => handleError(context, ErrorCode.PROBLEMS),
          ),
      submissionsService
          .getSubmissionEntries(builder.build())
          .then(submissionsContext.setSubmissions)
          .onError(
            (error, stackTrace) => handleError(context, ErrorCode.PROBLEMS),
          )
    ]).whenComplete(
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
    final t = getTranslation(context, 'problem');
    final submissionsContext = Provider.of<SubmissionsContext>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(entry?.problem.title ?? ''),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (loading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.25,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Icon(Icons.abc, size: 64),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${t('difficulty')} ${entry?.problem.difficulty.name}',
                                    ),
                                    Text('${t('duration')} ${'1h30m'}'),
                                    Text('${t('participants')} ${0}'),
                                    Text('${t('reviews')} ${0}'),
                                  ],
                                )
                              ],
                            ),
                            Text(entry?.problem.title ?? ''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Dropdown(
                                  value: selectedLanguage,
                                  items: CodeEditor.EDITOR_LANGUAGES.keys
                                      .map(
                                        (language) => DropdownItem(
                                          language,
                                          language,
                                        ),
                                      )
                                      .toList(),
                                  onChange: handleChangeLanguage,
                                ),
                                ElevatedButton(
                                  onPressed: handleTapStart,
                                  child: Text(t('start')),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t('description')),
                          Text(entry?.problem.markdown ?? t('noDescription'))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: VerticalListView(
                      children: submissionsContext.entries.map((entry) => ListItem(
                          title: '${t('attempt')} ${entry.id}',
                          subtitle: '${t('status')} ${entry.status.name}',
                        )).toList()
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
