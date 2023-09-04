import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/home/nav_bar/nav_bar_model.dart';

import '../home_model.dart';

class HomeNavBar extends ConsumerWidget {
  const HomeNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: ref.watch(homeIndexProvider),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Browse"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
      unselectedItemColor: Colors.white30,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        changeHomeIndex(ref, i);
      },
    );
  }
}
