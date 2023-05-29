import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';

class Settings {
  static const String _downloadPathKey = "downloadPath";
  static String? get downloadPath => box.get(_downloadPathKey);
  static final Box box = Hive.box("settings");

  static Future<String?> chooseDownloadPath() async {
    String? path = await FilePicker.platform.getDirectoryPath(dialogTitle: "Choose Download Path");
    if (path != null) await box.put(_downloadPathKey, path);
    return path;
  }
}
