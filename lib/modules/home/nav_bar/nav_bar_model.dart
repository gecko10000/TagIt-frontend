import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../management/tag/tag_view_model.dart';
import '../home_model.dart';

const _browseIndex = 0;

void changeHomeIndex(WidgetRef ref, int i) {
  ref.read(homeIndexProvider.notifier).state = i;
  // refresh list
  if (i == _browseIndex) {
    ref.invalidate(tagProvider(null));
  }
}
