import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_nav_bar.g.dart';

@riverpod
class HomeIndex extends _$HomeIndex {
  @override
  int build() => 0;

  void set(int i) => state = i;
}

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
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      onTap: (i) => ref.read(homeIndexProvider.notifier).set(i),
    );
  }
}
