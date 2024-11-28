import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:dims_vet_rx/screens/others_data_screen/login_screen.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:http/io_client.dart';

Future<dynamic> createAssistantApiService(String url, String method, String token, String phone, String name, String email, String password) async {
  try {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    // Add form fields
    request.fields.addAll({
      'phone': '$phone',
      'password': '$password',
      'name': '$name',
      'email': '$email',
    });
    // Add headers
    request.headers.addAll(headers);

    // Send the request
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();

      return responseString;
    } else if (response.statusCode == 422) {
      final errorData = await response.stream.bytesToString();
      Helpers.errorSnackBar("Failed", "${jsonDecode(errorData)['message']}, check phone number is exist or not");
      print('HTTP 422 error: $errorData');
    } else {
      // Print the reason for any other error that occurred
      print('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  } catch (e) {
    if(e is SocketException){
      Future.delayed(Duration(seconds: 3), () => createAssistantApiService(url, method, token, phone, name, email, password));
    }
    throw 'Error: $e';
  }
}
Future<dynamic> updateAssistantApiService(String url, String method, String token, String phone, String name, String email, String password) async {
  try {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Use application/json content type
    };

    // Create a request object for PUT method
    final request = http.Request('PUT', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add JSON body
    final requestBody = jsonEncode({
      'phone': phone,
      'password': password,
      'name': name,
      'email': email,
    });

    request.body = requestBody;

    // Send the request
    final response = await http.Response.fromStream(await request.send());

    // Check the status code of the response
    if (response.statusCode == 200) {
      // Parse response and return data
      final responseString = response.body;
      print(responseString);
      return responseString;
    } else if (response.statusCode == 422) {
      // Unprocessable Entity error handling
      final errorData = response.body;
      print('HTTP 422 error: $errorData');
    } else {
      // Print the reason for any other error that occurred
      print('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  } catch (e) {
    if(e is SocketException){
      Future.delayed(Duration(seconds: 3), () => updateAssistantApiService(url, method, token, phone, name, email, password));
    }
    print( 'Error: $e');
  }
}
Future<dynamic> deleteAssistantApiService(String url, String method, String token) async {
  try {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Use application/json content type
    };

    // Create a request object for PUT method
    final request = http.Request('DELETE', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);


    // Send the request
    final response = await http.Response.fromStream(await request.send());

    // Check the status code of the response
    if (response.statusCode == 200) {
      // Parse response and return data
      final responseString = response.body;
      print(jsonDecode(responseString));
      return responseString;
    } else if (response.statusCode == 422) {
      // Unprocessable Entity error handling
      final errorData = response.body;
      print('HTTP 422 error: $errorData');
    } else {
      // Print the reason for any other error that occurred
      print('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  } catch (e) {
    if(e is SocketException){
      Future.delayed(Duration(seconds: 3), () => deleteAssistantApiService(url, method, token));
    }
    print( 'Error: $e');
  }
}




Future<dynamic> assistantListApiService(String url,method, String token,) async {
  try {
  //   var httpClient = HttpClient()
  //   ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  // var http = IOClient(httpClient);

    if(method == 'get') {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.MultipartRequest('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        return jsonDecode(data);
      } else if(response.statusCode ==401) {
        Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (context) =>  LoginPage()), (route) => false);

      }else  {
        print( 'HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    }
  } catch (e) {
    if(e is SocketException){
      Future.delayed(Duration(seconds: 3), () => assistantListApiService(url,method, token));
    }
    print( 'Error: $e');
  }
}

