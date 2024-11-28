import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/general_setting/prescription_print_page_setup_controller.dart';

class PrescriptionPrintPageSetupNew extends StatefulWidget {
  const PrescriptionPrintPageSetupNew({super.key});

  @override
  State<PrescriptionPrintPageSetupNew> createState() => _PrescriptionPrintPageSetupNewState();
}

class _PrescriptionPrintPageSetupNewState extends State<PrescriptionPrintPageSetupNew> {
  @override
  Widget build(BuildContext context) {
    PrescriptionPrintPageSetupController controller = Get.put(PrescriptionPrintPageSetupController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Prescription Print Page Setup", style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            )),
            FilledButton(onPressed: (){}, child: Text("Default Setup")),
            FilledButton(onPressed: (){
            }, child: Text("Save",),)
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
               Obx(() => Column(children: [
                 for(var i=0; i<controller.prescriptionPrintSetupData.length; i++)
                   if(controller.prescriptionPrintSetupData[i]['key'] !="ImageUploadSection")
                     ExpansionTile(
                       initiallyExpanded: true,
                       title: Text(controller.prescriptionPrintSetupData[i]['title'], style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: Colors.teal
                       )),
                       children: [
                         Wrap(
                           children: [
                             for(var j=0; j<controller.prescriptionPrintSetupData[i]['data'].length; j++)

                               Card(
                                 child: Wrap(
                                   direction: Axis.vertical,
                                   crossAxisAlignment: WrapCrossAlignment.center,
                                   children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text(controller.prescriptionPrintSetupData[i]['data'][j]['label']),
                                   ),
                                   Container(
                                     width: 150,
                                     padding: EdgeInsets.all(10),
                                     child: TextFormField(
                                       initialValue: controller.prescriptionPrintSetupData[i]['data'][j]['value'],
                                       onChanged: (value){
                                         controller.prescriptionPrintSetupData[i]['data'][j]['value'] = value;
                                       },
                                       decoration: InputDecoration(
                                           border: OutlineInputBorder()
                                       ),
                                     ),
                                   )
                                 ],),
                               )
                           ],
                         )

                       ],

                     )
       ],)),
            ],
          ),
        ),
      ),
    );
  }
}
