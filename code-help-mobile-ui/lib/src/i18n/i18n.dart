import 'package:flutter_i18n/flutter_i18n.dart';

const root = 'codehelp';

String Function(String tKey, [Map<String, String>? params]) getTranslation(
    dynamic context,
    [String key = '']) {
  return (tKey, [params]) => FlutterI18n.translate(
        context,
        '$root${key.isEmpty ? '' : '.$key'}.$tKey',
        translationParams: params,
      );
}
