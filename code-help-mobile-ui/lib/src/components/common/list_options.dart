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
  return value;
}

class ListOptions extends StatelessWidget {
  final List<String> options;
  final void Function(String option)? onRemove;

  const ListOptions({super.key, required this.options, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'listOptions');

    int index = 0;

    if (options.isNotEmpty) {
      return Container(
        constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: -4,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Card(
          shadowColor: Colors.transparent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: options.isEmpty
                  ? Text(t('optionsPlaceholder'))
                  : Wrap(
                      direction: Axis.horizontal,
                      children: options
                          .map(
                            (option) => ClosingButton(
                              label: option,
                              onTap: () => onRemove != null ? onRemove!(option) : null,
                            ),
                          )
                          .toList(),
                    ),
            ),
          ),
        ),
      );
    }

    return Container();
  }
}
