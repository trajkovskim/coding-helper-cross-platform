import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import 'closing_button.dart';

enum Command {
  SEARCH('search'),
  FILTER('filter'),
  SORT('sort');

  final String value;
  const Command(this.value);
}

String createCommand(Command command, String value) {
  return '${command.value}: $value';
}

class ListOptions extends StatelessWidget {
  final List<String> options;
  final void Function(int index)? onRemove;

  const ListOptions({super.key, required this.options, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'listOptions');

    int index = 0;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
      child: Card(
        elevation: 2,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: options.isEmpty
                ? Text(t('optionsPlaceholder'))
                : Wrap(
                    direction: Axis.horizontal,
                    children: (() => options
                        .map(
                          (option) => ClosingButton(
                            label: option,
                            onTap: () =>
                                onRemove != null ? onRemove!(index++) : null,
                          ),
                        )
                        .toList())(),
                  ),
          ),
        ),
      ),
    );
  }
}
