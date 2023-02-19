import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/components/common/text.dart';
import 'package:coding_helper_cross_platform/src/pages/problems/problem_like_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/common/code_editor.dart';
import '../../components/common/dropdown.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/codehelp/index.dart';

class ProblemOverviewPage extends StatefulWidget {
  const ProblemOverviewPage({super.key});

  @override
  State<ProblemOverviewPage> createState() => _ProblemOverviewPageState();
}

class _ProblemOverviewPageState extends State<ProblemOverviewPage> {
  final ProblemsService problemsService = const ProblemsService();
  final SubmissionsService submissionsService = const SubmissionsService();
  bool init = false;
  String selectedLanguage = CodeEditor.EDITOR_LANGUAGES.keys.first;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      return;
    }
    final sharedContext = Provider.of<SharedContext>(context);
    final language = sharedContext.appSettings?.defaultLanguage;
    if (language != null) {
      selectedLanguage = language;
    }
    init = true;
  }

  void handleTapStart(ProblemEntry entry) {
    final navigator = Navigator.of(context);
    navigator.pushNamed('/problem-arena', arguments: {
      'problem': entry,
      'language': selectedLanguage,
    });
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
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final id = params?['id'] as String?;

    if (id == null) {
      throw 'id is null';
    }

    GetSubmissionsRequestBuilder builder = GetSubmissionsRequestBuilder()
      ..problemId = int.parse(id);

    return FutureBuilder(
        future: Future.wait([
          problemsService.getProblemEntry(id),
          submissionsService.getSubmissionEntries(builder.build()),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            throw ErrorCode.PROBLEM_OVERVIEW;
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          final entry = snapshot.data![0] as ProblemByLikes;
          final entries = snapshot.data![1] as List<SubmissionEntry>;
          final navigator = Navigator.of(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(entry.problem.title),
              actions: [
                ProblemLikeButton(id: id)
              ],
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.3,
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
                                          child: const Icon(
                                            Icons.javascript,
                                            size: 64,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${t('difficulty')} ${entry.problem.difficulty.name.toLowerCase()}'),
                                            Text('${t('duration')} ${'1h30m'}'),
                                            Text('${t('participants')} ${0}'),
                                            Text('${t('reviews')} ${0}'),
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                      entry.problem.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
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
                                              handleTapStart(entry.problem),
                                          style: ElevatedButton.styleFrom(
                                            shadowColor:
                                                Colors.black.withOpacity(0.25),
                                          ),
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
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox.fromSize(
                                      size: const Size.fromHeight(5)),
                                  CustomText(
                                    entry.problem.markdown ??
                                        t('noDescription'),
                                    maxLength: 100,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(size: const Size.fromHeight(10)),
                          Expanded(
                            child: VerticalListView(
                              children: entries
                                  .map((submission) => ListItem(
                                        title:
                                            '${t('attempt')} ${submission.id}',
                                        subtitle:
                                            '${t('status')} ${submission.status.name}',
                                        onTap: () {
                                          navigator.pushNamed(
                                            '/problem-arena',
                                            arguments: {
                                              'language': submission.language,
                                              'problem': entry.problem,
                                              'code': submission.code
                                            },
                                          );
                                        },
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
