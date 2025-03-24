import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/resources/constant.dart';

class TextHeading extends StatelessWidget {
  final String text;
  final double? fontSize;

  const TextHeading({
    Key? key,
    required this.text,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: TextStyle(
        color: theme.colorScheme.onBackground,
        fontSize: fontSize ?? 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
