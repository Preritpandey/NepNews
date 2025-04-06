import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;

  const AppText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: GoogleFonts.poppins(
        color: color ?? theme.colorScheme.onSurface,
        fontSize: fontSize ?? 12,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
