



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../controller/general_setting/data_ordering_controller.dart';

class ClinicalDataOrderingScreen extends StatelessWidget {
  const ClinicalDataOrderingScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final DataOrderingController dataOrderingController = Get.put(DataOrderingController());
    return Container(
      child: Column(
        children: [
         Column(
           children: [
             Row(
               children: [
                 Title(color: Colors.black, child: Text("Clinical Data Ordering in Home Page", style: TextStyle(fontSize: 20,color: Colors.black54),)),
               ],
             ),
             Wrap(
               children: [
                 for(var item in dataOrderingController.dataOrdering)
                   Container(
                     padding: const EdgeInsets.all(10),
                     width: MediaQuery.sizeOf(context).width * .2,
                     child: TextFormField(
                       initialValue: '${item["value"]}',
                       decoration: InputDecoration(
                         border: OutlineInputBorder(),
                         labelText: '${item["title"]}',
                       ),
                       keyboardType: TextInputType.number,
                       onChanged: (value) {
                         item["value"] = value;
                       },
                     ),
                   ),
               ],
             ),
           ],
         ),
         Column(
           children: [
             Row(
               children: [
                 Title(color: Colors.black, child: Text("Patient Data for Print", style: TextStyle(fontSize: 20,color: Colors.black54),)),
               ],
             ),
             Wrap(
               children: [
                 for(var item in dataOrderingController.patientInfoOrderingForPrint)
                   Container(
                     padding: const EdgeInsets.all(10),
                     width: MediaQuery.sizeOf(context).width * .2,
                     child: TextFormField(
                       initialValue: '${item["value"]}',
                       decoration: InputDecoration(
                         border: OutlineInputBorder(),
                         labelText: '${item["title"]}',
                       ),
                       keyboardType: TextInputType.number,
                       onChanged: (value) {
                         item["value"] = value;
                       },
                     ),
                   ),
               ],
             ),
           ],
         ),
          ElevatedButton(

            onPressed: (){
            dataOrderingController.saveOrderingData();

          }, child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Save"),
            ],
          ),)
        ],
      ),
    );
  }
}
