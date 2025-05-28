// import 'package:flutter/material.dart';
// import 'package:news_portal/resources/app_text.dart';
// import 'package:news_portal/resources/constant.dart';
// import 'package:news_portal/resources/text_heading.dart';

// import '../Home/home.dart';

// class OnboardingPage extends StatelessWidget {
//   const OnboardingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const TextHeading(
//               text: 'Welcome to NepNews',
//               color: darkBlue,
//               fontSize: 16,
//             ),
//             const SizedBox(height: 20),
//           const  AppText(
//               text: 'Your daily source for the latest news and updates.',
//               textAlign: TextAlign.center,
//               color: Colors.black54,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Image.asset(
//                 'assets/splash.png',
//                 height: 200,
//                 width: 200,
//               ),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//                 onPressed: () {
//                   // Navigate to the home page or next step
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             Home(), // Replace with your home page
//                       ));
//                 },
//                 child: const AppText(text: 'Get Satarted')),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/OnBoarding/onBoarding_controller.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/resources/text_heading.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: controller.skip,
                child: const AppText(text: 'Skip', color: Colors.grey),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: OnboardingController.onboardingData.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  final item = OnboardingController.onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextHeading(
                          text: item["title"]!,
                          color: darkBlue,
                          fontSize: 20,
                        ),
                        const SizedBox(height: 16),
                        AppText(
                          text: item["subtitle"]!,
                          textAlign: TextAlign.center,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 32),
                        Image.asset(
                          item["image"]!,
                          height: 220,
                          width: 220,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  OnboardingController.onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: controller.currentPage.value == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? darkBlue
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: darkBlue,
                      ),
                      child: AppText(
                        text: controller.currentPage.value ==
                                OnboardingController.onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
