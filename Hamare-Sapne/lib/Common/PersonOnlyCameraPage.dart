// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// // ML Kit packages (your versions)
// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
// class HumanOnlyCamera extends StatefulWidget {
//   @override
//   State<HumanOnlyCamera> createState() => _HumanOnlyCameraState();
// }
//
// class _HumanOnlyCameraState extends State<HumanOnlyCamera> {
//   final picker = ImagePicker();
//   File? imageFile;
//
//   late ObjectDetector objectDetector;
//   late FaceDetector faceDetector;
//
//   String status = "";
//
//   @override
//   void initState() {
//     super.initState();
//
//     objectDetector = ObjectDetector(
//       options: ObjectDetectorOptions(
//         mode: DetectionMode.singleImage,
//         classifyObjects: true,
//         multipleObjects: true,
//       ),
//     );
//
//     faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         performanceMode: FaceDetectorMode.accurate,
//         enableClassification: false,
//         enableLandmarks: false,
//         enableContours: false,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     objectDetector.close();
//     faceDetector.close();
//     super.dispose();
//   }
//
//   Future<void> captureAndCheck() async {
//     final XFile? img =
//     await picker.pickImage(source: ImageSource.camera);
//
//     if (img == null) {
//       setState(() => status = "No photo taken");
//       return;
//     }
//
//     imageFile = File(img.path);
//     setState(() => status = "Checking...");
//
//     final InputImage inputImage = InputImage.fromFilePath(img.path);
//
//     bool foundPerson = false;
//
//     // --- Object detection ---
//     final objects = await objectDetector.processImage(inputImage);
//
//     for (final obj in objects) {
//       for (final label in obj.labels) {
//         final text = label.text.toLowerCase();
//         if (text.contains("person") || text.contains("human")) {
//           foundPerson = true;
//           break;
//         }
//       }
//       if (foundPerson) break;
//     }
//
//     // --- Fallback: Face detection ---
//     if (!foundPerson) {
//       final faces = await faceDetector.processImage(inputImage);
//       if (faces.isNotEmpty) foundPerson = true;
//     }
//
//     setState(() {
//       status = foundPerson
//           ? "Accepted: Human detected"
//           : "Rejected: No human found";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Human Only Camera")),
//       body: Center(
//         child: Column(
//           children: [
//             if (imageFile != null)
//               Image.file(imageFile!, height: 300),
//             Text(status),
//             ElevatedButton(
//               onPressed: captureAndCheck,
//               child: Text("Take Photo"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
