import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/models/api/search.dart';
import 'package:tagit_frontend/models/objects/saved_file.dart';

final searchInputProvider = StateProvider((ref) => "");

final searchResultsProvider = FutureProvider<List<SavedFile>>((ref) async {
  String query = ref.watch(searchInputProvider);
  return SearchAPI.fileSearch(query);
});
