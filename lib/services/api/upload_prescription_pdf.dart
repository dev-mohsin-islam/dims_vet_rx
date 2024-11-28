

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:http/io_client.dart';


Future<dynamic> uploadPdfApiService(String url, String token,File pdfFile,  patientId) async {
  var httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  var client = IOClient(httpClient);

  final uri = Uri.parse(url);
  final request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('file', pdfFile.path))
    ..fields['patient_id'] = patientId.toString()
    ..headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

  final response = await request.send();
  if (response.statusCode == 200) {

    var data = await response.stream.bytesToString();
    return jsonDecode(data);

  } else {
    print("Failed to upload: ${response.statusCode}");
  }
}

Future<void> deleteTemporaryFile(File file) async {
  var httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  var client = IOClient(httpClient);
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print("Error deleting temporary file: $e");
  }
}