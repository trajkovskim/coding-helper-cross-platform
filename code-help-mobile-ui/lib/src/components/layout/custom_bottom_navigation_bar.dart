import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int pageIndex;
  final void Function(int value) onChange;

  const CustomBottomNavigationBar(this.pageIndex, this.onChange, {super.key});

  @override
  Widget build(BuildContext context) {
    const navigationBarItemActiveColor = Colors.lightBlue;
    final t = getTranslation(context);

    return BottomNavigationBar(
      currentIndex: pageIndex,
      onTap: onChange,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.abc),
          label: t('home.title'),
          activeIcon: const Icon(
            Icons.abc,
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
