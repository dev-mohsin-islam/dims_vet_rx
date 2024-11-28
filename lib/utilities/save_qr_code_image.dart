import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
Future<void> saveQRCode() async {
  var patientID = "12243"; // Convert patientID to string

  // Create a GlobalKey for the QrImageView widget
  final GlobalKey globalKey = GlobalKey();

  // Render the QrImageView widget to an Image after the frame is built
  WidgetsBinding.instance?.addPostFrameCallback((_) async {
    // Render the QrImageView widget to an Image
    final image = await _captureImage(globalKey, patientID);

    // Save the image to file
    await _saveImageToFile(image);
  });
}

Future<ui.Image> _captureImage(GlobalKey globalKey, String patientID) async {
  // Render the QrImageView widget to an Image
  RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  return image;
}


Future<void> _saveImageToFile(ui.Image image) async {
  // Convert the image to bytes
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData!.buffer.asUint8List();

  // Get the directory for saving the file
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/qr_code.png';

  // Write the image bytes to file
  final File imgFile = File(filePath);
  await imgFile.writeAsBytes(pngBytes);

  print('QR Code image saved to: $filePath');
}