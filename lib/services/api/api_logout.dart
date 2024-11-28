


import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:http/io_client.dart';  // Import IOClient
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

  Future logOut(String url, String token) async {

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool HandshakeExceptionError =await prefs.getBool('HandshakeExceptionError') ?? false;

    // Create an HttpClient that bypasses certificate checks
    var httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    // Create an IOClient using the custom HttpClient
    var ioClient = HandshakeExceptionError ? IOClient(httpClient) : http.Client();

    if(HandshakeExceptionError){

      var response = await ioClient.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{}),
      );

      if (response.statusCode == 200) {
        final data =await jsonDecode(response.body);
        if(data['success'] == true){
          return true;
        }
      }else if(response.statusCode == 401){
        Helpers.errorSnackBarDuration("Server error", 'Unauthorized', 300);
        return false;
      } else if(response.statusCode == 500){
        Helpers.errorSnackBarDuration("Server error", 'Internal Server Error', 300);
        return false;
      } else {
        Helpers.errorSnackBarDuration("Server error", '${response.reasonPhrase}', 300);
        print('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    }else {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{}),
      );

      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        if (data['success'] == true) {
          return true;
        }
      } else if (response.statusCode == 401) {
        Helpers.errorSnackBarDuration("Server error", 'Unauthorized', 300);
        return false;
      } else if (response.statusCode == 500) {
        Helpers.errorSnackBarDuration(
            "Server error", 'Internal Server Error', 300);
        return false;
      } else {
        Helpers.errorSnackBarDuration(
            "Server error", '${response.reasonPhrase}', 300);
        print('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    }

  } catch (e) {
    Helpers.errorSnackBarDuration("Error Catch Server", "$e", 3000);
    if (e is SocketException) {
      // Future.delayed(Duration(seconds: 3), () => logOut(url, token));
    }
    print('Error: $e');
  }
}
