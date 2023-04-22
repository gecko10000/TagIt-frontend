import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Tileable {
  Widget createTile({required BuildContext context, required WidgetRef ref});
}
