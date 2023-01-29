import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';

class CodeTestInputModal extends StatefulWidget {
  final String? initValue;

  const CodeTestInputModal({super.key, this.initValue});

  @override
  State<CodeTestInputModal> createState() => _CodeTestInputModalState();
}

class _CodeTestInputModalState extends State<CodeTestInputModal> {
  final inputController = TextEditingController();

  @override
  void initState() {
    inputController.text = widget.initValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final t = getTranslation(context, 'modal');
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInsets),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            minLines: 1,
            maxLines: 4,
            controller: inputController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => navigator.pop(inputController.text),
                child: Text(t('submit')),
              ),
              TextButton(
                onPressed: () => navigator.pop(),
                child: Text(t('cancel')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
