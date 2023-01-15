import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onClear;
  final void Function()? onSubmit;

  const SearchInput({super.key, required this.controller, this.onClear, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final tListOptions = getTranslation(context, 'listOptions');

    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        onSubmitted: (value) => onSubmit != null ? onSubmit!() : null,
        decoration: InputDecoration(
          hintText: tListOptions('search'),
          suffixIcon: IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.clear),
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 5, color: Colors.black),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
