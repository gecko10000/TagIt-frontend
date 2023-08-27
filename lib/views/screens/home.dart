import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/views/screens/browse.dart';
import 'package:tagit_frontend/views/screens/search.dart';
import 'package:tagit_frontend/views/screens/settings.dart';
import 'package:tagit_frontend/views/screens/upload.dart';

import '../../view_models/home.dart';
import '../widgets/home_nav_bar.dart';

List<Widget> pages = [
  BrowseScreen(),
  SearchScreen(),
  UploadScreen(),
  SettingsScreen(),
];

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: pages[ref.watch(homeIndexProvider)],
      bottomNavigationBar: const HomeNavBar(),
    );
  }
}
