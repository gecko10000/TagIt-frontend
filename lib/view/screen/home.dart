import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/view/screen/browse.dart';
import 'package:tagit_frontend/view/screen/search.dart';
import 'package:tagit_frontend/view/screen/settings.dart';
import 'package:tagit_frontend/view/screen/upload.dart';

import '../../view_model/home.dart';
import '../widget/home_nav_bar.dart';

List<Widget> pages = [
  const BrowseScreen(tagName: ""),
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
