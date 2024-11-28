

import 'package:flutter/material.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../../controller/favorite_index/favorite_index_controller.dart';
import '../../../../../utilities/app_strings.dart';

Container favoriteAndRemove(favoriteId, FavoriteIndexController favoriteIndexController, favoriteIndex, PrescriptionController prescriptionController) {
  return Container(
    width: 50,
    child:  favoriteId ==null  ?
    IconButton(onPressed: ()async{
      await favoriteIndexController.addData(favoriteIndexController.favoriteIndexDataList.length + 1,FavSegment.brand, favoriteIndex );
      // // await controller.getAllData('');
      prescriptionController.favoriteDrugList.refresh();
      prescriptionController.modifyDrugData.refresh();
      //prescriptionController.getAllBrandData('');
      prescriptionController.favoriteListFunction();

    }, icon: const Icon(Icons.star_border))
        :
    IconButton(onPressed: ()async{
      print('Remove ID : $favoriteIndex');
      await favoriteIndexController.updateData(favoriteIndexController.favoriteIndexDataList.length + 1,FavSegment.brand, favoriteIndex );
      // // await controller.getAllData('');
      prescriptionController.favoriteDrugList.refresh();
      prescriptionController.modifyDrugData.refresh();
      //prescriptionController.getAllBrandData('');
      prescriptionController.favoriteListFunction();

    }, icon: const Icon(Icons.star)),
  );
}


