import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/components/common/code_test_input_modal.dart';
import 'package:coding_helper_cross_platform/src/components/common/flash_message.dart';
import 'package:coding_helper_cross_platform/src/components/common/vertical_list_view.dart';
import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/pages/problems/problem_like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../components/common/code_editor.dart';
import '../../i18n/i18n.dart';
import '../../services/codehelp/index.dart';

class Params {
  final String? language;
  final ProblemEntry? entry;
  final String? code;

  const Params({
    required this.language,
    required this.entry,
    required this.code,
  });
}

class ProblemArenaPage extends StatefulWidget {
  const ProblemArenaPage({super.key});

  @override
  State<ProblemArenaPage> createState() => _ProblemArenaPageState();
}

class _ProblemArenaPageState extends State<ProblemArenaPage> {
  final CodeRunnerService codeRunnerService = const CodeRunnerService();
  final SubmissionsService submissionsService = const SubmissionsService();

  final CodeController codeController = CodeController();

  bool init = false;
  Key submissionsFutureKey = GlobalKey();

  Params useParams() {
    final params =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final language = params['language'] as String?;
    final entry = params['problem'] as ProblemEntry?;
    final code = params['code'] as String?;
    return Params(language: language, entry: entry, code: code);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (init) {
      return;
    }
    final params = useParams();

    codeController.language = CodeEditor.EDITOR_LANGUAGES[params.language];
    if (codeController.text.isEmpty) {
      codeController.text = params.code ?? params.entry?.starterCode ?? '';
    }

    init = true;
  }

  void handleSubmit() async {
    final params = useParams();

    $SubmissionBaseEntryBuilder builder = $SubmissionBaseEntryBuilder()
      ..code = codeController.text
      ..language = params.language;

    submissionsService.submit(params.entry!.id, builder.build()).then<void>((value) {
      createMessage(context, value.message, "info");
      setState(() {});
    }).onError(
      (error, stackTrace) => throw ErrorCode.PROBLEM_ARENA,
    );
  }

  void handleTest() async {
    final params = useParams();

    final String input = await showModalBottomSheet(
      context: context,
      builder: (context) => const CodeTestInputModal(),
    );

    CodeRunnerRequestBuilder builder = CodeRunnerRequestBuilder()
      ..code = codeController.text
      ..language = params.language
      ..input = input;

    codeRunnerService
        .runCode(params.entry!.id, builder.build())
        .then((value) => createMessage(context, value, "info"))
        .onError(
          (error, stackTrace) => throw ErrorCode.PROBLEM_ARENA,
        );
  }

  @override
  Widget build(BuildContext context) {
    final params = useParams();
    final t = getTranslation(context, 'problem');

    if (params.entry == null) {
      throw ErrorCode.PROBLEM_ARENA;
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(params.entry?.name ?? ''),
          actions: [
            Row(
              children: [
                Text(params.entry!.likes.toString()),
                ProblemLikeButton(id: params.entry!.id.toString()),
              ],
            ),

          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(t('description'),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text(t('editor'),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Tab(
                  child: Text(t('submissions'),
                      style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {},
          child: TabBarView(
            children: [
              Card(
                child: Markdown(data: params.entry?.markdown ?? ''),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CodeEditor(controller: codeController),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: handleTest,
                        child: Text(t('test')),
                      ),
                      TextButton(
                        onPressed: handleSubmit,
                        child: Text(t('submit')),
                      ),
                    ],
                  )
                ],
              ),
              FutureBuilder(
                future:
                    submissionsService.getSubmissionEntries(params.entry!.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    throw ErrorCode.PROBLEM_ARENA;
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  final entries = snapshot.data!;
                  return SingleChildScrollView(
                      child: Column(
                        children: [
                          VerticalListView(
                            children: entries
                                .map(
                                  (submission) => ListItem(
                                    title: submission.createdDate.toString(),
                                    subtitle: submission.status.name,
                                    onTap: () {
                                      codeController.language = CodeEditor.EDITOR_LANGUAGES[submission.language];
                                      codeController.fullText = submission.code;
                                      DefaultTabController.of(context)
                                          .animateTo(1);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      )
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
