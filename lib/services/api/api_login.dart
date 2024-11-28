


import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';



Future login(URL, PHONE, PASSWORD) async {
  LoginController loginController = Get.put(LoginController());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    bool HandshakeExceptionError =await prefs.getBool('HandshakeExceptionError') ?? false;
    var httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var ioClient = IOClient(httpClient);

    var response = HandshakeExceptionError
        ? await ioClient.post(
      Uri.parse('$URL'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': PHONE,
        'password': PASSWORD,
      }),
    )
        : await http.post(
      Uri.parse('$URL'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': PHONE,
        'password': PASSWORD,
      }),
    );


    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data;
      } else {
        Helpers.errorSnackBar('Error', '${data['message']}');
      }
    } else {
      loginController.isLoginError.value = true;
      loginController.serverError.text = response.statusCode.toString() + " : " + response.reasonPhrase.toString();
      Helpers.errorSnackBar('Error', 'Something went wrong. Please try again');
      print('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  } catch (e) {

    Helpers.errorSnackBarDuration("Error Catch Server", "$e", 3000);
    if (e is HandshakeException) {
      await  prefs.setBool("HandshakeExceptionError", true);
      Future.delayed(Duration(seconds: 2), () => login(URL, PHONE, PASSWORD));
    }
    if (e is SocketException) {
      print('SocketException: $e');
      Future.delayed(Duration(seconds: 3), () => login(URL, PHONE, PASSWORD));
    }
    print(e);
  }
}


