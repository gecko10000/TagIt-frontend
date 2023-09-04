import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:tagit_frontend/model/api/files.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

class VideoViewer extends StatefulWidget {
  final SavedFile savedFile;

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
    // TODO: calculate width and height manually because aspectRatio doesn't limit the widget size
    final aspectRatio =
        dimensions == null ? null : dimensions.width / dimensions.height;
    print("le aspect ratio: $aspectRatio");
    return Video(
      // aspectRatio: aspectRatio,
      controller: controller,
      controls: MaterialVideoControls,
    );
  }
}
