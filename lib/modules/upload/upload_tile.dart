import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/file_upload.dart';
import 'package:tagit_frontend/modules/browse/browser_model.dart';
import 'package:tagit_frontend/modules/content_view/content_view_model.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';

class UploadTile extends ConsumerStatefulWidget {
  final FileUpload upload;

  const UploadTile(this.upload, {super.key});

  @override
  ConsumerState<UploadTile> createState() => _UploadTileState();
}

class _UploadTileState extends ConsumerState<UploadTile> {
  bool tappable = false;

  Widget leading() {
    final file = widget.upload.platformFile;
    if (widget.upload.stream == null) {
      return const Tooltip(
          message: "File already exists.",
          child: Icon(Icons.error, color: Colors.red));
    }
    return StreamBuilder(
        stream: widget.upload.stream,
        initialData: 0,
        builder: (context, snapshot) {
          final error = snapshot.error;
          if (error != null) {
            return Tooltip(
                message: error.toString(),
                child: const Icon(Icons.error, color: Colors.red));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const Icon(Icons.check_circle, color: Colors.green);
          }
          // won't be null here as we handled the error case
          final data = snapshot.requireData;
          final size = file.size;
          return CircularProgressIndicator(
              value: data == 0 ? null : data / size);
        });
  }

  Widget? trailing(WidgetRef ref) {
    if (widget.upload.savedFileFuture == null) return null;
    return StreamBuilder(
        stream: widget.upload.savedFileFuture!.asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          final savedFile =
              ref.watch(savedFileProvider(snapshot.requireData.uuid));
          final cached = snapshot.requireData;
          return TextButton.icon(
              onPressed: () =>
                  openSavedFileTags(context, savedFile.valueOrNull ?? cached),
              icon: const Icon(Icons.sell),
              label: Text(
                  (savedFile.valueOrNull ?? cached).tags.length.toString()));
        });
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.upload.platformFile;
    return ListTile(
      title: Text(file.name),
      leading: leading(),
      trailing: trailing(ref),
      onTap: !tappable
          ? null
          : () async {
              final savedFile = await widget.upload.savedFileFuture!;
              if (context.mounted) openContentView(context, savedFile);
            },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.upload.savedFileFuture
        ?.whenComplete(() => setState(() => tappable = true));
  }
}
