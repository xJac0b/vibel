import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

extension SongModelX on SongModel {
  String get artistName => artist == '<unknown>' ? '' : artist ?? '';
}

bool hasTextOverflow(
  String text,
  TextStyle style, {
  double minWidth = 0,
  double maxWidth = double.infinity,
  int maxLines = 1,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: minWidth, maxWidth: maxWidth);
  return textPainter.didExceedMaxLines;
}
