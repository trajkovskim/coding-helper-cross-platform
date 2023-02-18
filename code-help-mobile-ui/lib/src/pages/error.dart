import 'package:flutter/material.dart';

import '../i18n/i18n.dart';

class Error extends StatelessWidget {
  const Error({super.key});

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context);

    return Center(
      child: Text(t('error')),
    );
  }
}
