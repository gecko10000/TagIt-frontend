import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/search.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

final searchInputProvider = StateProvider((ref) => "");

final searchResultsProvider = FutureProvider<List<SavedFileState>>((ref) async {
  String query = ref.watch(searchInputProvider);
  return SearchAPI.fileSearch(query);
});
