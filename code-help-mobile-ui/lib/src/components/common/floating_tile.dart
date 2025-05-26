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
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: theme.primaryColor,
              elevation: 2,
              child: InkWell(
                onTap: onTap,
                child: Center(
                  child: Padding(
                    padding: padding,
                    child: image,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }
}
