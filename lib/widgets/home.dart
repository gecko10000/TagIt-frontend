import 'package:flutter/material.dart';
import 'package:tagit_frontend/widgets/file_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // custom name set on the backend? make this stateful?
          // if date is april 1, TaGit?
          title: const Text("TagIt"),
        ),
        drawer: const SideDrawer(),
        body: const FileListView()
    );
  }
}

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: const [
            DrawerTile(Icons.file_copy, "Files", "/"),
            DrawerTile(Icons.tag, "Tags", "/tags"),
            DrawerTile(Icons.search, "Search", "/search")
          ],
        )
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String destination;

  const DrawerTile(this.icon, this.title, this.destination, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Navigator.pushReplacementNamed(context, destination),
    );
  }
}
