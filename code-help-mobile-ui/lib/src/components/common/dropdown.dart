import 'package:flutter/material.dart';

class DropdownItem {
  String label;
  String value;

  DropdownItem(this.label, this.value);
}

class Dropdown extends StatelessWidget {
  final String? value;
  final List<DropdownItem> items;
  final void Function(String? value)? onChange;

  const Dropdown({super.key, this.onChange, this.value, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
            color: theme.cardColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor,
            blurRadius: 0.3,
            spreadRadius: 0.2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints.loose(const Size.fromHeight(30)),
      child: DropdownButton(
        underline: SizedBox(),
        value: value,
        onChanged: onChange,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item.value,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Text(item.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
