// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/get_article_controller.dart';

// class ConnectivityStatusBar extends StatelessWidget {
//   const ConnectivityStatusBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<GetArticleController>();
    
//     return Obx(() {
//       // Only show when offline
//       if (controller.isOnline.value) {
//         return const SizedBox.shrink();
//       }
      
//       // Get the last fetch time
//       final lastFetch = controller.getLastFetchTime();
//       final lastFetchText = lastFetch != null
//           ? 'Last updated: ${_formatTimestamp(lastFetch)}'
//           : 'Using cached data';
      
//       return Container(
//         color: Colors.amber.shade100,
//         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//         child: Row(
//           children: [
//             const Icon(Icons.wifi_off, size: 16, color: Colors.amber),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'You\'re offline',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     lastFetchText,
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             TextButton(
//               onPressed: () => controller.refreshArticles(),
//               child: const Text('RETRY'),
//             ),
//           ],
//         ),
//       );
//     });
//   }
  
//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);
    
//     if (difference.inMinutes < 1) {
//       return 'just now';
//     } else if (difference.inMinutes < 60) {
//       return '${difference.inMinutes} minutes ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours} hours ago';
//     } else {
//       return '${difference.inDays} days ago';
//     }
//   }
// }