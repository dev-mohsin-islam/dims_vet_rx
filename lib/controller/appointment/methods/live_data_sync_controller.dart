

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../sync_controller/live_sync_controller.dart';
import '../../sync_controller/sync_db_to_server_controller.dart';

class LiveAppointmentSyncController extends GetxController{
  final liveSyncController = Get.put(LiveSyncController());
  Future dataUploadToServer()async{
    liveSyncController.dataUpload();
  }
}