import 'package:flutter/material.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';

class AppButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final double borderRadius;
  final double textSize;
  final Color textColor;
  final double buttonWidth;
  final double buttonHeight;
  final VoidCallback? onTap;
  const AppButton({
    super.key,
    required this.buttonText,
    this.buttonColor = white,
    this.borderRadius = 6,
    this.textSize = 16,
    this.textColor = Colors.white,
    this.buttonWidth = 200,
    this.buttonHeight = 45,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(color: grey),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Center(
          child: AppText(
            text: buttonText,
            fontSize: textSize,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
