import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/browser.dart';

import '../screens/files.dart';

class SideDrawer extends StatelessWidget {
  
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

        child: ListView(
          children: [
            DrawerTile(Icons.file_copy, "Browse", (context) => const BrowseScreen()),
            //DrawerTile(Icons.file_copy, "Files", (context) => const FileScreen()),
            DrawerTile(Icons.search, "Search", (context) => const FileScreen()),
            DrawerTile(Icons.upload, "Upload", (context) => const FileScreen()),
            DrawerTile(Icons.settings, "Settings", (context) => const FileScreen()),
          ],
        )
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget Function(BuildContext) callback;

  const DrawerTile(this.icon, this.title, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: callback));
          },
        )
    );
  }
}
