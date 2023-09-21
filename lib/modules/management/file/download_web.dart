import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:universal_html/html.dart';

import '../../../model/api/base.dart';

Future<void> downloadWeb(SavedFileState savedFile) async {
  final uri = url("file/${savedFile.uuid}", queryParameters: fileGetParams());
  window.open(uri.toString(), '_self');
}
