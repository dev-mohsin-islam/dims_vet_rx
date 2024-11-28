

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/patient_disease_image.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/patient_disease_image/patient_disease_image_model.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class PatientDiseaseImageController extends GetxController{
  final PatientDiseaseImageCRUDController patientDiseaseImageCRUDController = PatientDiseaseImageCRUDController();
  final Box<PatientDiseaseImageModel> boxPatientDiseaseImage = Boxes.getPatientDiseaseImage();

  final patientDiseaseList = [].obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;

  //patient disease image upload ---------------------start
  RxList selectedPatientDiseaseImage= [].obs;
  Future<void> uploadPatientDiseaseImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        // The user selected a file
        var imagePath = File(result.files.single.path!);
        Uint8List imageData = await imagePath.readAsBytes();
        if(imageData.isNotEmpty){
          var imageObject = {
            "image": imageData,
            "title": "",
            "disease_name": "",
            "details": "",
          };
          selectedPatientDiseaseImage.add(imageObject);
          selectedPatientDiseaseImage.refresh();
          Helpers.successSnackBar("Success", "Image Upload Successful");
        }
      }
    }catch(e){
      print(e);
    }

  }
  onChangePatientDiseaseImageTitleUpdate(String value, index) {
    selectedPatientDiseaseImage[index]['title'] = value;
    selectedPatientDiseaseImage.refresh();
  }
  onChangePatientDiseaseImageDiseaseNameUpdate(String value, index) {
    selectedPatientDiseaseImage[index]['disease_name'] = value;
    selectedPatientDiseaseImage.refresh();
  }
  onChangePatientDiseaseImageDiseaseDetailsUpdate(String value, index) {
    selectedPatientDiseaseImage[index]['details'] = value;
    selectedPatientDiseaseImage.refresh();
  }

//patient disease report image upload ---------------------end

  addData(appointmentID, selectedPatientDiseaseImage)async{
   try{
     if(appointmentID !=0 && appointmentID !=555555555){
       if(selectedPatientDiseaseImage.isNotEmpty){
         for(var i =0; i<selectedPatientDiseaseImage.length; i++){
           var title = selectedPatientDiseaseImage[i]['title'] ?? "";
           var disease_name = selectedPatientDiseaseImage[i]['disease_name'] ?? "";
           var details = selectedPatientDiseaseImage[i]['details'] ?? "";
           var image = selectedPatientDiseaseImage[i]['image'] ?? "";

             var response = await patientDiseaseImageCRUDController.savePatientDiseaseImage(boxPatientDiseaseImage, PatientDiseaseImageModel(id: 0, disease_name: disease_name, app_id: appointmentID, url: image, title: title, details: details, u_status: statusNewAdd, web_id: web_id, uuid: uuid, date: date));

         }
       }
     }
   }catch(e){
     print(e);
   }

  }

  Future<void> getPatientDiseaseImage(searchText) async {
    try {
      List result =await patientDiseaseImageCRUDController.getAllDataCommon(boxPatientDiseaseImage, searchText);
      print(result.length);
      if(result.isNotEmpty)
         {
        patientDiseaseList.clear();
        patientDiseaseList.addAll(result);
      }
    } catch (e) {
      print('Error occurred: $e');

    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPatientDiseaseImage('');
  }


  @override
  void dispose() {
    patientDiseaseList;
    selectedPatientDiseaseImage;
    uuid;
    date;
    web_id;
    statusNewAdd;
    statusUpdate;
    statusDelete;
    super.dispose();
  }

}