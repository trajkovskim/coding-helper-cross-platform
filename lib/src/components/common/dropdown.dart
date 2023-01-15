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
    return DropdownButton(
      value: value,
      onChanged: onChange,
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item.value,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 100),
                child: Text(item.label),
              ),
            ),
          )
          .toList(),
    );
  }
}
