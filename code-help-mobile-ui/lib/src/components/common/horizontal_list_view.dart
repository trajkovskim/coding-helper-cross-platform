import 'package:flutter/material.dart';

class Item {
  Key? key;
  String? title;
  Widget? image;
  void Function()? onTap;

  Item({this.key, this.title, this.image, this.onTap});
}

class HorizontalListView extends StatelessWidget {
  final String? title;
  final String? empty;
  final List<Item> items;

  const HorizontalListView({super.key, required this.items, this.title, this.empty});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: Text(title!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
              ),
              SizedBox(height: 9),
              Expanded(
                child: items.isEmpty && empty != null && empty!.isNotEmpty
                    ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(empty!)])
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: items
                            .map(
                              (item) => SizedBox(
                                width: constraints.maxWidth * 0.25,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 1,
                                  shadowColor: theme.primaryColor,
                                  child: InkWell(
                                    onTap: item.onTap,
                                    child: GridTile(
                                      key: item.key,
                                      footer: item.title != null ? Column(
                                        children: [
                                          Center(child: Text(item.title!, textAlign: TextAlign.center, style: theme.textTheme.bodySmall)),
                                          SizedBox(height: 3)
                                        ],
                                      ) : null,
                                      child: item.image != null ? Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Padding(
                                              padding: EdgeInsets.all(23),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: item.image,
                                              )
                                          )
                                      ) : SizedBox(),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
