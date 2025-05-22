import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import 'dropdown.dart';

class Modal extends StatefulWidget {
  final String submitButton;
  final Map<String, List<String>> options;

  const Modal({super.key, required this.options, this.submitButton = 'Submit'});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  Map<String, String?> values = {};
  bool showOptionsDropdown = false;
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    final t = getTranslation(context, 'modal');

    final options = widget.options.map((key, value) => MapEntry(key, ['-', ...value]));
    widget.options.forEach((key, value) {
      values.putIfAbsent(key, () => '-');
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: values.entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key),
                          Dropdown(
                            value: entry.value,
                            items: options[entry.key]!
                                .map((value) => DropdownItem(value, value))
                                .toList(),
                            onChange: (value) => setState(() {
                              values.update(entry.key, (old) => value);
                            }),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => navigator.pop(),
              child: Text(t('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                values.removeWhere((key, value) => value == null || value == '-');
                navigator.pop(values);
              },
              child: Text(widget.submitButton),
            )
          ],
        ),
        SizedBox(height: 10)
      ],
    );
  }
}
