import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_model.dart';
import 'nav_bar/nav_bar.dart';

late BuildContext homeContext;

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    homeContext = context;
    return Scaffold(
      body: SafeArea(child: ref.watch(pageProvider)),
      bottomNavigationBar: const HomeNavBar(),
    );
  }
}
