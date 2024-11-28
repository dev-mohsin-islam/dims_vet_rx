

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/general_setting/prescription_print_page_setup_controller.dart';



Widget prescriptionHeaderFooter(imageSection){
    final PrescriptionPrintPageSetupController controller = Get.put(PrescriptionPrintPageSetupController());
    final Uint8List? imageData = controller.headerFooterAndBgImage[0]['${imageSection}'];

    if (imageData == null || imageData.isEmpty) {
      return Container(); // Return an empty container if image data is null or empty
    } else {
      try {
        final image = Image.memory(
          imageData,
          fit: BoxFit.contain,
        );
        // Attempt to paint the image onto a canvas to trigger any possible errors
        image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((_, __) {}));
        return image;
      } catch (e) {
        // Handle the exception
        print('Error loading footer image: $e');
        return Container(); // Return an empty container or show an error message widget
      }
    }
}