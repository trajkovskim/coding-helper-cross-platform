import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/pages/problems/problem_arena_page.dart';
import 'package:flutter/material.dart';

import '../../components/common/code_editor.dart';
import '../../components/common/dropdown.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/codehelp/index.dart';

class ContestOverviewPage extends StatefulWidget {
  const ContestOverviewPage({super.key});

  @override
  State<ContestOverviewPage> createState() => _ContestOverviewPageState();
}

class _ContestOverviewPageState extends State<ContestOverviewPage> {
  final ContestsService contestsService = const ContestsService();

  String selectedLanguage = CodeEditor.EDITOR_LANGUAGES.keys.first;

  void handleTapProblem(ProblemEntry problem) {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => const ProblemArenaPage(),
        settings: RouteSettings(
          arguments: {
            'problem': problem,
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
    final t = getTranslation(context, 'contest');
    final params =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    final id = params['id'];
    return FutureBuilder(
        future: contestsService.getContestEntry(id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            throw ErrorCode.CONTESTS_OVERVIEW;
          }
          
          final entry = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(entry?.name ?? ''),
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              if (!snapshot.hasData) {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: const Icon(Icons.abc, size: 64),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${t('duration')} ${entry?.duration}'),
                                          Text(
                                              '${t('startsOn')} ${entry?.startsOn}'),
                                        ],
                                      )
                                    ],
                                  ),
                                  Text(entry?.name ?? ''),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                Text(entry?.name ?? t('noDescription'))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: VerticalListView(
                            children: entry?.problems
                                    .map(
                                      (problem) => ListItem(
                                        image: CircleAvatar(
                                            child:
                                                Text(problem.score.toString())),
                                        title: problem.problem.title,
                                        subtitle:
                                            'Difficulty: ${problem.problem.difficulty}',
                                        onTap: () =>
                                            handleTapProblem(problem.problem),
                                      ),
                                    )
                                    .toList() ??
                                [],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }
}
