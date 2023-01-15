import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

import '../../components/common/code_editor.dart';
import '../../i18n/i18n.dart';
import '../../services/index.dart';

class ProblemArenaPage extends StatelessWidget {
  final CodeController codeController = CodeController();

  ProblemArenaPage({super.key});

  void handleSubmit() {
    // TODO 195063 2023-01-08: use service to submit
  }

  void handleTest() {
    // TODO 195063 2023-01-08: use service to test code
  }

  @override
  Widget build(BuildContext context) {
    final params =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final language = params['language'] as String;
    final problem = params['problem'] as ProblemEntry?;

    final t = getTranslation(context, 'problem');

    codeController.language = CodeEditor.EDITOR_LANGUAGES[language];

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(problem?.title ?? ''),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(t('description')),
              ),
              Tab(
                child: Text(t('editor')),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Card(
              elevation: 200,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  // TODO 195063 2023-01-08: parse markdown ??
                  child: Text(problem?.markdown ?? ''),
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}
