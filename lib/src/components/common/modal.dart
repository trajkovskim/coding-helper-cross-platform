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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: values.entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key),
                          Dropdown(
                            value: entry.value,
                            items: widget.options[entry.key]!
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
        showOptionsDropdown
            ? Dropdown(
                items: widget.options.keys
                    .map((option) => DropdownItem(option, option))
                    .toList(),
                onChange: (value) => setState(() {
                  values.putIfAbsent(value!, () => null);
                  showOptionsDropdown = false;
                }),
              )
            : IconButton(
                onPressed: () => setState(() {
                  showOptionsDropdown = true;
                }),
                icon: const Icon(Icons.add),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => navigator.pop(),
              child: Text(t('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                values.removeWhere((key, value) => value == null);
                navigator.pop(values);
              },
              child: Text(widget.submitButton),
            )
          ],
        ),
      ],
    );
    ;
  }
}
