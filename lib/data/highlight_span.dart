

import 'package:flutter/material.dart';

class HighlightSpan {
  final int start;
  final int end;
  final Color color;
  final TextStyle? textStyle;

  HighlightSpan({
    required this.start,
    required this.end,
    required this.color,
    required this.textStyle,
  });

  @override
  String toString() {
    return 'HighlightSpan{start: $start, end: $end, color: $color}';
  }
}
