import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/content_view/viewers/video_viewer_model.dart';

import '../../../model/object/dimensions.dart';

class VideoViewer extends StatefulWidget {
  final SavedFileState savedFile;

  const VideoViewer({super.key, required this.savedFile});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late final Player player = Player();
  late final VideoController controller = VideoController(player);
  bool loading = true;

  @override
  void initState() {
    super.initState();
    player.open(FileAPI.getVideo(widget.savedFile), play: true);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = widget.savedFile.dimensions;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final idealDimensions = calculateIdealDimensions(
          dimensions,
          Dimensions(
              width: constraints.maxWidth, height: constraints.maxHeight));
      return Video(
        width: idealDimensions.width,
        height: idealDimensions.height,
        controller: controller,
        controls: MaterialDesktopVideoControls,
      );
    });
  }
}
