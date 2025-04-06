import 'package:flutter/material.dart';
import 'package:news_portal/widgets/custom_textfield.dart';

class LoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFields(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          hintText: 'email',
          icon: const Icon(Icons.email),
          isPassword: false,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: passwordController,
          hintText: 'password',
          icon: const Icon(Icons.email),
          isPassword: true,
        )
      ],
    );
  }
}
