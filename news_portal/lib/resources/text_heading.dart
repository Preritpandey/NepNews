import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/resources/constant.dart';

class TextHeading extends StatelessWidget {
  final double size;
  final String? text;
  final Color? color;
  final int maxLines;
  const TextHeading(
      {super.key,
      this.size = 16,
      required this.text,
      this.color = bluishGreen,
      this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        maxLines: maxLines,
        overflow: TextOverflow.visible,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: size == 24 ? fontSize24 : size,
          fontWeight: FontWeight.bold,
        ));
  }
}
