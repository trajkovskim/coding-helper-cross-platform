import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/src/mode.dart';

// editor languages
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';

// editor themes
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/dracula.dart';

class CodeEditor extends StatelessWidget {
  static final Map<String, Mode> EDITOR_LANGUAGES = {
    'javascript': javascript,
    'java': java,
    'python': python,
  };

  static final Map<String, Map<String, TextStyle>> EDITOR_THEMES = {
    'monokai-sublime': monokaiSublimeTheme,
    'dracula': draculaTheme,
  };

  final String theme;
  final CodeController controller;

  const CodeEditor({super.key, this.theme = 'dracula', required this.controller});

  @override
  Widget build(BuildContext context) {
    return CodeTheme(
      data: CodeThemeData(styles: EDITOR_THEMES[theme]),
      child: CodeField(controller: controller),
    );
  }
}
