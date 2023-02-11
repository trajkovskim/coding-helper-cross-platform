import 'package:flutter/material.dart';

class Item {
  Key? key;
  String? title;
  void Function()? onTap;

  Item({this.key, this.title, this.onTap});
}

class HorizontalListView extends StatelessWidget {
  final String? title;
  final List<Item> items;

  const HorizontalListView({super.key, required this.items, this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Text(title!),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: items
                      .map(
                        (item) => SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              key: item.key,
                              title: item.title != null ? Center(child: Text(item.title!, textAlign: TextAlign.center,)) : null,
                              onTap: item.onTap,
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
