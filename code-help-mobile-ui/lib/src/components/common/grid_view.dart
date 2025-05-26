import 'package:coding_helper_cross_platform/src/components/common/text.dart';
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
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              mainAxisExtent: constraints.maxWidth * 0.5),
          children: children.isNotEmpty
              ? children
                  .map(
                    (item) => Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 1,
                      shadowColor: theme.primaryColor,
                      child: InkWell(
                        onTap: item.onTap,
                        child: GridTile(
                          footer: item.title != null
                              ? Column(
                                  children: [
                                    Text(item.title!),
                                    if (item.subtitle != null)
                                      CustomText(
                                        item.subtitle!,
                                        maxLength: 20,
                                      ),
                                    SizedBox(height: 5),
                                  ],
                                )
                              : null,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 22),
                            child: Padding(
                              padding: EdgeInsets.all(23),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: item.image ?? const Icon(Icons.hourglass_empty_rounded),
                              )
                            )
                          )
                        ),
                      ),
                    ),
                  )
                  .toList()
              : [],
        );
      },
    );
  }
}
