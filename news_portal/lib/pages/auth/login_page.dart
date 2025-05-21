import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/controllers/auth_controller.dart';
import 'package:news_portal/pages/auth/signUp_page.dart';
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const AppText(
                  text: 'Welcome back',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              const AppText(text: 'Enter your credentials', fontSize: 16),
              const SizedBox(height: 20),
              const AppText(text: 'Email'),
              Obx(() => CustomTextField(
                    controller: authController.emailController,
                    hintText: 'Enter your email',
                    isPassword: false,
                    icon: const Icon(Icons.email),
                    errorText: authController.emailError.value,
                  )),
              const SizedBox(height: 10),
              const AppText(text: 'Password'),
              Obx(() => CustomTextField(
                    controller: authController.passwordController,
                    hintText: 'Enter your password',
                    isPassword: true,
                    obscureText: authController.obscurePassword.value,
                    onToggleVisibility: () {
                      authController.obscurePassword.toggle();
                    },
                  )),
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
                        authController.validateAndLogin();
                      },
                    )),
              AppText(text: "Don't have and account?"),
              TextButton(
                  onPressed: () {
                    Get.to(SignupPage());
                  },
                  child: Text("signup"))
            ],
          ),
        ),
      ),
    );
  }
}
