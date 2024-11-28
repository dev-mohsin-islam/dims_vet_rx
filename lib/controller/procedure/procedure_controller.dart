



import 'package:get/get_rx/get_rx.dart';
import 'package:dims_vet_rx/models/procedure/procedure_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/create_prescription/prescription_procedure/prescription_procedure_model.dart';
import '../../screens/common_screen/common_screen.dart';
import '../../screens/printing/prescription_procedure_print/print.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class ProcedureController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<ProcedureModel>box = Boxes.getProcedure();
  final RxList dataList =  [].obs;
  final TextEditingController nameController= TextEditingController();
  final TextEditingController searchController= TextEditingController();
  RxBool isLoading = true.obs;
  RxBool isAddToFavorite = false.obs;
  RxBool isSearch = false.obs;


  // start----for prescription procedure--------------------------
  RxList selectedProcedure = [].obs;
  RxList  selectedProcedureForSave =  [].obs;
  TextEditingController procedureNameController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController anesthesiaController = TextEditingController();
  TextEditingController surgeonNameController = TextEditingController();
  TextEditingController assistantController = TextEditingController();
  TextEditingController incisionController = TextEditingController();
  TextEditingController procedureDetailsController = TextEditingController();
  TextEditingController prosthesisController = TextEditingController();
  TextEditingController closerController = TextEditingController();
  TextEditingController findingsController = TextEditingController();
  TextEditingController complicationsController = TextEditingController();
  TextEditingController drainsController = TextEditingController();
  TextEditingController postOperativeInstructionsController = TextEditingController();
// end for prescription procedure-------------------------------------------------

  void isSearchFunction(String name)async{
    if(name.trim().isNotEmpty){
      isSearch.value = true;
    }else{
      isSearch.value = false;
    }
  }

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;


  void addData(id)async{
    try {
      if(nameController.text.trim().isNotEmpty){
       int? resId = await commonController.saveCommon(box, ProcedureModel(id: id, name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd));
        nameController.clear();
       if(resId != -1 && isAddToFavorite.value){
         await favoriteIndexController.addData(favoriteIndexController.box.length + 1, FavSegment.procedure, resId);
         isAddToFavorite.value = false;
       }
        await getAllData('');
      }else{
        Helpers.errorSnackBar('Error', 'Please enter name');
      }
    }catch(e){
      print(e);
    }
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
   try{
     if(nameController.text.trim().isNotEmpty && id !=null && id !=-1){
       await commonController.updateCommon(box, id, nameController.text.trim(), statusUpdate);
       nameController.clear();
       await getAllData('');
       dataList.refresh();
     }else{
       Helpers.errorSnackBar('Error', 'Please enter name');
     }

   }catch(e){
     print('Error');
   }
    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      if(id != null && id !=-1){
        await commonController.deleteCommon(box, id, statusDelete);
        await getAllData('');
      }
    } catch (e) {
      // Handle the exception
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }

  Future<void> getAllData(String searchText)async{
    try {
      isLoading.value = true;
      var response = await commonController.getAllDataCommonSearch(box, searchText);
      dataList.clear();
      dataList.addAll(response);
      // dataList.sort((a, b) => a.name[0].compareTo(b.name[0]));
      isLoading.value = false;
    }catch(e){
      print(e);
    }
  }


  saveProcedureToDb(PRESCRIPTION_id){
    PrescriptionProcedureModel procedureModel = PrescriptionProcedureModel(
       id: 0,
       u_status: 0,
       prescription_id: 0,
       procedure_id: 0,
       diagnosis: "",
       anesthesia: "",
       incision: "",
       surgeon: "",
       uuid: "",
       assistant: "",
       details: "",
       prosthesis: "",
       closer: "",
       findings: "",
       complications: "",
       drains: "",
       post_operative_instructions: "",
    );

  }
  procedureAdd(item){
    var procedureObj = {
      'id': item.id,
      'procedureNameController':procedureNameController.text,
      'diagnosisController': diagnosisController.text,
      'anesthesiaController': anesthesiaController.text,
      'surgeonNameController':surgeonNameController.text,
      'assistantController': assistantController.text,
      'incisionController': incisionController.text,
      'procedureDetailsController': procedureDetailsController.text,
      'prosthesisController': prosthesisController.text,
      'closerController': closerController.text,
      'findingsController': findingsController.text,
      'complicationsController':complicationsController.text,
      'drainsController': drainsController.text,
      'postOperativeInstructionsController':postOperativeInstructionsController.text,
    };

    PrescriptionProcedureModel prescriptionProcedureModel = PrescriptionProcedureModel(
      id: item.id,
      procedure_name: procedureNameController.text.toString(),
      u_status: DefaultValues.NewAdd,
      prescription_id: 0,
      procedure_id: item.id,
      diagnosis: diagnosisController.text,
      anesthesia: anesthesiaController.text,
      incision: incisionController.text,
      surgeon: surgeonNameController.text,
      uuid: DefaultValues.defaultUuid,
      assistant: assistantController.text,
      details: procedureDetailsController.text,
      prosthesis: prosthesisController.text,
      closer: closerController.text,
      findings: findingsController.text,
      complications: complicationsController.text,
      drains: drainsController.text,
      post_operative_instructions:postOperativeInstructionsController.text,
    );
    if(selectedProcedure.isNotEmpty){
      for(var i = 0; i < selectedProcedure.length; i++){
        if(selectedProcedure[i].procedure_id == item.id){
          selectedProcedure[i] = prescriptionProcedureModel;
        }
      }
    }else{
      selectedProcedure.add(prescriptionProcedureModel);
    }
   if(selectedProcedureForSave.isNotEmpty){
     for(var i = 0; i < selectedProcedureForSave.length; i++){
       if(selectedProcedureForSave[i]['id'] == item.id){
         selectedProcedureForSave[i] = procedureObj;
         return;
       }else{
         selectedProcedureForSave.add(procedureObj);
       }
     }
   }


  }
  procedurePrinting(context,item,patientName,patientAge,date){
    var procedureObj1 = [
      {
        'id': item.id,
        'procedureNameController':procedureNameController.text,
        'diagnosisController': diagnosisController.text,
        'anesthesiaController': anesthesiaController.text,
        'surgeonNameController':surgeonNameController.text,
        'assistantController': assistantController.text,
        'incisionController': incisionController.text,
        'procedureDetailsController': procedureDetailsController.text,
        'prosthesisController': prosthesisController.text,
        'closerController': closerController.text,
        'findingsController': findingsController.text,
        'complicationsController':complicationsController.text,
        'drainsController': drainsController.text,
        'postOperativeInstructionsController':postOperativeInstructionsController.text,
      }
    ];

    var procedureObj2 = [
      {
        'anesthesiaController': anesthesiaController.text,
        'surgeonNameController':surgeonNameController.text,
        'assistantController': assistantController.text,
      }
    ];


    var isHeaderFooterActive = true;

    var printPatientAndAppointmentInfo = [
      {
        'name': patientName,
        "age" : patientAge,
        "date": date,
      }
    ];

    Navigator.push(context, MaterialPageRoute(builder: (context) =>procedurePrintPreview(selectedClinicalDataColumn1: procedureObj1,selectedMedicineDataColumn2: procedureObj2,printPatientAndAppointmentInfo: printPatientAndAppointmentInfo,)));

  }
  procedureTextClear(){
    procedureNameController.clear();
    diagnosisController.clear();
    anesthesiaController.clear();
    surgeonNameController.clear();
    assistantController.clear();
    incisionController.clear();
    procedureDetailsController.clear();
    prosthesisController.clear();
    closerController.clear();
    findingsController.clear();
    complicationsController.clear();
    drainsController.clear();
    postOperativeInstructionsController.clear();
  }
  procedureUpdateTextController(item){
    Map<String, dynamic>? mapDataFind = selectedProcedureForSave.firstWhere((map) => map['procedureNameController'] == item.name, orElse: () => null,);
    if(mapDataFind !=null){
      procedureNameController.text =  mapDataFind['procedureNameController'];
      diagnosisController.text =mapDataFind['diagnosisController'];
      anesthesiaController.text=mapDataFind['anesthesiaController'];
      surgeonNameController.text =mapDataFind['surgeonNameController'];
      assistantController.text =mapDataFind['assistantController'];
      incisionController.text =mapDataFind['incisionController'];
      procedureDetailsController.text =mapDataFind['procedureDetailsController'];
      prosthesisController.text =mapDataFind['prosthesisController'];
      closerController.text =mapDataFind['closerController'];
      findingsController.text =mapDataFind['findingsController'];
      complicationsController.text =mapDataFind['complicationsController'];
      drainsController.text =mapDataFind['drainsController'];
      postOperativeInstructionsController.text =mapDataFind['postOperativeInstructionsController'];
    }

  }
  procedureUpdate(item){
    selectedProcedure.remove(item);
    selectedProcedure.add(item);
    selectedProcedureForSave.removeWhere((map) => map['id'] == item.id);
    var procedureObj =
    {
      'id': item.id,
      'procedureNameController': procedureNameController.text,
      'diagnosisController':  diagnosisController.text,
      'anesthesiaController':  anesthesiaController.text,
      'surgeonNameController':  surgeonNameController.text,
      'assistantController': assistantController.text,
      'incisionController': incisionController.text,
      'procedureDetailsController': procedureDetailsController.text,
      'prosthesisController': prosthesisController.text,
      'closerController': closerController.text,
      'findingsController': findingsController.text,
      'complicationsController':  complicationsController.text,
      'drainsController': drainsController.text,
      'postOperativeInstructionsController': postOperativeInstructionsController.text,
    };
    selectedProcedureForSave.add(procedureObj);
    procedureTextClear();
  }
  bool procedureRemove(item){
    if(selectedProcedureForSave.isEmpty){

    }
    selectedProcedure.remove(item);
    var res = selectedProcedureForSave.removeWhere((map) => map['id'] == item.id);
    procedureTextClear();
    return true;
  }

  clearText()async{
    dataList.clear();
    nameController.clear();
    searchController.clear();
    await getAllData('');
  }


  @override
  void onInit() {
    // TODO: implement onInit
    getAllData('');
    super.onInit();
  }

  @override
  void dispose() {
    getAllData('');
    dataList;
    nameController;
    searchController;
    isLoading;
    selectedProcedure;
    selectedProcedureForSave;
    procedureNameController;
    diagnosisController;
    anesthesiaController;
    surgeonNameController;
    assistantController;
    incisionController;
    procedureDetailsController;
    prosthesisController;
    closerController;
    findingsController;
    complicationsController;
    drainsController;
    postOperativeInstructionsController;
    super.dispose();
  }

}



