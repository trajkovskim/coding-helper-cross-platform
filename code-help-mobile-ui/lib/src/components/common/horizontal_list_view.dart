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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Text(title!, style: const TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: items
                      .map(
                        (item) => SizedBox(
                          width: constraints.maxWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              key: item.key,
                              title: item.title != null ? Center(child: Text(item.title!, textAlign: TextAlign.center,)) : null,
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
