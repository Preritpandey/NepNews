import 'package:flutter/material.dart';
import 'package:news_portal/resources/constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final Icon? icon;
  final ValueNotifier<bool>? obscureTextNotifier;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.obscureTextNotifier,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextNotifier ?? ValueNotifier(true),
      builder: (context, obscureText, child) {
        return TextField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          decoration: InputDecoration(
            suffixIconColor: darkGrey,
            hintText: hintText,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      obscureTextNotifier?.value = !obscureText;
                    },
                  )
                : icon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      },
    );
  }
}
