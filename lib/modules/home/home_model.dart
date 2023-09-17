import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../browse/screen.dart';
import '../search/search.dart';
import '../settings/settings.dart';
import '../upload/upload.dart';

final homeIndexProvider = StateProvider((ref) => 0);

final _pages = [
  const BrowseScreen(tagId: null, tagName: null),
  SearchScreen(),
  UploadScreen(),
  SettingsScreen(),
];

final pageProvider =
    StateProvider((ref) => _pages[ref.watch(homeIndexProvider)]);
