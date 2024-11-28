

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dims_vet_rx/controller/sync_controller/sync_db_to_server_controller.dart';
import 'package:dims_vet_rx/controller/sync_controller/sync_server_to_db_controller.dart';

class LiveSyncController extends GetxController{
  final dbToServerSyncController = Get.put(DbToServerSyncController());
  final serverToDbSyncController = Get.put(SyncController());
  Future dataUpload()async{
    // await dbToServerSyncController.patient(Get.context);
    await dbToServerSyncController.appointment(Get.context);
  }
  Future prescriptionUpload()async{
    await dbToServerSyncController.patient(Get.context);
    await dbToServerSyncController.appointment(Get.context);
    await dbToServerSyncController.prescription(Get.context);
  }

  Future appointmentDownload()async{
    await serverToDbSyncController.patient(Get.context);
    await serverToDbSyncController.appointment(Get.context);
  }

  Future prescriptionDownload()async{
    await serverToDbSyncController.patient(Get.context);
    await serverToDbSyncController.appointment(Get.context);
    await serverToDbSyncController.prescription(Get.context);
    await serverToDbSyncController.prescriptionDrug(Get.context);
    await serverToDbSyncController.prescriptionDrugDose(Get.context);
  }


}