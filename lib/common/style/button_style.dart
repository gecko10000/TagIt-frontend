import 'package:flutter/material.dart';

final Color buttonColor = Colors.white.withOpacity(0.8);
const Color hoveredButtonColor = Colors.blue;

Color _colorProperty(Set<MaterialState> states) {
  final hovered = states.contains(MaterialState.hovered);
  return hovered ? hoveredButtonColor : buttonColor;
}

ButtonStyle defaultButtonStyle() => ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith(_colorProperty));
