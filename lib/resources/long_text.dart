import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LongText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;

  const LongText({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      maxLines: 20,
      softWrap: true, // Ensures text moves to the next line
      style: GoogleFonts.poppins(
        color: color ?? theme.colorScheme.onSurface,
        fontSize: fontSize ?? 11,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
