import 'package:flutter/material.dart';

class GridTileBarCorners extends StatelessWidget {
  late final Widget leading, trailing;

  GridTileBarCorners({Widget? leading, Widget? trailing, super.key}) {
    this.leading = leading ?? const SizedBox.shrink();
    this.trailing = trailing ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return GridTileBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Flexible(child: leading), trailing],
      ),
    );
  }
}
