import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/common/code_editor.dart';
import '../../components/common/dropdown.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/codehelp/index.dart';
import 'problem_arena_page.dart';

class ProblemOverviewPage extends StatefulWidget {
  const ProblemOverviewPage({super.key});

  @override
  State<ProblemOverviewPage> createState() => _ProblemOverviewPageState();
}

class _ProblemOverviewPageState extends State<ProblemOverviewPage> {
  final ProblemsService problemsService = const ProblemsService();
  final SubmissionsService submissionsService = const SubmissionsService();

  String selectedLanguage = CodeEditor.EDITOR_LANGUAGES.keys.first;

  void handleTapStart(ProblemEntry entry) {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => const ProblemArenaPage(),
        settings: RouteSettings(
          arguments: {
            'problem': entry,
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
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'problem');

    final params =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final id = params['id'];

    GetSubmissionsRequestBuilder builder = GetSubmissionsRequestBuilder()
      ..problemId = int.parse(id!);

    return FutureBuilder(
        future: Future.wait([
          problemsService.getProblemEntry(id!),
          submissionsService.getSubmissionEntries(builder.build()),
        ]),
        builder: (context, snapshot) {
          final entry = snapshot.data?[0] as ProblemByLikes?;
          final entries = snapshot.data?[0] as List<SubmissionEntry>;

          if (snapshot.hasError) {
            throw ErrorCode.PROBLEM_OVERVIEW;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(entry?.problem.title ?? ''),
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: CustomScrollView(
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
                              shadowColor: Colors.black.withOpacity(0.65),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: const Icon(Icons.javascript,
                                              size: 64),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${t('difficulty')} ${entry?.problem.difficulty.name.toLowerCase()}'),
                                            Text('${t('duration')} ${'1h30m'}'),
                                            Text('${t('participants')} ${0}'),
                                            Text('${t('reviews')} ${0}'),
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                      entry?.problem.title ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Dropdown(
                                          value: selectedLanguage,
                                          items:
                                              CodeEditor.EDITOR_LANGUAGES.keys
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
                                          onPressed: () =>
                                              handleTapStart(entry!.problem),
                                          style: ElevatedButton.styleFrom(
                                              shadowColor: Colors.black
                                                  .withOpacity(0.25)),
                                          child: Text(t('start')),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox.fromSize(size: const Size.fromHeight(10)),
                          Card(
                            elevation: 2,
                            shadowColor: Colors.black.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t('description'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  SizedBox.fromSize(
                                      size: const Size.fromHeight(5)),
                                  Text(entry?.problem.markdown ??
                                      t('noDescription')),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(size: const Size.fromHeight(10)),
                          Expanded(
                            child: VerticalListView(
                              children: entries
                                  .map((entry) => ListItem(
                                        title: '${t('attempt')} ${entry.id}',
                                        subtitle:
                                            '${t('status')} ${entry.status.name}',
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }
}
