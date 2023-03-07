import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/theme.dart';
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
    navigator.pushNamed(
      '/problem-arena',
      arguments: {
        'problem': problem,
        'language': selectedLanguage,
      },
    );
  }

  void handleChangeLanguage(String? language) {
    setState(() {
      selectedLanguage = language as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'contests');
    final params = ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
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
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.25,
                          child: ShadowContainer(
                            radius: 15,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                Text('${t('duration')} ${entry?.duration}'),
                                                Text('${t('startsOn')} ${entry?.startsOn}'),
                                                Text('${t('status')} ${entry?.status}')
                                              ],
                                            )
                                          ],
                                        ),
                                        Text(entry?.name ?? ''),
                                      ],
                                    ),
                                    SizedBox.fromSize(size: const Size.fromHeight(10)),
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
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox.fromSize(size: const Size.fromHeight(15)),
                        ShadowContainer(
                          radius: 15,
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text(t('description')), Text(entry?.name ?? t('noDescription'))],
                              ),
                            ),
                          ),
                        ),
                        SizedBox.fromSize(size: const Size.fromHeight(15)),
                        entry?.status == ContestStatus.OPEN
                            ? Center(
                                child: Text(
                                  '${t('status')}: ${entry?.status}',
                                ),
                              )
                            : VerticalListView(
                                padding: EdgeInsets.zero,
                                children: entry?.problems
                                        .map(
                                          (problem) => ListItem(
                                            image: CircleAvatar(child: Text(problem.score.toString())),
                                            title: problem.problem.title,
                                            subtitle: 'Difficulty: ${problem.problem.difficulty}',
                                            onTap: () => handleTapProblem(problem.problem),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
