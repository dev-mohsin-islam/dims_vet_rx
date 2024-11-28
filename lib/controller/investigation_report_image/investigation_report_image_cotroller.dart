

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/investigation_report_image_crud.dart';
import 'package:dims_vet_rx/database/crud_operations/patient_disease_image.dart';
import 'package:dims_vet_rx/models/imvestigation_report_image/investigation_report_image_model.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/patient_disease_image/patient_disease_image_model.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class InvestigationReportImageController extends GetxController{
  final InvestigationReportImageCRUDController investigationReportImageCRUDController = InvestigationReportImageCRUDController();
  final Box<InvestigationReportImageModel> boxInvestigationReportImage = Boxes.getInvestigationReportImage();

  final investigationReportImageList = [].obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;

  //patient disease image upload ---------------------start
  RxList selectedInvestigationReportImage= [].obs;

  Future<void> uploadInvestigationReportImage() async {
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
          "inv_name": "",
          "details": "",
        };

        selectedInvestigationReportImage.add(imageObject);
        selectedInvestigationReportImage.refresh();


        Helpers.successSnackBar("Success", "Image Upload Successful");
      }
    }
  }
  onChangeInvestigationReportImageTitleUpdate(String value, index) {
    selectedInvestigationReportImage[index]['title'] = value;
    selectedInvestigationReportImage.refresh();
  }
  onChangeInvestigationReportImageNameUpdate(String value, index) {
    selectedInvestigationReportImage[index]['inv_name'] = value;
    selectedInvestigationReportImage.refresh();
  }
  onChangeInvestigationReportImageDetailsUpdate(String value, index) {
    selectedInvestigationReportImage[index]['details'] = value;
    selectedInvestigationReportImage.refresh();
  }


    addDataInvImage(appointmentID, selectedInvestigationReportImage)async{
    try{
      if(appointmentID !=0 && appointmentID !=555555555){

        if(selectedInvestigationReportImage.isNotEmpty){
          for(var i =0; i<selectedInvestigationReportImage.length; i++){
            var title = selectedInvestigationReportImage[i]['title'] ?? "";
            var inv_name = selectedInvestigationReportImage[i]['inv_name'] ?? "";
            var details = selectedInvestigationReportImage[i]['details'] ?? "";
            var image = selectedInvestigationReportImage[i]['image'] ?? "";
              var response = await investigationReportImageCRUDController.saveInvestigationReportImage(boxInvestigationReportImage, InvestigationReportImageModel(id: 0, inv_name: inv_name, app_id: appointmentID, url: image, title: title, details: details, u_status: statusNewAdd, web_id: web_id, uuid: uuid, date: date));

          }
        }
      }
    }catch(e){
      print(e);
    }

  }

  Future<void> getInvestigationReportImage(appointmentId) async {
    try {
      if(appointmentId !=0 && appointmentId !=555555555){
        List response =await investigationReportImageCRUDController.getInvestigationImage(boxInvestigationReportImage, appointmentId);
        print(response.length);
        if(response.isNotEmpty){
          investigationReportImageList.clear();
          investigationReportImageList.addAll(response);
        }
      }


    } catch (e) {
      print('Error occurred: $e');

    }
  }


  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    investigationReportImageList;

    super.dispose();
  }

}