
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';


class ApiCreateDbToServer{

  Future<dynamic> ApiService(String url,method, String token, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "type": "number",
            "number": "0"
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "type": "number",
            "number": "0"
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url,method, token, name));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> PhysicianNotesApiService(String url,method, String token, notes) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${notes.name}",
            "details": "${notes.details}",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${notes.name}",
            "details": "${notes.details}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url,method, token, notes));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> TreatmentPlanApiService(String url,method, String token, plane) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${plane.name}",
            "details": "${plane.details}",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${plane.name}",
            "details": "${plane.details}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url,method, token, plane));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> HistoryNewApiService(String url,method, String token, name,category_id) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category_id": "$category_id",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category_id": "$category_id",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url,method, token, name));
      }
     print('Error: $e');

    }
  }


  Future<dynamic> ProfileApiService(String url,method, String token) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{

          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{

          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ProfileApiService(url,method, token));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> chamberApiService(String url,method, String token, chamberName) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'name': "$chamberName",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'name': "$chamberName",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => chamberApiService(url,method, token, chamberName));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> updatePasswordApiService(String url,method, String token, updatePassword) async {
    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
              'password': "$updatePassword",
          }),
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
     print('Error: $e');

    }
  }
  Future<dynamic> PatientHistoryApiService(String url,method, String token, patient_id, history_id) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "patient_id": "$patient_id",
            "history_id": history_id,
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "patient_id": "$patient_id",
            "history_id": history_id,
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => PatientHistoryApiService(url,method, token, patient_id, history_id));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> OnExaminationApiService(String url,method, String token, name, category_id) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category": "$category_id",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category": "$category_id",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => OnExaminationApiService(url,method, token, name, category_id));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> OnExaminationCatApiService(String url,method, String token, name) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => OnExaminationCatApiService(url,method, token, name));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> HistoryApiService(String url,method, String token, name, category) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category": "$category",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category": "$category",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => HistoryApiService(url,method, token, name, category));
      }
      print('Error: $e');
    }
  }
  Future<dynamic> CompanyApiService(String url,method, String token, company_name) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "company_name": "$company_name",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "company_name": "$company_name",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => CompanyApiService(url,method, token, company_name));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> GenericApiService(String url,method, String token, generic_name) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "generic_name": "$generic_name",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "generic_name": "$generic_name",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => GenericApiService(url,method, token, generic_name));
      }

      print('Error: $e');
    }
  }

  Future<dynamic> FavoriteApiServiceX(String url,method, String token, segment, favorite_id, status) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "segment": "$segment",
            "favorite_id": "$favorite_id",
            "status": "$status",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "segment": "$segment",
            "favorite_id": "$favorite_id",
            "status": "$status",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => FavoriteApiServiceX(url,method, token, segment, favorite_id, status));
      }

      print('Error: $e');
    }
  }

  Future<dynamic> FavoriteApiService(String url, method, String token, segment, favorite_id, status) async {
    try {
      var response;
      if (method == 'post') {
        response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "segment": "$segment",
            "favorite_id": "$favorite_id",
            "status": "$status",
          }),
        );
      } else if (method == 'put') {
        response = await http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "segment": "$segment",
            "favorite_id": "$favorite_id",
            "status": "$status",
          }),
        );
      } else if (method == 'delete') {
        response = await http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 302) {
        // Handle redirection
        // You can extract the redirection URL from the response headers and make a new request
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          return FavoriteApiService(redirectUrl, method, token, segment, favorite_id, status);
        } else {
          print('Redirect URL not found in response headers');
        }
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => FavoriteApiService(url,method, token, segment, favorite_id, status));
      }
      print('Error: $e');
    }
  }


  Future<dynamic> generalSettingsApiService(String url,method, String token, general_settings) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "general_settings": general_settings,
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "general_settings": general_settings,
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => generalSettingsApiService(url,method, token, general_settings));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> prescriptionLayoutSettingsApiService(String url,method, String token, prescription_layout) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "prescription_layout": prescription_layout,
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "prescription_layout": prescription_layout,
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => prescriptionLayoutSettingsApiService(url,method, token, prescription_layout));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> BrandApiService(String url,method, String token, brand_name, generic_id, company_id, form, strength) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "brand_name": "$brand_name",
            "generic_id": "$generic_id",
            "company_id": "$company_id",
            "form": "$form",
            "strength": "$strength",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "brand_name": "$brand_name",
            "generic_id": "$generic_id",
            "company_id": "$company_id",
            "form": "$form",
            "strength": "$strength",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => BrandApiService(url,method, token, brand_name, generic_id, company_id, form, strength));
      }

      print('Error: $e');
    }
  }

  Future<dynamic> AdviceApiService(
      String url,
      String method,
      String token,
      String label,
      String text,
      ) async {
    try {
      var response;
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode(<String, dynamic>{
        "label": label,
        "text": text,
      });

      // Select the appropriate HTTP method
      switch (method.toLowerCase()) {
        case 'post':
          response = await http.post(Uri.parse(url), headers: headers, body: body);
          break;
        case 'put':
          response = await http.put(Uri.parse(url), headers: headers, body: body);
          break;
        case 'delete':
          response = await http.delete(Uri.parse(url), headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method');
      }

      // Check for a successful response
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 302) {
        // Handle redirection if necessary
        final newUrl = response.headers['location'];
        if (newUrl != null) {
          return await AdviceApiService(newUrl, method, token, label, text);
        }
        throw Exception('Redirect location not found.');
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
        throw Exception('HTTP error ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        print('Network issue: Retrying in 3 seconds...');
        await Future.delayed(Duration(seconds: 3));
        return AdviceApiService(url, method, token, label, text);
      }
      print('Error: $e');
      return {'error': e.toString()};
    }
  }

  Future<dynamic> DoctorApiService(String url,method, String token, doctorObject) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${doctorObject.name}",
            "degree": "${doctorObject.degree}",
            "degeneration": "${doctorObject.designation}",
            "address": "${doctorObject.address}",
            "phone": "${doctorObject.phone}",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${doctorObject.name}",
            "degree": "${doctorObject.degree}",
            "degeneration": "${doctorObject.degeneration}",
            "address": "${doctorObject.address}",
            "phone": "${doctorObject.phone}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => DoctorApiService(url,method, token, doctorObject));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> ReferralApiService(String url,method, String token, referralObject) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "referred_to": "${referralObject.referred_to_uuid}",
            "special_notes": "${referralObject.special_notes}",
            "reason_for_referral": "${referralObject.reason_for_referral}",
            "clinical_Information": "${referralObject.clinical_information}",
            "app_id": "${referralObject.app_id}",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "referred_to": "${referralObject.referred_to}",
            "special_notes": "${referralObject.special_notes}",
            "reason_for_referral": "${referralObject.reason_for_referral}",
            "clinical_Information": "${referralObject.clinical_Information}",
            "app_id": "${referralObject.app_id}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => ReferralApiService(url,method, token, referralObject));
      }

      print('Error: $e');
    }
  }

  Future<dynamic> CertificateApiService(String url,method, String token, certificateObject) async {
    try {
      var response;
      if(method == 'post'){
        if(certificateObject.is_continue.toString().isNotEmpty && certificateObject.is_continue != null){
          response =  await  http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "guardian_sex": "male",
              "guardian_name": "${certificateObject.guardian_name}",
              "diagnosis": "${certificateObject.diagnosis}",
              "form": "${certificateObject.form}",
              "to": "${certificateObject.to}",
              "type": "${certificateObject.type}",
              "go_to": "${certificateObject.got_to}",
              "continue": "${certificateObject.is_continue}",
              "app_id":  parseInt(certificateObject.appointment_id),
            }),
          );
        }else if (certificateObject.is_continue.toString().isEmpty || certificateObject.is_continue == null){
          response =  await  http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "guardian_sex": "Male",
              "guardian_name": "${certificateObject.guardian_name}",
              "diagnosis": "${certificateObject.diagnosis}",
              "form": "${certificateObject.form}",
              "to": "${certificateObject.to}",
              "type": "${certificateObject.type}",
              "duration": "${certificateObject.duration}",
              "app_id":  parseInt(certificateObject.appointment_id),
            }),
          );
        }

      }else if(method == 'put'){
        if(certificateObject.is_continue.toString().isNotEmpty && certificateObject.is_continue != null){
          response =  await  http.put(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "guardian_sex": "${certificateObject.guardian_sex}",
              "guardian_name": "${certificateObject.guardian_name}",
              "diagnosis": "${certificateObject.diagnosis}",
              "form": "${certificateObject.form}",
              "to": "${certificateObject.to}",
              "type": "${certificateObject.type}",
              "duration": "${certificateObject.duration}",
              "go_to": "${certificateObject.got_to}",
              "continue": "${certificateObject.is_continue}",
              "app_id": "${certificateObject.app_id}",
            }),
          );
        }else if(method == 'put' && certificateObject.is_continue.toString().isEmpty && certificateObject.is_continue == null){

          response =  await  http.put(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "guardian_sex": "${certificateObject.guardian_sex}",
              "guardian_name": "${certificateObject.guardian_name}",
              "diagnosis": "${certificateObject.diagnosis + "-"}",
              "form": "${certificateObject.form}",
              "to": "${certificateObject.to}",
              "type": "${certificateObject.type}",
              "duration": "${certificateObject.duration}",
              "app_id": "${certificateObject.app_id}",
            }),
          );
        }

      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'date': "${certificateObject.date}",
          })
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']);
        return data;
      } else {

        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          CertificateApiService(url,method, token, certificateObject);
        });
      }
      print('Error: $e');
    }
  }

  Future<dynamic> HandOut(String url,method, String token, HandOutObject) async {

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "label": "${HandOutObject.label}",
            "text": "${HandOutObject.text}",

          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "label": "${HandOutObject.label}",
            "text": "${HandOutObject.text}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          HandOut(url,method, token, HandOutObject);
        });
      }

      print('Error: $e');
    }
  }

  Future<dynamic> PrescriptionApiServiceX(String url,method, String token, prescription, medicines,) async {
    try {

      if(method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          "app_id": "${prescription.uuid}",
          "note": "${prescription.note}",
          "cc_text": "${prescription.cc_text}",
          "improvement": '1',
          "next_visit": "",
          "diagnosis_text": "${prescription.diagnosis_text}",
          "onexam_text": "${prescription.onexam_text}",
          "investigation_text": "${prescription.investigation_text}",
          "investigation_report_text": "${prescription.investigation_report_text}",
          "special_note": "${prescription.special_notes}",
          "treatment_plan": "${prescription.treatment_plan}",
          "chamber_id": "${prescription.chamber_id}",
          "medicines" : medicines,

        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
        } else {
          print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          PrescriptionApiService(url, method, token,prescription, medicines);
        });
      }
      print( 'Error: $e');
    }
  }
  Future<dynamic> PrescriptionApiService(String url, String method, String token, dynamic prescription, dynamic medicines,) async {
    try {


      if (method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          "app_id": "${prescription.uuid}",
          "note": "${prescription.note}",
          "cc_text": "${prescription.cc_text}",
          "improvement": '1',
          "next_visit": "",
          "diagnosis_text": "${prescription.diagnosis_text}",
          "onexam_text": "${prescription.onexam_text}",
          "investigation_text": "${prescription.investigation_text}",
          "investigation_report_text": "${prescription.investigation_report_text}",
          "special_note": "${prescription.special_notes}",
          "treatment_plan": "${prescription.treatment_plan}",
          "chamber_id": "${prescription.chamber_id}",
          "medicines": medicines,
        });
        request.headers.addAll(headers);

        // Send request using the custom client
        http.StreamedResponse response = await request.send();
        print(response);
        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
        } else {
          print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
        }
      }
    } catch (e) {
      if (e is SocketException) {
        Future.delayed(Duration(seconds: 3), () {
          PrescriptionApiService(url, method, token, prescription, medicines);
        });
      }
      print('Error: $e');
    }
  }
  Future<dynamic> TemplateApiService(String url,method, String token,
      name,
      note,
      cc_text,
      diagnosis_text,
      onexam_text,
      investigation_text,
      investigation_report_text,
      medicines,
      ) async {
    try {

      if(method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          "name": name,
          "note": note,
          "cc_text": cc_text,
          "diagnosis_text": diagnosis_text,
          "onexam_text": onexam_text,
          "investigation_text": investigation_text,
          "investigation_report_text": investigation_report_text,
           "medicines" : medicines,

        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
        } else {
          print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          TemplateApiService(url, method, token, name, note, cc_text, diagnosis_text, onexam_text, investigation_text, investigation_report_text, medicines);
        });
      }

      print('Error: $e');
    }
  }

  Future<dynamic> AppointmentApiService(String url, method, String token, patientInfo, appointmentInfo) async {
    try {
    // Custom HttpClient
      HttpClient client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      if (method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));
        var customDob;
        if(patientInfo.dob != null && patientInfo.dob.isNotEmpty && patientInfo.dob != '') {
          customDob = patientInfo.dob;
        }
         var reversDate = appointmentInfo.date.split('-').reversed.join('-');
        var nextVisitDate;
        if(appointmentInfo.next_visit != null && appointmentInfo.next_visit.isNotEmpty && appointmentInfo.next_visit != '') {
          try{
            nextVisitDate = appointmentInfo.next_visit.split('-').reversed.join('-');
          }catch(e){
          }
        }
       print("patientInfo.blood_group");
       print(patientInfo.blood_group);
        request.fields.addAll({
          'patient_id': "${patientInfo.id}",
          'area':  "${patientInfo.area}",
          'date':  "${reversDate}",
          'dob': "${customDob}",
          'dys_blood_pressure': "${appointmentInfo.dys_blood_pressure}",
          'email': "${patientInfo.email}",
          'fee': "${appointmentInfo.fee}",
          'guardian_name': "${patientInfo.guardian_name}",
          'height': "${appointmentInfo.height}",
          'hip': "${appointmentInfo.hip}",
          'maritual_status': "${patientInfo.marital_status}",
          'name': "${patientInfo.name}",
          'next_visit': "${nextVisitDate}",
          'medicine': "${appointmentInfo.medicine}",
          'occupation': "${patientInfo.occupation}",
          'OFC': "${appointmentInfo.OFC}",
          'phone': "${patientInfo.phone}",
          'pulse': "${appointmentInfo.pulse}",
          'report_patient': "${appointmentInfo.report_patient}",
          'rr': "${appointmentInfo.rr}",
          'sex': "${patientInfo.sex}",
          'sl': "${appointmentInfo.serial}",
          'status': "${appointmentInfo.status}",
          'sys_blood_pressure': "${appointmentInfo.sys_blood_pressure}",
          'temparature': "${appointmentInfo.temparature}",
          'waist': "${appointmentInfo.waist}",
          'weight': "${appointmentInfo.weight}",
          'chamber_id': "${appointmentInfo.chamber_id}",
          'hospital_registration_no': "${appointmentInfo.hospital_id}",
          "blood_group": "${patientInfo.blood_group}",
        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
          // Process data if needed
        } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {

      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          AppointmentApiService(url, method, token,  patientInfo, appointmentInfo);
        });
      }

      print('Error: $e');
    }
  }
  Future<dynamic> PatientChildHistory(String url, method, String token, patientId, childHistory) async {
    try {


      if (method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.fields.addAll({
          'patient_id': "${patientId}",
          'details':  childHistory,

        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
          // Process data if needed
        } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {

      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          PatientChildHistory(url, method, token, patientId, childHistory);
        });
      }

      print('Error: $e');
    }
  }
  Future<dynamic> PatientGynAndObsHistory(String url, method, String token, patientId, gynAndObsHistory) async {
    try {


      if (method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.fields.addAll({
          'patient_id': "${patientId}",
          'details':  gynAndObsHistory,
        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
          // Process data if needed
        } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {

      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          PatientGynAndObsHistory(url, method, token, patientId, gynAndObsHistory);
        });
      }

      print('Error: $e');
    }
  }


}

class ifServError{


  Future<dynamic> ApiService(String url,method, String token, name) async {
    var httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var http = IOClient(httpClient);

    try {
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "type": "number",
            "number": "0"
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "type": "number",
            "number": "0"
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url,method, token, name));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> PhysicianNotesApiService(String url,method, String token, notes) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${notes.name}",
            "details": "${notes.details}",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${notes.name}",
            "details": "${notes.details}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url,method, token, notes));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> TreatmentPlanApiService(String url,method, String token, plane) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${plane.name}",
            "details": "${plane.details}",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${plane.name}",
            "details": "${plane.details}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url,method, token, plane));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> HistoryNewApiService(String url,method, String token, name,category_id) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);

      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category_id": "$category_id",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category_id": "$category_id",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ApiService(url,method, token, name));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> ProfileApiService(String url,method, String token) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{

          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{

          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        print('SocketException: $e');
        Future.delayed(Duration(seconds: 3), () => ProfileApiService(url,method, token));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> chamberApiService(String url,method, String token, chamberName) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'name': "$chamberName",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'name': "$chamberName",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => chamberApiService(url,method, token, chamberName));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> updatePasswordApiService(String url,method, String token, updatePassword) async {
    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
              'password': "$updatePassword",
          }),
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
     print('Error: $e');

    }
  }
  Future<dynamic> PatientHistoryApiService(String url,method, String token, patient_id, history_id) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "patient_id": "$patient_id",
            "history_id": history_id,
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "patient_id": "$patient_id",
            "history_id": history_id,
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => PatientHistoryApiService(url,method, token, patient_id, history_id));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> OnExaminationApiService(String url,method, String token, name, category_id) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category": "$category_id",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category": "$category_id",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => OnExaminationApiService(url,method, token, name, category_id));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> OnExaminationCatApiService(String url,method, String token, name) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => OnExaminationCatApiService(url,method, token, name));
      }
     print('Error: $e');

    }
  }
  Future<dynamic> HistoryApiService(String url,method, String token, name, category) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category": "$category",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "$name",
            "category": "$category",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => HistoryApiService(url,method, token, name, category));
      }
      print('Error: $e');
    }
  }
  Future<dynamic> CompanyApiService(String url,method, String token, company_name) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "company_name": "$company_name",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "company_name": "$company_name",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => CompanyApiService(url,method, token, company_name));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> GenericApiService(String url,method, String token, generic_name) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "generic_name": "$generic_name",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "generic_name": "$generic_name",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => GenericApiService(url,method, token, generic_name));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> AppointmentApiServiceX(String url, String method, String token, dynamic patientInfo, dynamic appointmentInfo) async {
    try {
      // Custom HttpClient
      HttpClient client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      if (method == 'post') {
        var dio = Dio();

        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        FormData formData = FormData.fromMap({
          'patient_id': "${patientInfo.id}",
          'area': "${patientInfo.area}",
          'date': "${appointmentInfo.date}",
          'dob': "${patientInfo.dob}",
          'dys_blood_pressure': "${appointmentInfo.dys_blood_pressure}",
          'email': "${patientInfo.email}",
          'fee': "${appointmentInfo.fee}",
          'guardian_name': "${patientInfo.guardian_name}",
          'height': "${appointmentInfo.height}",
          'hip': "${appointmentInfo.hip}",
          'maritual_status': "${patientInfo.marital_status}",
          'name': "${patientInfo.name}",
          'next_visit': "${appointmentInfo.next_visit}",
          'medicine': "${appointmentInfo.medicine}",
          'occupation': "${patientInfo.occupation}",
          'OFC': "${appointmentInfo.OFC}",
          'phone': "${patientInfo.phone}",
          'pulse': "${appointmentInfo.pulse}",
          'report_patient': "${appointmentInfo.report_patient}",
          'rr': "${appointmentInfo.rr}",
          'sex': "${patientInfo.sex}",
          'sl': "${appointmentInfo.serial}",
          'status': "${appointmentInfo.status}",
          'sys_blood_pressure': "${appointmentInfo.sys_blood_pressure}",
          'temparature': "${appointmentInfo.temparature}",
          'waist': "${appointmentInfo.waist}",
          'weight': "${appointmentInfo.weight}",
          'chamber_id': "${appointmentInfo.chamber_id}",
          'hospital_registration_no': "${appointmentInfo.hospital_id}",
        });

        Response response = await dio.post(url, data: formData, options: Options(headers: headers));

        if (response.statusCode == 200) {
          return response.data;
        } else {
          print('HTTP ${response.statusCode}: ${response.statusMessage} $url');
        }
      }
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.connectionTimeout) {
        Future.delayed(Duration(seconds: 3), () {
          AppointmentApiService(url, method, token, patientInfo, appointmentInfo);
        });
      }

      print('Error: $e');
    }
  }
  Future<dynamic> AppointmentApiService(String url, String method, String token, dynamic patientInfo, dynamic appointmentInfo) async {
    try {
      // Create a custom HttpClient that accepts all certificates
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      // Use IOClient from the http package
      IOClient ioClient = IOClient(httpClient);

      if (method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var customDob;
        if(patientInfo.dob != null && patientInfo.dob.isNotEmpty && patientInfo.dob != '') {
          customDob = patientInfo.dob;
        }
        var reversDate = appointmentInfo.date.split('-').reversed.join('-');
        var nextVisitDate;
        if(appointmentInfo.next_visit != null && appointmentInfo.next_visit.isNotEmpty && appointmentInfo.next_visit != '') {
          try{
            nextVisitDate = appointmentInfo.next_visit.split('-').reversed.join('-');
          }catch(e){
          }
        }
        print("patientInfo.blood_group");
        print(patientInfo.blood_group);
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          'patient_id': "${patientInfo.id}",
          'area': "${patientInfo.area}",
          'date': "${reversDate}",
          'dob': "${customDob}",
          'dys_blood_pressure': "${appointmentInfo.dys_blood_pressure}",
          'email': "${patientInfo.email}",
          'fee': "${appointmentInfo.fee}",
          'guardian_name': "${patientInfo.guardian_name}",
          'height': "${appointmentInfo.height}",
          'hip': "${appointmentInfo.hip}",
          'maritual_status': "${patientInfo.marital_status}",
          'name': "${patientInfo.name}",
          'next_visit': "${nextVisitDate}",
          'medicine': "${appointmentInfo.medicine}",
          'occupation': "${patientInfo.occupation}",
          'OFC': "${appointmentInfo.OFC}",
          'phone': "${patientInfo.phone}",
          'pulse': "${appointmentInfo.pulse}",
          'report_patient': "${appointmentInfo.report_patient}",
          'rr': "${appointmentInfo.rr}",
          'sex': "${patientInfo.sex}",
          'sl': "${appointmentInfo.serial}",
          'status': "${appointmentInfo.status}",
          'sys_blood_pressure': "${appointmentInfo.sys_blood_pressure}",
          'temparature': "${appointmentInfo.temparature}",
          'waist': "${appointmentInfo.waist}",
          'weight': "${appointmentInfo.weight}",
          'chamber_id': "${appointmentInfo.chamber_id}",
          'hospital_registration_no': "${appointmentInfo.hospital_id}",
          "blood_group": "${patientInfo.blood_group}",
        });
        request.headers.addAll(headers);

        // Send the request using IOClient
        http.StreamedResponse response = await ioClient.send(request);

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
        } else {
          print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
          return null;  // Ensure a null return on failure
        }
      }
    } catch (e) {
      if (e is SocketException) {
        print('Retrying after socket exception: $e');
        await Future.delayed(Duration(seconds: 3));
        return await AppointmentApiService(url, method, token, patientInfo, appointmentInfo);
      } else {
        print('Error: $e');
        return null;  // Ensure a null return on any other exception
      }
    }
  }
  Future<dynamic> FavoriteApiServiceX(String url,method, String token, segment, favorite_id, status) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "segment": "$segment",
            "favorite_id": "$favorite_id",
            "status": "$status",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "segment": "$segment",
            "favorite_id": "$favorite_id",
            "status": "$status",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => FavoriteApiServiceX(url,method, token, segment, favorite_id, status));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> FavoriteApiService(String url, method, String token, segment, favorite_id, status) async {
    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if (method == 'post') {
        response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "segment": "$segment",
            "favorite_id": "$favorite_id",
            "status": "$status",
          }),
        );
      } else if (method == 'put') {
        response = await http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "segment": "$segment",
            "favorite_id": "$favorite_id",
            "status": "$status",
          }),
        );
      } else if (method == 'delete') {
        response = await http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 302) {
        // Handle redirection
        // You can extract the redirection URL from the response headers and make a new request
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          return FavoriteApiService(redirectUrl, method, token, segment, favorite_id, status);
        } else {
          print('Redirect URL not found in response headers');
        }
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => FavoriteApiService(url,method, token, segment, favorite_id, status));
      }
      print('Error: $e');
    }
  }
  Future<dynamic> generalSettingsApiService(String url,method, String token, general_settings) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "general_settings": general_settings,
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "general_settings": general_settings,
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => generalSettingsApiService(url,method, token, general_settings));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> prescriptionLayoutSettingsApiService(String url,method, String token, prescription_layout) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "prescription_layout": prescription_layout,
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "prescription_layout": prescription_layout,
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => prescriptionLayoutSettingsApiService(url,method, token, prescription_layout));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> brandApiServiceX(String url, String method, String token, dynamic brandName, dynamic genericId, dynamic companyId, dynamic form, dynamic strength) async {
    try {
      var dio = Dio();
      dio.options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      Response response;

      if (method == 'post') {
        response = await dio.post(
          url,
          data: {
            "brand_name": "$brandName",
            "generic_id": "$genericId",
            "company_id": "$companyId",
            "form": "$form",
            "strength": "$strength",
          },
        );
      } else if (method == 'put') {
        response = await dio.put(
          url,
          data: {
            "brand_name": "$brandName",
            "generic_id": "$genericId",
            "company_id": "$companyId",
            "form": "$form",
            "strength": "$strength",
          },
        );
      } else if (method == 'delete') {
        response = await dio.delete(url);
      } else {
        throw UnsupportedError("Unsupported method: $method");
      }

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('HTTP ${response.statusCode}: ${response.statusMessage} $url');
      }
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.connectionTimeout) {
        Future.delayed(Duration(seconds: 3), () {
          brandApiService(url, method, token, brandName, genericId, companyId, form, strength);
        });
      }

      print('Error: $e');
    }
  }
  Future<dynamic> brandApiService(String url, String method, String token, dynamic brandName, dynamic genericId, dynamic companyId, dynamic form, dynamic strength) async {
    try {
      // Create a custom HttpClient that accepts all certificates
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      // Use IOClient from the http package
      IOClient ioClient = IOClient(httpClient);

      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      http.Response response;

      if (method == 'post') {
        response = await ioClient.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode({
            "brand_name": brandName,
            "generic_id": genericId,
            "company_id": companyId,
            "form": form,
            "strength": strength,
          }),
        );
      } else if (method == 'put') {
        response = await ioClient.put(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode({
            "brand_name": brandName,
            "generic_id": genericId,
            "company_id": companyId,
            "form": form,
            "strength": strength,
          }),
        );
      } else if (method == 'delete') {
        response = await ioClient.delete(
          Uri.parse(url),
          headers: headers,
        );
      } else {
        throw UnsupportedError("Unsupported method: $method");
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
        return null; // Ensure a null return on failure
      }
    } catch (e) {
      if (e is SocketException) {
        print('Retrying after socket exception: $e');
        await Future.delayed(Duration(seconds: 3));
        return await brandApiService(url, method, token, brandName, genericId, companyId, form, strength);
      } else {
        print('Error: $e');
        return null; // Ensure a null return on any other exception
      }
    }
  }

  Future<dynamic> AdviceApiService(
      String url,
      String method,
      String token,
      String label,
      String text,
      ) async {
    try {
      var response;
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode(<String, dynamic>{
        "label": label,
        "text": text,
      });

      // Select the appropriate HTTP method
      switch (method.toLowerCase()) {
        case 'post':
          response = await http.post(Uri.parse(url), headers: headers, body: body);
          break;
        case 'put':
          response = await http.put(Uri.parse(url), headers: headers, body: body);
          break;
        case 'delete':
          response = await http.delete(Uri.parse(url), headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method');
      }

      // Check for a successful response
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 302) {
        // Handle redirection if necessary
        final newUrl = response.headers['location'];
        if (newUrl != null) {
          return await AdviceApiService(newUrl, method, token, label, text);
        }
        throw Exception('Redirect location not found.');
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
        throw Exception('HTTP error ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        print('Network issue: Retrying in 3 seconds...');
        await Future.delayed(Duration(seconds: 3));
        return AdviceApiService(url, method, token, label, text);
      }
      print('Error: $e');
      return {'error': e.toString()};
    }
  }

  Future<dynamic> DoctorApiService(String url,method, String token, doctorObject) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${doctorObject.name}",
            "degree": "${doctorObject.degree}",
            "degeneration": "${doctorObject.designation}",
            "address": "${doctorObject.address}",
            "phone": "${doctorObject.phone}",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "name": "${doctorObject.name}",
            "degree": "${doctorObject.degree}",
            "degeneration": "${doctorObject.degeneration}",
            "address": "${doctorObject.address}",
            "phone": "${doctorObject.phone}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => DoctorApiService(url,method, token, doctorObject));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> ReferralApiService(String url,method, String token, referralObject) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "referred_to": "${referralObject.referred_to_uuid}",
            "special_notes": "${referralObject.special_notes}",
            "reason_for_referral": "${referralObject.reason_for_referral}",
            "clinical_Information": "${referralObject.clinical_information}",
            "app_id": "${referralObject.app_id}",
          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "referred_to": "${referralObject.referred_to}",
            "special_notes": "${referralObject.special_notes}",
            "reason_for_referral": "${referralObject.reason_for_referral}",
            "clinical_Information": "${referralObject.clinical_Information}",
            "app_id": "${referralObject.app_id}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () => ReferralApiService(url,method, token, referralObject));
      }

      print('Error: $e');
    }
  }
  Future<dynamic> CertificateApiService(String url,method, String token, certificateObject) async {
    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        if(certificateObject.is_continue.toString().isNotEmpty && certificateObject.is_continue != null){
          response =  await  http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "guardian_sex": "male",
              "guardian_name": "${certificateObject.guardian_name}",
              "diagnosis": "${certificateObject.diagnosis}",
              "form": "${certificateObject.form}",
              "to": "${certificateObject.to}",
              "type": "${certificateObject.type}",
              "go_to": "${certificateObject.got_to}",
              "continue": "${certificateObject.is_continue}",
              "app_id":  parseInt(certificateObject.appointment_id),
            }),
          );
        }else if (certificateObject.is_continue.toString().isEmpty || certificateObject.is_continue == null){
          response =  await  http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "guardian_sex": "Male",
              "guardian_name": "${certificateObject.guardian_name}",
              "diagnosis": "${certificateObject.diagnosis}",
              "form": "${certificateObject.form}",
              "to": "${certificateObject.to}",
              "type": "${certificateObject.type}",
              "duration": "${certificateObject.duration}",
              "app_id":  parseInt(certificateObject.appointment_id),
            }),
          );
        }

      }else if(method == 'put'){
        if(certificateObject.is_continue.toString().isNotEmpty && certificateObject.is_continue != null){
          response =  await  http.put(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "guardian_sex": "${certificateObject.guardian_sex}",
              "guardian_name": "${certificateObject.guardian_name}",
              "diagnosis": "${certificateObject.diagnosis}",
              "form": "${certificateObject.form}",
              "to": "${certificateObject.to}",
              "type": "${certificateObject.type}",
              "duration": "${certificateObject.duration}",
              "go_to": "${certificateObject.got_to}",
              "continue": "${certificateObject.is_continue}",
              "app_id": "${certificateObject.app_id}",
            }),
          );
        }else if(method == 'put' && certificateObject.is_continue.toString().isEmpty && certificateObject.is_continue == null){

          response =  await  http.put(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "guardian_sex": "${certificateObject.guardian_sex}",
              "guardian_name": "${certificateObject.guardian_name}",
              "diagnosis": "${certificateObject.diagnosis + "-"}",
              "form": "${certificateObject.form}",
              "to": "${certificateObject.to}",
              "type": "${certificateObject.type}",
              "duration": "${certificateObject.duration}",
              "app_id": "${certificateObject.app_id}",
            }),
          );
        }

      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }else if(method == 'get'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'date': "${certificateObject.date}",
          })
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']);
        return data;
      } else {

        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          CertificateApiService(url,method, token, certificateObject);
        });
      }
      print('Error: $e');
    }
  }
  Future<dynamic> HandOut(String url,method, String token, HandOutObject) async {

    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var http = IOClient(httpClient);
      var response;
      if(method == 'post'){
        response =  await  http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "label": "${HandOutObject.label}",
            "text": "${HandOutObject.text}",

          }),
        );
      }else if(method == 'put'){
        response =  await  http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "label": "${HandOutObject.label}",
            "text": "${HandOutObject.text}",
          }),
        );
      }else if(method == 'delete'){
        response =  await  http.delete(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      }


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          HandOut(url,method, token, HandOutObject);
        });
      }

      print('Error: $e');
    }
  }
  Future<dynamic> PrescriptionApiServiceX(String url,method, String token, prescription, medicines,) async {
    try {
      // Custom HttpClient
      HttpClient client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      if(method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          "app_id": "${prescription.uuid}",
          "note": "${prescription.note}",
          "cc_text": "${prescription.cc_text}",
          "improvement": '1',
          "next_visit": "",
          "diagnosis_text": "${prescription.diagnosis_text}",
          "onexam_text": "${prescription.onexam_text}",
          "investigation_text": "${prescription.investigation_text}",
          "investigation_report_text": "${prescription.investigation_report_text}",
          "special_note": "${prescription.special_notes}",
          "treatment_plan": "${prescription.treatment_plan}",
          "chamber_id": "${prescription.chamber_id}",
          "medicines" : medicines,

        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
        } else {
          print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          PrescriptionApiService(url, method, token,prescription, medicines);
        });
      }
      print( 'Error: $e');
    }
  }
  Future<dynamic> PrescriptionApiService(String url, String method, String token, dynamic prescription, dynamic medicines,) async {
    try {
      // Create a custom HttpClient that accepts all certificates
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      // Use IOClient from the http package
      IOClient ioClient = IOClient(httpClient);

      if (method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          "app_id": "${prescription.uuid}",
          "note": "${prescription.note}",
          "cc_text": "${prescription.cc_text}",
          "improvement": '1',
          "next_visit": "",
          "diagnosis_text": "${prescription.diagnosis_text}",
          "onexam_text": "${prescription.onexam_text}",
          "investigation_text": "${prescription.investigation_text}",
          "investigation_report_text": "${prescription.investigation_report_text}",
          "special_note": "${prescription.special_notes}",
          "treatment_plan": "${prescription.treatment_plan}",
          "chamber_id": "${prescription.chamber_id}",
          "medicines": medicines,
        });
        request.headers.addAll(headers);

        // Send the request using IOClient
        http.StreamedResponse response = await ioClient.send(request);

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
        } else {
          print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
          return null;  // Ensure a null return on failure
        }
      }
    } catch (e) {
      if (e is SocketException) {
        print('Retrying after socket exception: $e');
        await Future.delayed(Duration(seconds: 3));
        return await PrescriptionApiService(url, method, token, prescription, medicines);
      } else {
        print('Error: $e');
        return null;  // Ensure a null return on any other exception
      }
    }
  }
  Future<dynamic> TemplateApiService(String url,method, String token, name, note, cc_text, diagnosis_text, onexam_text, investigation_text, investigation_report_text, medicines,) async {
    try {

      if(method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          "name": name,
          "note": note,
          "cc_text": cc_text,
          "diagnosis_text": diagnosis_text,
          "onexam_text": onexam_text,
          "investigation_text": investigation_text,
          "investigation_report_text": investigation_report_text,
           "medicines" : medicines,

        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
        } else {
          print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {
      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          TemplateApiService(url, method, token, name, note, cc_text, diagnosis_text, onexam_text, investigation_text, investigation_report_text, medicines);
        });
      }

      print('Error: $e');
    }
  }
  Future<dynamic> PatientChildHistory(String url, method, String token, patientId, childHistory) async {
    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var client = IOClient(httpClient);
      if (method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.fields.addAll({
          'patient_id': "${patientId}",
          'details':  childHistory,

        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
          // Process data if needed
        } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {

      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          PatientChildHistory(url, method, token, patientId, childHistory);
        });
      }

      print('Error: $e');
    }
  }
  Future<dynamic> PatientGynAndObsHistory(String url, method, String token, patientId, gynAndObsHistory) async {
    try {
      var httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var client = IOClient(httpClient);

      if (method == 'post') {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.fields.addAll({
          'patient_id': "${patientId}",
          'details':  gynAndObsHistory,
        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var data = await response.stream.bytesToString();
          return jsonDecode(data);
          // Process data if needed
        } else {
         print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url') ;
        }
      }
    } catch (e) {

      if(e is SocketException){
        Future.delayed(Duration(seconds: 3), () {
          PatientGynAndObsHistory(url, method, token, patientId, gynAndObsHistory);
        });
      }

      print('Error: $e');
    }
  }


}