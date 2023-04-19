import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/objects/saved_file.dart';
import 'package:tagit_frontend/requests.dart';

class FileBrowser extends ConsumerStatefulWidget {
  const FileBrowser({super.key});

  @override
  ConsumerState createState() => _FileBrowserState();

}

class _FileBrowserState extends ConsumerState<FileBrowser> with AutomaticKeepAliveClientMixin {

  List<SavedFile>? files;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return files?.isEmpty ?? true ?
    Align(
        alignment: Alignment.center,
        child: files == null ?
        const CircularProgressIndicator() :
        const Text("Nothing here.",
          style: TextStyle(fontSize: 32),
        )
    ) :
    ListView.builder(
      itemCount: files?.length,
      itemBuilder: (context, i) => files?[i].createTile(context: context, refreshCallback: _loadFiles),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadFiles() async {
    try {
      final retrieved = await getAllFiles();
      setState(() => files = retrieved);
    } catch (error, t) {
      print("ERROR: $error");
      print(t);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

}
