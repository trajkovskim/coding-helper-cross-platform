import 'package:flutter/material.dart';

class FloatingTile extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final Widget? image;
  final EdgeInsets padding;

  const FloatingTile({
    super.key,
    this.onTap,
    required this.title,
    required this.image,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: Colors.black.withOpacity(0.85),
              elevation: 2,
              child: Center(
                child: Padding(
                  padding: padding,
                  child: image,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(title)
        ],
      ),
    );
  }
}
