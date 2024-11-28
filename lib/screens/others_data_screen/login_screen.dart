import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:dims_vet_rx/screens/others_data_screen/privacy_policy.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../controller/sync_controller/json_to_db.dart';
import '../../utilities/default_value.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final LoginController loginController = LoginController();

  final List<String> deleteRangeItems = [
    'download last 3 months',
    'download last 6 months',
    'download last 12 months',
  ];

  String? selectedValue;
  String defaultSyncDownload = DefaultValues.defaultSyncStarting;

  @override
  Widget build(BuildContext context) {
    final _phoneController = loginController.phoneController;
    final _passwordController = loginController.passwordController;
    InsertDataJsonToDb insertDataJsonToDb = Get.put(InsertDataJsonToDb());

    return Scaffold(
      body: Card(
        color: Colors.blue,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/navana_icon.png", height: 200, width: 200,),
                  SizedBox(
                    width: 500,
                    child: Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
              
                            Text("Login Page", style: TextStyle(fontSize: 20.0),),
              
                            SizedBox(height: 5.0),
                           Obx(() =>  Row(
                             children: [
                               Checkbox(
                                   value: loginController.isDataSync.value,
                                   onChanged: (value){
                                     loginController.isDataSync.value = !loginController.isDataSync.value;
                                   }
                               ),
                               Text("Data Sync From Server", style: TextStyle(fontSize: 20.0),),
                             ],
                           ),),
                            SizedBox(height: 5.0),
                            TextField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Enter Phone Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            TextField(
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (String value) async{
                                // Handle the submitted value, e.g., submit form or perform an action
                                print('Submitted: $value');
                                await loginController.loginController(context, defaultSyncDownload);
                              },
                            ),
              
                            SizedBox(height: 5.0),
                            DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              hint: Text(
                                "Default all data will be download",
                              ),
                              items: deleteRangeItems.map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              )).toList(),
              
                              onChanged: (value) {
                                selectedValue = value.toString();
                                if(selectedValue == null) return;
                                defaultSyncDownload = loginController.convertTime(selectedValue!);
                              },
                              onSaved: (value) {
                                selectedValue = value.toString();
                                if(selectedValue == null) return;
                                defaultSyncDownload = loginController.convertTime(selectedValue!);
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
              
                            SizedBox(height: 5.0),
                            Obx(() => Wrap(
                              children: [
                                Checkbox(value: loginController.agreeWithPrivacyPolicy.value, onChanged: (value){
                                  loginController.agreeWithPrivacyPolicy.value = !loginController.agreeWithPrivacyPolicy.value;
                                }),
                                Text("I accept terms and conditions", style: TextStyle(fontSize: 20.0),),
                                TextButton(onPressed: (){
                                  showPrivacyPolicyDialog(context);
                                }, child: Text("Privacy Policy", style: TextStyle(fontSize: 20.0,color: Colors.blue),)),
                              ],
                            ),),
                            Obx(() => Wrap(
                              children: [
                                Text("Login As a", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.indigo),),
                                Wrap(
                                  children: [
                                    for(var item in loginController.loginWith)
                                    RadioMenuButton(value: item['value'], groupValue: loginController.selectedProfileType.value, onChanged: (value)async{
                                      loginController.selectedProfileType.value = value.toString();
                                      await setStoreKeyWithDefaultValue("profileType", loginController.selectedProfileType.value);
                                    }, child: Text("${item['name']}"))
                                  ],
                                ) 
                              ],
                            ),),
                           Obx(() =>  Column(
                             children: [
                               FilledButton(
                                 style: ButtonStyle(
                                   backgroundColor:loginController.agreeWithPrivacyPolicy.value == true ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.grey),
                                 ),
                                 onPressed: () async{
                                   if(loginController.agreeWithPrivacyPolicy.value == false){
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       const SnackBar(content: Text('Please accept the Privacy Policy')),
                                     );
                                     return;
                                   }
                                   await loginController.loginController(context, defaultSyncDownload);
                                 },
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Icon(Icons.login),
                                     SizedBox(width: 5.0),
                                     Text('Login'),
                                   ],
                                 ),
                               ),
                               if(insertDataJsonToDb.currentSyncingData.value != "" && insertDataJsonToDb.overallProgress.value != 1.0)
                                 Flexible(child: Text("Data is Syncing...Please Wait !!! After Sync is Completed...Apps will be Closed...Please Open the App Again", style: TextStyle(fontSize: 20.0,color: Colors.red),)),
              
                             ],
                           ),),
                            Obx(() => Column(
                              children: [
                                if(loginController.isLoginError.value == true)
                                Column(
                                  children: [
                                    TextField(
                                      controller: loginController.serverError,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        labelText: 'Server Error',
                                        border: OutlineInputBorder(),
                                      ),
                                      // onSubmitted: (String value) async{
                                      //   // Handle the submitted value, e.g., submit form or perform an action
                                      //   print('Submitted: $value');
                                      // },
                                    )
                                  ],
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}