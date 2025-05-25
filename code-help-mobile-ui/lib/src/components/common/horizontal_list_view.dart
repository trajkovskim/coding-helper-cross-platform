import 'package:flutter/material.dart';

class Item {
  Key? key;
  String? title;
  void Function()? onTap;

  Item({this.key, this.title, this.onTap});
}

class HorizontalListView extends StatelessWidget {
  final String? title;
  final String? empty;
  final List<Item> items;

  const HorizontalListView({super.key, required this.items, this.title, this.empty});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: Text(title!, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
              ),
              SizedBox(height: 7),
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
                                  elevation: 2,
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                                    key: item.key,
                                    title: item.title != null ? Center(child: Text(item.title!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall)) : null,
                                    onTap: item.onTap,
                                    tileColor: Colors.grey.withOpacity(0.15),
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
