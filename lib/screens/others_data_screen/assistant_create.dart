import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/assistant/assistant_controller.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AssistantController assistantController = Get.put(AssistantController());
    final  assistantList = assistantController.assistantList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Text('Assistant'),
        actions: [
          FilledButton(onPressed: (){
            createAssistant(context, "CREATE", "Assistant New Create");
          }, child: Text("Create New Assistant"))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => Column(
                children: [
                  Wrap(
                      children: [
                        for(var item in assistantList)
                          Container(

                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width*0.3,

                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: Icon(Icons.person),
                                      ),
                                      Text(item['name']),
                                      Text(item['phone']),
                                      Text(item['email']),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton.filled(onPressed: (){
                                              assistantController.assistantName.text = item['name'];
                                              assistantController.assistantPhone.text = item['phone'];
                                              assistantController.assistantEmail.text = item['email'];
                                              // assistantController.assistantPassword.text = item['password'];
                                              assistantController.assistantId.text = item['id'].toString();
                                              createAssistant(context, "UPDATE", "Assistant Update");
                                            }, icon: Icon(Icons.edit), ),
                                            IconButton.filled(onPressed: ()async{
                                              await assistantController.deleteAssistant(item['id']);
                                            }, icon: Icon(Icons.delete, color: Colors.red.shade200,),)
                                          ]
                                      )
                                    ]
                                ),
                              ),
                            ),
                          ),

                      ]
                  )
                ]
            )),
          ],
        )
      ),
      // body: SingleChildScrollView(
      //   child: Container(
      //     child: Column(
      //       children: [
      //         Obx(() => ListView.builder(
      //           shrinkWrap: true,  // Ensure the list view does not cause unbounded height
      //           itemCount: assistantList.length,
      //           itemBuilder: (context, index) {
      //             var item = assistantList[index];
      //             return Container(
      //               child: Text(item['name']),
      //             );
      //           },
      //         )),
      //       ],
      //     ),
      //   ),
      // ),

    );
  }
}

  createAssistant(context, method, title){
    final AssistantController assistantController = Get.put(AssistantController());
    Get.defaultDialog(
      title: title,
        onConfirm: ()async{
          if(method == "CREATE"){
            await assistantController.createNewAssistant(context);
          }else if(method == "UPDATE"){
            await assistantController.updateAssistant(context);
          }

        },
      textConfirm: "Save",
        textCancel: "Close",
      content: Column(
        children: [
          Container(
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: assistantController.assistantName,
                  decoration: InputDecoration(
                      labelText: "Enter Name",
                    border: OutlineInputBorder()
                  )
                ),
                SizedBox(height: 10),
                TextField(
                    controller: assistantController.assistantPhone,
                  decoration: InputDecoration(
                      labelText: "Enter Phone",
                    border: OutlineInputBorder()
                  )
                ),
                SizedBox(height: 10),
                TextField(
                    controller: assistantController.assistantEmail,
                  decoration: InputDecoration(
                      labelText: "Enter Email",
                    border: OutlineInputBorder()
                  )
                ),        SizedBox(height: 10),
                TextField(
                    controller: assistantController.assistantPassword,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    border: OutlineInputBorder()
                  )
                ),
              ],
            ),
          )
        ]
      )
    );

}
