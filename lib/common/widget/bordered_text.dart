import 'package:flutter/material.dart';

// https://github.com/flutter/flutter/pull/36485/files
// https://github.com/flutter/flutter/blob/b2e22d3558e8334d4427ed9b78d21a347375fad2/packages/flutter/lib/src/painting/text_style.dart#L250
class BorderedText extends StatelessWidget {
  final String data;
  final double strokeSize;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const BorderedText(this.data,
      {this.strokeSize = 3, this.overflow, this.textAlign, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(data,
            textAlign: textAlign,
            overflow: overflow,
            style: TextStyle(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = strokeSize)),
        Text(
          data,
          overflow: overflow,
          textAlign: textAlign,
        )
      ],
    );
  }
}
