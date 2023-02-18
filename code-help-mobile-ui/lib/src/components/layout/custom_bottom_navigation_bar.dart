import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int pageIndex;
  final void Function(int value)? onChange;

  const CustomBottomNavigationBar({super.key, required this.pageIndex, this.onChange});

  @override
  Widget build(BuildContext context) {
    const navigationBarItemActiveColor = Colors.lightBlue;
    final t = getTranslation(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: pageIndex,
      onTap: onChange,
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
