import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/models/api/tags.dart';

import '../models/objects/displayable.dart';

part 'browse.g.dart';

@riverpod
Future<List<Displayable>> browseList(BrowseListRef ref) =>
    TagAPI.getChildren(null);
