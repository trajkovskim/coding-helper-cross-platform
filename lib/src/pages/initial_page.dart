import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

import '../components/common/code_editor.dart';
import '../i18n/i18n.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final CodeController codeController = CodeController(
    language: CodeEditor.EDITOR_LANGUAGES['javascript'],
  );

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'home');
    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: Center(
        child: Text(t('title')),
      ),
    );
  }
}
