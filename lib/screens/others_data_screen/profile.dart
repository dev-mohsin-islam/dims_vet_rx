import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/authentication/profile.dart';
import 'package:dims_vet_rx/controller/chambers/chamber_controller.dart';
import 'package:dims_vet_rx/screens/others_data_screen/dashboard.dart';
import 'package:dims_vet_rx/screens/others_data_screen/login_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controller/authentication/logout_controller.dart';
import '../../controller/general_setting/general_setting_controller.dart';
import '../../controller/sync_controller/sync_db_to_server_controller.dart';
import '../../controller/sync_controller/sync_server_to_db_controller.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/helpers.dart';
import '../../utilities/save_qr_code_image.dart';
import '../drawer_items_screen/drawer_items.dart';
import 'app_sync_modal.dart';


class UserProfileScreen extends StatelessWidget {

  final Profile profile = Get.put(Profile());
  final ChamberController chamberController = Get.put(ChamberController());
  final syncController = Get.put(SyncController());
  final DbToServerSyncController dbToServerSyncController = Get.put(DbToServerSyncController());

  @override
  Widget build(BuildContext context) {
    var generalSettingController = Get.put(GeneralSettingController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            Text('User Profile', style: TextStyle(color: Colors.white),),
            SizedBox(width: 10,),
            Obx(() => Column(
              children: [
                if(dbToServerSyncController.syncStatus.value == true || syncController.syncStatus.value == true)
                  Text("Syncing...", style: TextStyle( fontSize: 15),),
              ],
            ))
          ],
        ),
        actions: [

          // ElevatedButton(
          //   onPressed: () {
          //     openDirectory("C:\\RxSupport");
          //   },
          //   child: Text('Open Data Folder'),
          // ),


          SizedBox(width: 10,),
          // FilledButton(onPressed: (){
          //   // Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginPage()));
          //   chamberCreateModal(context, true, '');
          // }, child: Text("Chamber Create")),


            SizedBox(width: 10,),
            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EnableLogin"))
          FilledButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginPage()));
          }, child: Text("Login")),

          SizedBox(width: 5,),
          FilledButton(onPressed: (){
            logOutShowModal(context);
          }, child: Row(children: [
            Icon(Icons.logout),
            Text("Logout"),
          ],)),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5 ,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: profile.formKey,
                child: SingleChildScrollView(
                  child: Column(
                  
                    children: [
                      SizedBox(height: 10,),
                      TextFormField(
                        readOnly: true,
                        controller: profile.nameController,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        readOnly: true,
                        controller: profile.emailController,
                        decoration: InputDecoration(labelText: 'Email',
                        border: OutlineInputBorder(),

                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Add email validation logic here if needed
                          return null;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        readOnly: true,
                        controller: profile.phoneController,
                        decoration: InputDecoration(labelText: 'Phone',
                        border: OutlineInputBorder(),
                  
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          // Add phone number validation logic here if needed
                          return null;
                        },
                      ),
                      SizedBox(height: 10,),
                  
                      // FilledButton(onPressed: (){
                      //   // changePassModal(context);
                      // } , child: Text("Update Profile")),
                      SizedBox(height: 10,),
                      Obx(() => Card(
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          title: const Text("Profile Image"),
                          children: [
                            ElevatedButton(
                                onPressed: ()async{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('User Data Disclosure'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('This app collects and uploads your image for profile setup'),
                                              Text('Do you allow this?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Decline'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              // Prevent further action
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Accept'),
                                            onPressed: () async{
                                              await profile.getImage("");
                                              // Proceed with data collection or upload
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                }, child: const Text("Upload Image")),
                            const SizedBox(height: 10,),
                            if (profile.profileImage[0]['profileImage']!.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  if (profile.profileImage[0]['profileImage']!.isNotEmpty) {
                                    // Show full-screen dialog with the image
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          // backgroundColor: Colors.transparent,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                                              child: Image.memory(
                                                profile.profileImage[0]['profileImage']!,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                    child: profile.profileImage[0]['profileImage']!.isEmpty
                                        ? const Text('')
                                        : Stack(
                                      alignment : AlignmentDirectional.topStart,
                                      children: [
                                        Image.memory(
                                            profile.profileImage[0]['profileImage'],
                                            fit: BoxFit.cover
                                        ),
                                        IconButton(onPressed: (){
                                          profile.profileImage[0]['profileImage'] = Uint8List(0);
                                          profile.profileImage.refresh();
                                        }, icon: const Icon(Icons.cancel,color: Colors.white,))
                                      ],
                                    ),),
                                ),
                              ),
                          ],
                        ),
                      ),),
                      Container(width: double.infinity,height: 1, color: Colors.black, ),
                      SizedBox(height: 10,),
                      FilledButton(onPressed: (){
                        changePassModal(context);
                      } , child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.key),
                          SizedBox(width: 10,),
                          Text("Change Password"),
                        ],
                      )),
                  
                      SizedBox(height: 20,),
                  
                      SizedBox(height: 10,),
                      Obx(() =>
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  if(chamberController.chamberList.length > 0)
                                  Text("Chambers" , style: TextStyle(fontSize: 20),),
                                  for(int i = 0; i< chamberController.chamberList.length; i++)
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(chamberController.chamberList[i].chamber_name.toString()),
                                            // Text(chamberController.chamberList[i].web_id.toString()),
                                            // Text(chamberController.chamberList[i].id.toString()),
                                            // Container(
                                            //   child: Row(
                                            //     children: [
                                            //       IconButton(onPressed: (){
                                            //         chamberController.chamberName.text = chamberController.chamberList[i].chamber_name.toString();
                                            //         chamberCreateModal(context, false, chamberController.chamberList[i].id);
                                            //       }  , icon: Icon(Icons.edit)),
                                            //       SizedBox(width: 10,),
                                            //       // IconButton(onPressed: (){
                                            //       //   _showConfirmationDialog(context, chamberController.chamberList[i].id);
                                            //       // }  , icon: Icon(Icons.delete)),
                                            //     ],
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                      ),


                  // TextFormField(
                      //   controller: profile.passwordController,
                      //   decoration: InputDecoration(labelText: 'Password',
                      //   border: OutlineInputBorder(),
                      //
                      //   ),
                      //   obscureText: true,
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter a password';
                      //     }
                      //     // Add password validation logic here if needed
                      //     return null;
                      //   },
                      // ),
                      // SizedBox(height: 10,),
                      // TextFormField(
                      //   controller: profile.chamberController,
                      //   decoration: InputDecoration(labelText: 'Chamber',
                      //   border: OutlineInputBorder(),
                      //
                      //   ),
                      // ),
                      // SizedBox(height: 10,),
                      // TextFormField(
                      //   controller: profile.specialityController,
                      //   decoration: InputDecoration(labelText: 'Speciality',
                      //   border: OutlineInputBorder(),
                      //
                      //   ),
                      // ),
                      // SizedBox(height: 10,),
                      // TextFormField(
                      //   controller: profile.designationController,
                      //   decoration: InputDecoration(labelText: 'Designation',
                      //   border: OutlineInputBorder(),
                      //
                      //   ),
                      // ),
                      // SizedBox(height: 10,),
                      // TextFormField(
                      //   controller: profile.degreeController,
                      //   decoration: InputDecoration(labelText: 'Degree',
                      //   border: OutlineInputBorder(),
                      //
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     if (profile.formKey.currentState!.validate()) {
                      //       profile.submitForm();
                      //     }
                      //   }, child: Text('Save'),
                      // ) ,
                  
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

chamberCreateModal(context, isNewCreate, id) {
  // Profile profile = Get.put(Profile());
  ChamberController chamberController = Get.put(ChamberController());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog( 
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: isNewCreate ? Text('Chamber Create') : Text('Chamber Update')),
             IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.close)),
          ],
        ), 
        actions: [

        ],
        content: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
                children: [
                  SizedBox(height: 10,),
                  Form(
                      child: Column(
                          children: [
                            TextFormField(
                              controller: chamberController.chamberName,
                                decoration: InputDecoration(
                                  labelText: 'Chamber name',
                                  border: OutlineInputBorder(),
                                )
                            ),
                            SizedBox(height: 10,),
                            // TextFormField(
                            //     decoration: InputDecoration(
                            //       labelText: 'Chamber name',
                            //       border: OutlineInputBorder(),
                            //     ),
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return 'Please enter chamber name';
                            //     }
                            //   },
                            // ),

                           SizedBox(height: 10,),
                           FilledButton(onPressed: ()async{
                             if(isNewCreate){
                               // await  profile.chamberCreate();
                               await  chamberController.saveChamber();
                               Navigator.pop(context);
                             }else{
                               // await  profile.chamberUpdate(id);
                               chamberController.updateChamber(id);
                               Navigator.pop(context);
                             }

                           }, child: Text("Save"))
                          ]
                      )
                  )
                ]
            ),
          ),
        )
      );
    },
  );
}


changePassModal(context) {
  Profile profile = Get.put(Profile());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('Update Password')),
            IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.close)),
          ],
        ),
        actions: [

        ],
        content: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
                children: [
                  SizedBox(height: 10,),
                  Form(
                      key: profile.updatePass,
                      child: Column(
                          children: [
                            TextFormField(
                              controller: profile.updatePasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Enter New Password',
                                  border: OutlineInputBorder(),
                                ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                                controller: profile.reTypePasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Re-Type Password',
                                  border: OutlineInputBorder(),
                                ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please re-type password';
                                }
                                return null;

                              },


                            ),
                           SizedBox(height: 40,),
                           Row(
                             children: [

                               FilledButton(onPressed: (){
                                 profile.updatePassword();
                               }, child: Text("Update")),
                             ],
                           )
                          ]
                      )
                  )
                ]
            ),
          ),
        )
      );
    },
  );
}

void _showConfirmationDialog(BuildContext context, id) {
  Profile profile = Get.put(Profile());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Removal'),
        content: Text('Are you sure you want to remove this item?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async{
              // Perform remove operation here
             await profile.chamberRemove(id);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Remove'),
          ),
        ],
      );
    },
  );
}


// void QrCode(BuildContext context) {
//   var patientID = "12243"; // Convert patientID to string
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text("QR code"),
//         content: Container(
//           height: MediaQuery.of(context).size.height * 0.8,
//           width: MediaQuery.of(context).size.width * 0.7,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               QrImageView(
//                 data: 'This QR code has an embedded image as well',
//                 version: QrVersions.auto,
//                 size: 320,
//                 gapless: false,
//                 embeddedImage: AssetImage('assets/images/my_embedded_image.png'),
//                 embeddedImageStyle: QrEmbeddedImageStyle(
//                   size: Size(80, 80),
//                 ),
//               ),
//               SizedBox(height: 20), // Add spacing if needed
//               Text(
//                 'Prescription ID: $patientID',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
logOutShowModal(context){
  showDialog(context: context, builder: (context){
    return AlertDialog(
        title: Text("Logout Confirmation"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),

          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>   logoutSyncScreen()));
              Future.delayed(Duration.zero, () async {
                await syncCRUDController.SyncAll(context);
                await LogOutController().logoutController(context);

              });
          }, child: Text("Confirm"),)
        ]
    );
  });
}

imageUploadConfirmation(context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Data Collection Notice'),
        content: Text(
            'This app collects and uploads your image to enable user profile customization. Do you agree to allow this?'),
        actions: [
          TextButton(
            child: Text('Disagree'),
            onPressed: () {
              Navigator.of(context).pop(); // Handle rejection
            },
          ),
          TextButton(
            child: Text('Agree'),
            onPressed: () {
              Navigator.of(context).pop();
              // Proceed with image upload or other action
            },
          ),
        ],
      );
    },
  );

}