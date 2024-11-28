
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/patient_referral/patient_referral_controller.dart';

class PatientReferralScreen extends StatelessWidget {
  const PatientReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PaReferralController paRefCont = Get.put(PaReferralController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Patient Referral', style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: paRefCont.paReferralList.length,
                    itemBuilder: (context, index){
                      var refInfo = paRefCont.paReferralList[index]['refInfo'];
                      var refDocInfo = paRefCont.paReferralList[index]['refDocInfo'];
                      var refDocPaInfo = paRefCont.paReferralList[index]['refPaInfo'];
                  return Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(refDocPaInfo.name.toString(), style: TextStyle(color: Colors.blue),),
                          FilledButton(onPressed: (){
                            paRefCont.getRefPaForPrint(refInfo.id);
                          }, child: Row(
                            children: [
                              Icon(Icons.print),
                              Text("Print"),
                            ],
                          )),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(refDocInfo.name.toString()),
                          Text(refInfo.id.toString()),
                        ]
                      ),
                    )
                  );
                }),
              ],
            ))
          ]
        )
      ),

    );
  }
}
