// import 'package:flutter/material.dart';
// import 'package:news_portal/resources/app_text.dart';
// import 'package:news_portal/resources/constant.dart';
// import 'package:news_portal/widgets/button.dart';
// import 'package:news_portal/widgets/custom_textfield.dart';

// class LoginPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         // Wrap Column with ScrollView
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               AppText(text: 'Welcome back'),
//               AppText(text: 'Enter your credentials'),
//               const SizedBox(height: 10),
//               AppText(text: 'Email'),
//               CustomTextField(
//                 controller: emailController,
//                 hintText: 'email',
//                 isPassword: false,
//                 icon: const Icon(Icons.email),
//               ),
//               const SizedBox(height: 10),
//               AppText(text: 'Password'),
//               CustomTextField(
//                 controller: passwordController,
//                 hintText: 'password',
//                 isPassword: true,
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Checkbox(
//                     value: true,
//                     onChanged: (value) {},
//                   ),
//                   const Text('Remember me'),
//                   const Spacer(),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text('Forgot Password?'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               AppButton(
//                 buttonWidth: double.maxFinite,
//                 buttonText: 'Login',
//                 buttonColor: appOrange,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:news_portal/controllers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/widgets/button.dart';
import 'package:news_portal/widgets/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
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
                controller: authProvider.emailController,
                hintText: 'Enter your email',
                isPassword: false,
                icon: const Icon(Icons.email),
              ),
              const SizedBox(height: 10),
              AppText(text: 'Password'),
              CustomTextField(
                controller: authProvider.passwordController,
                hintText: 'Enter your password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: authProvider.rememberMe,
                    onChanged: (value) {
                      authProvider.toggleRememberMe();
                    },
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
              authProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                      buttonWidth: double.maxFinite,
                      buttonText: 'Login',
                      buttonColor: appOrange,
                      onTap: () {
                        authProvider.login(context);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
