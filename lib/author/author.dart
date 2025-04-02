import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:news_portal/controllers/news_post_service.dart';

class AuthorNewsPage extends StatefulWidget {
  @override
  _AuthorNewsPageState createState() => _AuthorNewsPageState();
}

class _AuthorNewsPageState extends State<AuthorNewsPage> {
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
      appBar: AppBar(title: Text("Create News")),
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
                decoration: InputDecoration(
                    labelText: "News Title", border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              //content controller
              TextField(
                controller: newsPostController.contentController,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: "News Description",
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
              SizedBox(height: 20),
              // Newws summary
              TextField(
                controller: newsPostController.summaryController,
                decoration: const InputDecoration(
                    labelText: "News Summary", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: newsPostController.imageUrlController,
                decoration: const InputDecoration(
                    labelText: "Image URL", border: OutlineInputBorder()),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _publishNews,
                  child: Text("Publish News"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
