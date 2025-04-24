import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Home/home.dart';
import 'package:news_portal/resources/app_text.dart';

import '../controllers/news_post_controller.dart';

class AuthorNewsPage extends StatefulWidget {
  const AuthorNewsPage({super.key});

  @override
  AuthorNewsPageState createState() => AuthorNewsPageState();
}

class AuthorNewsPageState extends State<AuthorNewsPage> {
  final ArticleController newsPostController = Get.put(ArticleController());

  final List<String> categories = [
    'Politics',
    'Sports',
    'Technology',
    'Entertainment'
  ];
  String? selectedCategory;

  void _publishNews() {
    newsPostController.postArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () => Get.to(Home()),
              child: AppText(text: "Readers mode"))
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const AppText(text: "Create News"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              ///title
              TextField(
                controller: newsPostController.titleController,
                decoration: const InputDecoration(
                    labelText: "News Title", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              //content controller
              TextField(
                controller: newsPostController.contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                    labelText: "News Description",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Category"),
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Newws summary
              TextField(
                controller: newsPostController.summaryController,
                decoration: const InputDecoration(
                    labelText: "News Summary", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: newsPostController.imageUrlController,
                decoration: const InputDecoration(
                    labelText: "Image URL", border: OutlineInputBorder()),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _publishNews,
                  child: const Text("Publish News"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
