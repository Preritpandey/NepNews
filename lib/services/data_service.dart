// import 'dart:isolate';
// import 'package:get/get.dart';

// class DataService extends GetxService {
//   Future<DataService> init() async {
//     return this;
//   }

//   Future<List<dynamic>> loadDataInIsolate(String dataType) async {
//     final receivePort = ReceivePort();

//     await Isolate.spawn(computeDataLoad, {
//       'sendPort': receivePort.sendPort,
//       'dataType': dataType,
//     });

//     final result = await receivePort.first;
//     return result;
//   }

//   static void computeDataLoad(Map<String, dynamic> message) {
//     final SendPort sendPort = message['sendPort'];
//     final String dataType = message['dataType'];

//     // Perform heavy computations here
//     List<dynamic> result = [];
//     // ... data processing logic

//     sendPort.send(result);
//   }
// }
