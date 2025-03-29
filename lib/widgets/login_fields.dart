import 'package:flutter/material.dart';
import 'package:news_portal/widgets/custom_textfield.dart';

class LoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginFields(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CustomTextField(
            controller: emailController,
            hintText: 'email',
            icon: const Icon(Icons.email),
            isPassword: false,
          ),
          SizedBox(height: 10),
          CustomTextField(
            controller: passwordController,
            hintText: 'password',
            icon: const Icon(Icons.email),
            isPassword: true,
          )
        ],
      ),
    );
  }
}
