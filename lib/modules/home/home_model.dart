import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../browse/screen.dart';
import '../search/search.dart';
import '../settings/settings.dart';
import '../upload/upload.dart';

final homeIndexProvider = StateProvider.autoDispose((ref) => 0);

final _pages = [
  const BrowseScreen(tagId: null, tagName: null),
  const SearchScreen(),
  const UploadScreen(),
  const SettingsScreen(),
];

final pageProvider =
    StateProvider.autoDispose((ref) => _pages[ref.watch(homeIndexProvider)]);
