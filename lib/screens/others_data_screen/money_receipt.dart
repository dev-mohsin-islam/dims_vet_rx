

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/money_receipt/money_receipt.dart';

class MoneyReceiptScreen extends StatelessWidget {

  const MoneyReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MoneyReceiptCont moneyReceiptCon = Get.put(MoneyReceiptCont());
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title:   Row(
            children: [
              Text("Money Receipt", style: TextStyle(color: Colors.white),),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.sync, color: Colors.white), onPressed: (){
                moneyReceiptCon.getMoneyReceipt('');
              },
              )
            ]
          ),
      ),
      body: SingleChildScrollView(
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  reverse: true,
                  itemCount: moneyReceiptCon.moneyReceipts.length,
                  shrinkWrap: true,itemBuilder: (context, index){
                    var patientInfo = moneyReceiptCon.moneyReceipts[index]['paInfo'];
                    var moneyReceiptInfo = moneyReceiptCon.moneyReceipts[index]['moneyRecInfo'][0];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Name: "+patientInfo.name),
                            FilledButton(onPressed: (){
                              moneyReceiptCon.getMoneyResPrint(moneyReceiptInfo.id);
                            }, child: Text("Print"))
                          ]
                        ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Invoice ID: " +moneyReceiptInfo.invoice_id.toString()),
                          Text("Fee: " +moneyReceiptInfo.fee.toString()),
                          Text("Description: " + moneyReceiptInfo.description.toString()),
                        ],
                      ),
                    ),
                  ),
                );
              })
            ]
        ))
      ),
    );
  }
}

moneyReceiptDialog(context, app_id, fee){
  final moneyReceiptCon = Get.put(MoneyReceiptCont());
  moneyReceiptCon.feeController.text = fee.toString();
  moneyReceiptCon.descriptionController.text = "Consultant Fee";

  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Money Receipt"),
          IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.clear))
        ],
      ),
      actions: [
        ElevatedButton(onPressed: (){
            moneyReceiptCon.saveMoneyReceipt(moneyReceiptCon.boxMoneyReceipt.length + 1, app_id, "create");
        }, child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.print_outlined),
            Text("Save &Print"),
          ],
        ),)
      ],
      content: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextFormField(
                controller: moneyReceiptCon.feeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Fee",
                  border: OutlineInputBorder()
                )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextFormField(
                controller: moneyReceiptCon.descriptionController,

                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder()
                )
              ),
            ),
          ]
        ),
      ),
    );
  });
}
