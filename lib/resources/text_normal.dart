import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextNormal extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final int? maxLines;

  const TextNormal({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.poppins(
        color: color ?? theme.colorScheme.onSurface,
        fontSize: fontSize ?? 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
