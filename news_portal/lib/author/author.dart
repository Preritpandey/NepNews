import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Home/home.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/controllers/news_post_controller.dart';
import 'package:news_portal/pages/Profile/profile_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => Get.to(const Home()),
            child: AppText(text: "Readers mode")
          )
        ],
        leading: IconButton(
          onPressed: () {
            Get.to(ProfilePage());
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
              
              // Title Field
              TextField(
                controller: newsPostController.titleController,
                decoration: const InputDecoration(
                  labelText: "News Title", 
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 16),
              
              // Content Field
              TextField(
                controller: newsPostController.contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "News Content",
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 16),
              
              // Category Field
              TextField(
                controller: newsPostController.categoryController,
                decoration: const InputDecoration(
                  labelText: "Category", 
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 16),
              
              // Keywords Field
              TextField(
                controller: newsPostController.keywordsController,
                decoration: const InputDecoration(
                  labelText: "Keywords (e.g., AI, Technology)", 
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 24),
              
              // Image Upload Section
              Obx(() => Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: newsPostController.selectedImage.value != null
                    ? Image.file(
                        newsPostController.selectedImage.value!,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 50, color: Colors.grey),
                            Text("No image selected")
                          ],
                        ),
                      ),
              )),
              const SizedBox(height: 16),
              
              // Image Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => newsPostController.pickImage(),
                  icon: Icon(Icons.upload_file),
                  label: Text("Upload Image"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Publish Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: newsPostController.isLoading.value
                      ? null
                      : () => newsPostController.postArticle(),
                  child: newsPostController.isLoading.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("Publishing..."),
                          ],
                        )
                      : Text("Publish News"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}