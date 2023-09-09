import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../browse/screen/browser_model.dart';
import '../home_model.dart';

const _browseIndex = 0;

void changeHomeIndex(WidgetRef ref, int i) {
  ref.read(homeIndexProvider.notifier).state = i;
  // refresh list
  if (i == _browseIndex) {
    ref.invalidate(browseListProvider(""));
  }
}
