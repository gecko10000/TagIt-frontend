import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_model.dart';
import 'nav_bar/nav_bar.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(pageProvider),
      bottomNavigationBar: const HomeNavBar(),
    );
  }
}
