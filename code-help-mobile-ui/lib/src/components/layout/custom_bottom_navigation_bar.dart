import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final void Function(int value)? onChange;

  const CustomBottomNavigationBar({super.key, this.onChange});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int pageIndex = 0;

  void handlePageIndexChange(int value) {
    if (widget.onChange != null) {
      widget.onChange!(value);
    }
    setState(() {
      pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const navigationBarItemActiveColor = Colors.lightBlue;
    final t = getTranslation(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: pageIndex,
      onTap: handlePageIndexChange,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_rounded),
          label: t('home.title'),
          activeIcon: const Icon(
            Icons.home_rounded,
            color: navigationBarItemActiveColor,
          ),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.menu_book),
          label: t('problems.title'),
          activeIcon: const Icon(
            Icons.menu_book,
            color: navigationBarItemActiveColor,
          ),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.forum),
          label: t('forum.title'),
          activeIcon: const Icon(
            Icons.forum,
            color: navigationBarItemActiveColor,
          ),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: t('profile.title'),
          activeIcon: const Icon(
            Icons.person,
            color: navigationBarItemActiveColor,
          ),
        ),
      ],
    );
  }
}
