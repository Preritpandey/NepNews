import 'package:flutter/material.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/widgets/opaque_bg_icon.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const OpaqueBgIcon(icon: Icons.arrow_back)),
      ),
      body: const Column(
        children: [Center(child: AppText(text: "This is discover more page"))],
      ),
    );
  }
}
