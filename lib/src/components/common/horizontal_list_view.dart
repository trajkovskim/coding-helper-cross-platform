import 'package:flutter/material.dart';

class Item {
  Key? key;
  void Function()? onTap;

  Item({this.key, this.onTap});
}

class HorizontalListView extends StatelessWidget {
  final String? title;
  final List<Item> items;

  const HorizontalListView({super.key, required this.items, this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title!),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: items
                        .map(
                          (item) => SizedBox(
                            width: constraints.maxWidth * 0.2,
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                key: item.key,
                                title: const Text('title'),
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
      }
    );
  }
}
