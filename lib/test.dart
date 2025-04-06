import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controllers/ads_controller.dart';
import 'models/ads_data_model.dart';

class AdsScreen extends StatelessWidget {
  // Initialize the controller directly in the widget
  final AdController adController = Get.put(AdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Obx(() {
        // Show loading indicator while fetching data
        if (adController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message if there's an error
        if (adController.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${adController.errorMessage.value}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => adController.fetchAds(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Show message if no ads are available
        if (adController.ads.isEmpty) {
          return const Center(child: Text('No ads available'));
        }

        // Display ads in a grid view
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: adController.ads.length,
            itemBuilder: (context, index) {
              return buildAdCard(adController.ads[index]);
            },
          ),
        );
      }),
    );
  }

  // Ad card widget
  Widget buildAdCard(AdModel ad) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _launchUrl(ad.url),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ad image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                ad.avatar,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    alignment: Alignment.center,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),

            // Ad details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ad.placement,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Launch URL function
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not launch $url',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
