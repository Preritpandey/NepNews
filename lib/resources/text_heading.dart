import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextHeading extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final int? maxLines;

  const TextHeading({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.poppins(
        color: color ?? theme.colorScheme.onSurface,
        fontSize: fontSize ?? 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
