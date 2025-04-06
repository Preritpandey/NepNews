import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/controllers/auth_controller.dart';

import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/widgets/button.dart';
import 'package:news_portal/widgets/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(
                  text: 'Welcome back',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              AppText(text: 'Enter your credentials', fontSize: 16),
              const SizedBox(height: 20),
              AppText(text: 'Email'),
              CustomTextField(
                controller: authController.emailController,
                hintText: 'Enter your email',
                isPassword: false,
                icon: const Icon(Icons.email),
              ),
              const SizedBox(height: 10),
              AppText(text: 'Password'),
              CustomTextField(
                controller: authController.passwordController,
                hintText: 'Enter your password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: authController.rememberMe.value,
                        onChanged: (value) {
                          authController.rememberMe.value = value!;
                        },
                      )),
                  const Text('Remember me'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() => authController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                      buttonWidth: double.maxFinite,
                      buttonText: 'Login',
                      buttonColor: appOrange,
                      onTap: () {
                        authController.login();
                      },
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
