import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/screens/search.dart';
import 'package:tagit_frontend/widgets/browsers/file_browser.dart';
import 'package:tagit_frontend/widgets/browsers/tag_browser.dart';

import '../screens/account.dart';
import '../screens/not_implemented.dart';
import '../screens/upload.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backend = ref.watch(backendProvider).value;
    return Drawer(
        child: ValueListenableBuilder<Box>(
            valueListenable: Hive.box("account").listenable(),
            builder: (context, box, widget) {
              final host = box.get("host");
              return ListView(
                children: [
                  DrawerHeader(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text("TagIt", style: TextStyle(fontSize: 36)),
                        const SizedBox(height: 30),
                        if (host != null)
                          Text("Connected to $host",
                              style: const TextStyle(fontSize: 16),
                              maxLines: 2),
                      ])),
                  DrawerTile(Icons.tag, "Tags",
                      callback: (context) => BackScaffold(
                            body: TagBrowserNavigator(
                                scaffoldNameNotifier:
                                    backScaffoldNameProvider.notifier),
                            title: "Tags",
                          )),
                  DrawerTile(Icons.file_copy, "Files", callback: (context) {
                    return const BackScaffold(
                      body: FileBrowser(),
                      title: "Files",
                    );
                  }),
                  DrawerTile(Icons.search, "Search",
                      callback: (context) => const SearchScreen()),
                  DrawerTile(Icons.upload, "Upload",
                      callback: (context) => const UploadScreen()),
                  DrawerTile(Icons.settings, "Settings",
                      callback: (context) => const BackScaffold(
                            body: NotImplementedScreen(),
                            title: "Settings",
                          )),
                  DrawerTile(
                    Icons.account_circle,
                    "Account",
                    callback: (context) => BackScaffold(
                      body: AccountScreen(),
                      title: "Account",
                    ),
                  )
                ],
              );
            }));
  }
}

class DrawerTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final Widget? Function(BuildContext) callback;

  const DrawerTile(this.icon, this.title, {super.key, required this.callback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
        child: ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        Widget? result = callback(context);
        if (result == null) return;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => result));
      },
    ));
  }
}
