import 'package:tagit_frontend/model/object/saved_file.dart';

enum ContentType {
  image,
  video,
  audio,
  text,
  other,
  ;

  static ContentType getType(SavedFile savedFile) {
    for (ContentType type in ContentType.values.take(4)) {
      if (savedFile.info.mimeType.startsWith(type.name)) return type;
    }
    return other;
  }
}
