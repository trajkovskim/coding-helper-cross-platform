import 'package:flutter_i18n/flutter_i18n.dart';

String Function(String tKey, [Map<String, String>? params]) getTranslation(
    dynamic context,
    [String key = '']) {
  return (tKey, [params]) => FlutterI18n.translate(
        context,
        'coding_helper${key.isEmpty ? '' : '.$key'}.$tKey',
        translationParams: params,
      );
}
