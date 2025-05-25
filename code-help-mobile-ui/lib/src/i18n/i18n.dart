import 'package:flutter_i18n/flutter_i18n.dart';

const root = 'codehelp';

String Function(String tKey, [Map<String, String>? params]) getTranslation(
    dynamic context,
    [String key = '']) {
  return (tKey, [params]) {
    final fullKey = '$root${key.isEmpty ? '' : '.$key'}.$tKey';

    final translated = FlutterI18n.translate(
      context,
      fullKey,
      translationParams: params,
    );

    if (translated == fullKey) {
      return tKey;
    }

    return translated;
  };
}
