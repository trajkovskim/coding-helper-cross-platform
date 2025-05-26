import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/components/common/text.dart';
import 'package:coding_helper_cross_platform/src/pages/problems/problem_like_button.dart';
import 'package:coding_helper_cross_platform/src/theme.dart';
import 'package:coding_helper_cross_platform/src/util.dart';
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
    navigator.pushNamed(
      '/problem-arena',
      arguments: {'problem': entry, 'language': selectedLanguage},
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
    final theme = Theme.of(context);

    final params =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final idParam = params?['id'] as String?;

    if (idParam == null) {
      throw 'id is null';
    }

    final id = int.parse(idParam);
    return FutureBuilder(
      future: Future.wait([
        problemsService.getProblemEntry(id, selectedLanguage),
        submissionsService.getSubmissionEntries(id),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw ErrorCode.PROBLEM_OVERVIEW;
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('')),
            body: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        final entry = snapshot.data![0] as ProblemEntry;
        final entries = snapshot.data![1] as List<SubmissionEntry>;
        final navigator = Navigator.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(entry.name),
            actions: [
              Row(
                children: [
                  Text(entry.likes.toString()),
                  ProblemLikeButton(id: idParam),
                ],
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.3,
                        child: ShadowContainer(
                          radius: 15,
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
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
                                        borderRadius: BorderRadius.circular(10),
                                        child: Icon(
                                          selectedLanguage == 'javascript' ? Icons.javascript :  Icons.abc,
                                          size: 64,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            entry.difficulty.name.toUpperCase(),
                                            style: theme.textTheme.bodySmall?.copyWith(
                                                color: getDifficultyColor(entry.difficulty),
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            getSubmissionStatusText(entry),
                                            style: theme.textTheme.bodySmall?.copyWith(
                                                color: getSubmissionStatusColor(entry),
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(3), child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.name,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(entry.category.name, style: theme.textTheme.bodySmall),
                                    ])
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Dropdown(
                                        value: selectedLanguage,
                                        items:
                                            entry.languages.where((language) => CodeEditor.EDITOR_LANGUAGES.containsKey(language))
                                            .map((language) => DropdownItem(language,language,))
                                            .toList(),
                                        onChange: handleChangeLanguage,
                                      ),
                                      ElevatedButton(
                                        onPressed: () => handleTapStart(entry),
                                        style: ElevatedButton.styleFrom(
                                          shadowColor: Colors.black.withOpacity(0.25),
                                        ),
                                        child: Text(t('start')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox.fromSize(size: const Size.fromHeight(10)),
                      ShadowContainer(
                        radius: 10,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.black.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t('description'),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox.fromSize(
                                  size: const Size.fromHeight(5),
                                ),
                                CustomText(
                                  entry.description ?? t('noDescription'),
                                  maxLength: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox.fromSize(size: const Size.fromHeight(10)),
                      VerticalListView(
                        children:
                            entries
                                .map(
                                  (submission) => ListItem(
                                    title: '${t('attempt')} ${submission.id}',
                                    subtitle:
                                        '${t('status')} ${submission.status.name}',
                                    onTap: () {
                                      navigator.pushNamed(
                                        '/problem-arena',
                                        arguments: {
                                          'language': submission.language,
                                          'problem': entry,
                                          'code': submission.code,
                                        },
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
