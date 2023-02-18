import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final int? maxLength;

  const CustomText(this.text, {super.key, this.maxLength});

  @override
  Widget build(BuildContext context) {
    if (maxLength == null) {
      return Text(text);
    }

    return Text(
      text.length < maxLength! ? text : '${text.substring(0, 100)}...',
    );
  }
}
