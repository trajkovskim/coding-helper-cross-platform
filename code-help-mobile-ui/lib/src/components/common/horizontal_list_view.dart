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
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  child: InkWell(
                                    onTap: item.onTap,
                                    child: GridTile(
                                      key: item.key,
                                      footer: item.title != null ? Column(
                                        children: [
                                          Center(child: Text(item.title!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall)),
                                          SizedBox(height: 3)
                                        ],
                                      ) : null,
                                      child: Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Padding(
                                              padding: EdgeInsets.all(23),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: const Icon(Icons.hourglass_empty_rounded),
                                              )
                                          )
                                      ),
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
