import 'package:flutter/cupertino.dart';

abstract class Tileable {
  Widget createTile({required BuildContext context, void Function()? refreshCallback});
}
