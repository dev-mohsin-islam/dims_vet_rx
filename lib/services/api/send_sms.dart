
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dims_vet_rx/utilities/helpers.dart';

import 'package:http/io_client.dart';

Future sendSmsApiService2(String url, String token, String toPhoneNumber, String message) async {
  final String basicAuth = 'Bearer ${token}';
  var httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  var client = IOClient(httpClient);
  final response = await http.post(Uri.parse(url),
    headers: <String, String>{
      'Authorization': basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: <String, String>{
      'msisdn': toPhoneNumber,
      'messageBody': message,
    },
  );
  if (response.statusCode == 201 || response.statusCode == 200) {
    return response.body;
    Helpers.successSnackBar("Success", "Sent SMS Successfully");
  } else {
    print('Failed to send message: ${response.body}');
  }
}


Future sendSmsApiService(String url, String token, String toPhoneNumber, String message) async {

  var headers = {
    'Cookie': 'PHPSESSID=ms6mr4rs7pkm2ehrfh1igfmlpn'
  };

  var request = http.Request(
      'POST', Uri.parse('${url}?api_key=${token}&msg=${message}&to=${toPhoneNumber}'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
      print(response);
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}



