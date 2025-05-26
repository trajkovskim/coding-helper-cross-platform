import 'package:coding_helper_cross_platform/src/theme.dart';
import 'package:flutter/material.dart';

import 'text.dart';

class ListItem {
  String? title;
  String? subtitle;
  Widget? subContent;
  Widget? image;
  Widget trailing;
  void Function()? onTap;

  ListItem(
      {this.title,
      this.subtitle,
      this.image,
      this.onTap,
      this.trailing = const Icon(Icons.arrow_forward_ios)});

  ListItem.withSubContent(
      {this.title,
      this.subContent,
      this.image,
      this.onTap,
      this.trailing = const Icon(Icons.arrow_forward_ios)});
}

class VerticalListView extends StatelessWidget {
  final List<ListItem> children;
  final EdgeInsets padding;

  const VerticalListView({super.key, required this.children, this.padding = const EdgeInsets.symmetric(vertical: 10)});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Container();
    }

    return ShadowContainer(
      radius: 15,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: Padding(
          padding: padding,
          child: Column(
            children: children.isNotEmpty
                ? children
                    .map(
                      (item) => [
                        InkWell(
                          key: item.title != null ? Key(item.title!) : null,
                          onTap: item.onTap,
                          child: ListTile(
                            leading: item.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: item.image,
                                  )
                                : null,
                            title: item.title != null
                                ? Text(
                                    item.title!,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : null,
                            subtitle: item.subtitle != null
                                ? CustomText(
                                    item.subtitle!,
                                    maxLength: 100,
                                  )
                                : item.subContent,
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
                    .toList()
                : [],
          ),
        ),
      ),
    );
  }
}
