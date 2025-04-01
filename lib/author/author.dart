import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:news_portal/controllers/news_post_service.dart';

class AuthorNewsPage extends StatefulWidget {
  @override
  _AuthorNewsPageState createState() => _AuthorNewsPageState();
}

class _AuthorNewsPageState extends State<AuthorNewsPage> {
  final NewsPostController newsPostController = Get.put(NewsPostController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<String> categories = [
    'Politics',
    'Sports',
    'Technology',
    'Entertainment'
  ];
  String? selectedCategory;
  // File? _image;

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  void _publishNews() {
    // if (titleController.text.isEmpty ||
    //     descriptionController.text.isEmpty ||
    //     selectedCategory == null) {
    //   Get.snackbar("Error", "Please fill all fields and select an image",
    //       backgroundColor: Colors.red, colorText: Colors.white);
    //   return;
    // }
    newsPostController.postNews();
    // Submit logic here
    // Get.snackbar("Success", "News published successfully!",
    //     backgroundColor: Colors.green, colorText: Colors.white);
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
              // this will be implemented after cloudinary setup is done in backend.
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: Container(
              //     height: 200,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.grey[300],
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: _image != null
              //         ? Image.file(_image!, fit: BoxFit.cover)
              //         : Icon(Icons.camera_alt, size: 50, color: Colors.grey[700]),
              //   ),
              // ),

              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: "News Title", border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
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
                // controller: newsPostController.summaryController,
                // decoration: const InputDecoration(
                //     labelText: "News Summary", border: OutlineInputBorder()),
              ),
              TextField(
                // controller: newsPostController.imageUrlController,
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
