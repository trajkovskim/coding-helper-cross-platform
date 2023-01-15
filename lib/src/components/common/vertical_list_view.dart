import 'package:flutter/material.dart';

class ListItem {
  String? title;
  String? subtitle;
  Widget? image;
  Widget trailing;
  void Function()? onTap;

  ListItem(
      {this.title,
      this.subtitle,
      this.image,
      this.onTap,
      this.trailing = const Icon(Icons.arrow_forward_ios)});
}

class VerticalListView extends StatelessWidget {
  final List<ListItem> children;

  const VerticalListView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      child: Column(
        children: children
            .map(
              (item) => [
                InkWell(
                  onTap: item.onTap,
                  child: ListTile(
                    leading: item.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: item.image,
                          )
                        : null,
                    title: item.title != null ? Text(item.title!) : null,
                    subtitle:
                        item.subtitle != null ? Text(item.subtitle!) : null,
                    trailing: item.trailing,
                  ),
                ),
                const Divider(
                  color: Colors.black,
                )
              ],
            )
            .expand((element) => element)
            .take(2 * children.length - 1)
            .toList(),
      ),
    );
  }
}
