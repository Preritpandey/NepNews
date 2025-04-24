import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/controllers/signup_controller.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/widgets/button.dart';
import 'package:news_portal/widgets/custom_textfield.dart';

class SignupPage extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Create Account',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            const AppText(text: 'Fill your details below', fontSize: 16),
            const SizedBox(height: 20),
            const AppText(text: 'Name'),
            CustomTextField(
              controller: signupController.nameController,
              hintText: 'Enter your name',
              isPassword: false,
              icon: const Icon(Icons.person),
            ),
            const SizedBox(height: 10),
            const AppText(text: 'Email'),
            Obx(() => CustomTextField(
                  controller: signupController.emailController,
                  hintText: 'Enter your email',
                  isPassword: false,
                  icon: const Icon(Icons.email),
                  errorText: signupController.emailError.value,
                )),
            const SizedBox(height: 10),
            const AppText(text: 'Password'),
            Obx(() => CustomTextField(
                  controller: signupController.passwordController,
                  hintText: 'Enter your password',
                  isPassword: true,
                  obscureText: signupController.obscurePassword.value,
                  onToggleVisibility: () {
                    signupController.obscurePassword.toggle();
                  },
                )),
            const SizedBox(height: 10),
            const AppText(text: 'Role'),
            Obx(() => DropdownButton<String>(
                  isExpanded: true,
                  value: signupController.selectedRole.value,
                  items: ['author', 'editor']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.capitalizeFirst!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    signupController.selectedRole.value = value!;
                  },
                )),
            const SizedBox(height: 30),
            Obx(() => signupController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : AppButton(
                    buttonWidth: double.infinity,
                    buttonText: 'Sign Up',
                    buttonColor: appOrange,
                    onTap: () {
                      signupController.registerUser();
                    },
                  )),
          ],
        ),
      ),
    );
  }
}
