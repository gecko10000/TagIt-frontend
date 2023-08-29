import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/view_models/browse.dart';

import '../../view_models/home.dart';

class HomeNavBar extends ConsumerWidget {
  const HomeNavBar({super.key});

  static const _browseIndex = 0;

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
        ref.read(homeIndexProvider.notifier).set(i);
        // refresh list
        if (i == _browseIndex) {
          ref.invalidate(browseListProvider(null));
        }
      },
    );
  }
}
