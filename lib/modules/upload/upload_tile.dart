import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/file_upload.dart';
import 'package:tagit_frontend/modules/browse/browser_model.dart';
import 'package:tagit_frontend/modules/content_view/content_view_model.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';
import 'package:tagit_frontend/modules/upload/upload_model.dart';

import '../../model/object/saved_file.dart';

class UploadTile extends ConsumerStatefulWidget {
  final FileUpload upload;

  const UploadTile(this.upload, {super.key});

  @override
  ConsumerState<UploadTile> createState() => _UploadTileState();
}

class _UploadTileState extends ConsumerState<UploadTile> {
  Widget progressBar(Stream<int> stream, int fileSize) {
    return StreamBuilder(
        stream: stream,
        initialData: 0,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Tooltip(
                message: snapshot.error.toString(),
                child: const Icon(Icons.error, color: Colors.red));
          }
          final data = snapshot.requireData;
          // upload is done, request processing
          if (data == fileSize) {
            return const CircularProgressIndicator(color: Colors.green);
          }
          // If no progress, upload hasn't started yet
          // Therefore, we display the spinning progress indicator
          final progress = data == 0 ? null : data / fileSize;
          return CircularProgressIndicator(value: progress);
        });
  }

  String _readableErrorMessage(Exception ex) {
    if (ex is DioException) {
      if (ex.type != DioExceptionType.unknown && ex.message != null) {
        return ex.message!;
      }
      return ex.message ??
          ex.error?.toString() ??
          "Unknown error: ${ex.stackTrace.toString()}";
    }
    return ex.toString();
  }

  Widget leading(AsyncValue<SavedFileState?> savedFile) {
    final stream = widget.upload.stream;
    if (stream == null) {
      return const Tooltip(
          message: "File already exists.",
          child: Icon(Icons.error, color: Colors.red));
    }
    return savedFile.when(
        data: (data) => const Icon(Icons.check_circle, color: Colors.green),
        error: (ex, st) {
          return Tooltip(
            message:
                ex is Exception ? _readableErrorMessage(ex) : ex.toString(),
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
        loading: () => progressBar(stream, widget.upload.platformFile.size));
  }

  Widget? trailing(AsyncValue<SavedFileState?> savedFile) {
    return savedFile.when(
        data: (file) {
          if (file == null) return null;
          final updatedFile = ref.watch(savedFileProvider(file.uuid));
          return TextButton.icon(
              onPressed: () => openSavedFileTags(context, file),
              icon: const Icon(Icons.sell),
              label: Text(
                  (updatedFile.valueOrNull ?? file).tags.length.toString()));
        },
        error: (_, __) => null,
        loading: () => IconButton(
            onPressed: () => widget.upload.cancelToken?.cancel(),
            icon: const Icon(Icons.close)));
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.upload.platformFile;
    final uploadUuid = widget.upload.uuid;
    final savedFile = ref.watch(uploadedFileProvider(uploadUuid));
    return Dismissible(
        key: Key(uploadUuid.uuid),
        onDismissed: (_) {
          ref.read(uploadsProvider.notifier).removeByUuid(uploadUuid);
        },
        child: ListTile(
          title: Text(file.name),
          leading: leading(savedFile),
          trailing: trailing(savedFile),
          onTap: !savedFile.hasValue || savedFile.value == null
              ? null
              : () async {
                  final actualFile = savedFile.value!;
                  openContentView(context, actualFile);
                },
        ));
  }
}
