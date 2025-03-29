import 'package:flutter/material.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/widgets/button.dart';
import 'package:news_portal/widgets/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap Column with ScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(text: 'Welcome back'),
              AppText(text: 'Enter your credentials'),
              const SizedBox(height: 10),
              AppText(text: 'Email'),
              CustomTextField(
                controller: emailController,
                hintText: 'email',
                isPassword: false,
                icon: const Icon(Icons.email),
              ),
              const SizedBox(height: 10),
              AppText(text: 'Password'),
              CustomTextField(
                controller: passwordController,
                hintText: 'password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                  ),
                  const Text('Remember me'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppButton(
                buttonText: 'Login',
                buttonColor: appDarkBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
