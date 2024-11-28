
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import '../../../screens/others_data_screen/login_screen.dart';
import '../../../utilities/helpers.dart';

class ApiCreateServerToDb{

  Future<dynamic> ApiService(String url, String token, String date, int page, int per_page) async {

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "date": " $date",
          "page": page,
          "per_page": per_page,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if(response.statusCode == 402){
        Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (context) =>  LoginPage()), (route) => false);
      } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url, token, date, page, per_page));
      }

      print('Error: $e $url') ;

    }
  }
  Future<dynamic> CertificateApiService(String url, String token, String date, int page, int per_page) async {

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "date": " $date",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if(response.statusCode == 302){
        final location = response.headers['location'];
        if(location != null){
          return CertificateApiService(location, token, date, page, per_page);
        }

      }else if(response.statusCode ==500){
        print(response.body);
      }else{
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
        // print(response.body);
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url, token, date, page, per_page));
      }

      print('Error: $e $url') ;

    }
  }
  Future<dynamic> ApiServiceXX(String URL, String token, String date, int page, int per_page) async {
    final url = Uri.parse('$URL');

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer  $token',};

    final request = http.MultipartRequest('POST', url)
      ..fields['date'] = '$date'
      ..fields['page'] = '$page'
      ..fields['per_page'] = '$per_page'
      ..headers.addAll(headers);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print(responseData);
        return responseData;
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }




  Future<dynamic> generalSettingsApiService(String url, String token, String date, int page, int per_page) async {

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => generalSettingsApiService(url, token, date, page, per_page));
      }
      print('Error: $e $url') ;

    }
  }
  Future<dynamic> prescriptionLayoutSettingsApiService(String url, String token, String date, int page, int per_page) async {

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => prescriptionLayoutSettingsApiService(url, token, date, page, per_page));
      }
      print('Error: $e $url') ;
      return null;

    }
  }

}
class ifServErrorApiCreateServerToDb{

  Future<dynamic> ApiService(String url, String token, String date, int page, int per_page) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "date": " $date",
          "page": page,
          "per_page": per_page,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if(response.statusCode == 402){
        Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (context) =>  LoginPage()), (route) => false);
      } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
       print(response.body);
      }
    } catch (e) {
      if(e is HandshakeException){
        Helpers.errorSnackBarDuration('Error', '$e', 3000);
      }
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url, token, date, page, per_page));
      }
      print('Error: $e $url') ;

    }
  }
  Future<dynamic> CertificateApiService(String url, String token, String date, int page, int per_page) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "date": " $date",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if(response.statusCode == 302){
        final location = response.headers['location'];
        if(location != null){
          return CertificateApiService(location, token, date, page, per_page);
        }

      }else if(response.statusCode ==500){
        print(response.body);
      }else{
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
        // print(response.body);
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url, token, date, page, per_page));
      }

      print('Error: $e $url') ;

    }
  }
  Future<dynamic> ApiServiceXX(String URL, String token, String date, int page, int per_page) async {
    final url = Uri.parse('$URL');

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer  $token',};

    final request = http.MultipartRequest('POST', url)
      ..fields['date'] = '$date'
      ..fields['page'] = '$page'
      ..fields['per_page'] = '$per_page'
      ..headers.addAll(headers);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print(responseData);
        return responseData;
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<dynamic> generalSettingsApiService(String url, String token, String date, int page, int per_page) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => generalSettingsApiService(url, token, date, page, per_page));
      }
      print('Error: $e $url') ;

    }
  }
  Future<dynamic> prescriptionLayoutSettingsApiService(String url, String token, String date, int page, int per_page) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => prescriptionLayoutSettingsApiService(url, token, date, page, per_page));
      }

      print('Error: $e $url') ;

    }
  }

}

