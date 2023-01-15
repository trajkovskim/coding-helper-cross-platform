import 'package:flutter/material.dart';

import 'custom_bottom_navigation_bar.dart';

class CodingHelperLayout extends StatefulWidget {
  final List<Widget> children;
  const CodingHelperLayout(this.children, {super.key});

  @override
  State<CodingHelperLayout> createState() => _CodingHelperLayoutState();
}

class _CodingHelperLayoutState extends State<CodingHelperLayout> {
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  int pageIndex = 0;

  void handlePageIndexChange(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: pageController,
          onPageChanged: handlePageIndexChange,
          children: () {
            int index = 0;
            return widget.children
                .map(
                  (child) => Offstage(
                    key: UniqueKey(),
                    offstage: pageIndex != index++,
                    child: child,
                  ),
                )
                .toList();
          }()),
      bottomNavigationBar: CustomBottomNavigationBar(
        pageIndex,
        (value) {
          pageController.jumpToPage(value);
          handlePageIndexChange(value);
        },
      ),
    );
  }
}
