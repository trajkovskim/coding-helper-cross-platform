import 'package:flutter/material.dart';

class ClosingButton extends StatelessWidget {
  final String label;
  final void Function()? onTap;

  const ClosingButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 1),
              spreadRadius: -4,
              blurStyle: BlurStyle.normal),
        ],
      ),
      child: Card(
        shadowColor: Colors.transparent,
        color: const Color.fromRGBO(226, 233, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
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
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                const Icon(Icons.close),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
