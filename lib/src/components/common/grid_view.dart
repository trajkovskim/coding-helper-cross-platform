import 'package:flutter/material.dart';

class GridItem {
  String? title;
  String? subtitle;
  Widget? image;
  Widget trailing;
  void Function()? onTap;

  GridItem({
    this.title,
    this.subtitle,
    this.image,
    this.onTap,
    this.trailing = const Icon(Icons.arrow_forward_ios),
  });
}

class CustomGridView extends StatelessWidget {
  final List<GridItem> children;

  const CustomGridView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8,
        runSpacing: 8,
        children: children.isNotEmpty
            ? children
                .map(
                  (item) => Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: item.onTap,
                      child: SizedBox(
                        width: width * 0.43,
                        height: width * 0.43,
                        child: GridTile(
                          footer: item.title != null
                              ? Column(
                                  children: [
                                    Text(item.title!),
                                    if (item.subtitle != null)
                                      Text(item.subtitle!)
                                  ],
                                )
                              : null,
                          child: item.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: item.image,
                                )
                              : const Icon(Icons.hourglass_empty_rounded),
                        ),
                      ),
                    ),
                  ),
                )
                .toList()
            : [],
      ),
    );
  }
}
