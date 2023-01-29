import 'package:flutter/material.dart';

class ClosingButton extends StatelessWidget {
  final String label;
  final void Function()? onTap;

  const ClosingButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 3,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const SizedBox(width: 5),
              const Icon(Icons.close),
            ],
          ),
        ),
      ),
    );
  }
}
