import 'package:flutter/material.dart';

enum ColorSelection {
  white('White', Colors.white),
  black('Black', Colors.black);

  const ColorSelection(this.label, this.color);

  final String label;
  final Color color;
}
