import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
Future<File> _convertUint8ListToFile(Uint8List imageData) async {
  // Get the temporary directory of the device
  Directory tempDir = await getTemporaryDirectory();

  // Create a temporary file path
  String tempPath = '${tempDir.path}/temp_image.jpg';

  // Write the image data to the file
  File tempFile = File(tempPath);
  return await tempFile.writeAsBytes(imageData);
}
Future patientDiseaseImageApiService(String url,String token, method, Uint8List imageData, irReportObject) async {

  try {
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };


     var request = http.MultipartRequest('POST', Uri.parse(url));
     request.headers.addAll(headers);
     request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.png'));

     // Add chamber_id to the request body
     request.fields['appointment_id'] = irReportObject.app_id.toString();
     request.fields['disease_name'] = irReportObject.disease_name.toString();
     request.fields['title'] = irReportObject.title.toString();
     request.fields['details'] = irReportObject.details.toString();

     http.StreamedResponse response = await request.send();

     if (response.statusCode == 200) {
       var data = await response.stream.bytesToString();
       return jsonDecode(data);
     } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
     }
  } catch (e) {
    if(e is SocketException){
      Future.delayed(Duration(seconds: 3), () => patientDiseaseImageApiService(url,token, method, imageData, irReportObject));
    }
    print('Error: $e');
  }
}
Future profileImageApiService(String url,String token, method, Uint8List imageData, profileIngoObj) async {

  try {
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };


     var request = http.MultipartRequest('POST', Uri.parse(url));
     request.headers.addAll(headers);
     request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.png'));
     //
     // // Add chamber_id to the request body
     // request.fields['appointment_id'] = irReportObject.app_id.toString();
     // request.fields['disease_name'] = irReportObject.disease_name.toString();
     // request.fields['title'] = irReportObject.title.toString();
     // request.fields['details'] = irReportObject.details.toString();

     http.StreamedResponse response = await request.send();

     if (response.statusCode == 200) {
       var data = await response.stream.bytesToString();
       return jsonDecode(data);
     } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
     }
  } catch (e) {
    if(e is SocketException){
      Future.delayed(Duration(seconds: 3), () => patientDiseaseImageApiService(url,token, method, imageData, profileIngoObj));
    }
    print('Error: $e');
  }
}

Future patientIRApiService(String url,String token, method, Uint8List imageData, irReportObject) async {

  try {
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
     var request = http.MultipartRequest('POST', Uri.parse(url));
     request.headers.addAll(headers);
     request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.png'));

     // Add chamber_id to the request body
     request.fields['appointment_id'] = irReportObject.app_id.toString();
     request.fields['inv_name'] = irReportObject.inv_name.toString();
     request.fields['title'] = irReportObject.title.toString();
     request.fields['details'] = irReportObject.details.toString();

     http.StreamedResponse response = await request.send();

     if (response.statusCode == 200) {
       var data = await response.stream.bytesToString();
       return jsonDecode(data);
     } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
     }



  } catch (e) {
    print('Error: $e');
  }
}

Future imageUpload(String url, Uint8List imageData,imageType, chamberId, String token) async {

  try {
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    File imageFile = await _convertUint8ListToFile(imageData);

    // Add chamber_id to the request body
    request.fields['chamberid'] = chamberId.toString();
    request.files.add(
      await http.MultipartFile.fromPath(
        '${imageType}',
        imageFile.path,
        contentType: MediaType(
            'image', 'jpeg'), // Change content type as needed
      ),
    );

    // Add headers
    request.headers.addAll(headers);

    // Send request and handle response
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }catch (e) {
    print('Error: $e');
  }
}
//
// Future sendFooterImageToServer(String url, Uint8List imageData,imageType, chamberId, String token) async {
//   // try {
//   //   var headers = {
//   //     'Authorization': 'Bearer $token',
//   //     'Accept': 'application/json',
//   //   };
//   //
//   //   var request = http.MultipartRequest('POST', Uri.parse(url));
//   //   request.headers.addAll(headers);
//   //   request.files.add(http.MultipartFile.fromBytes('footer', imageData, filename: 'image.jpg'));
//   //   request.fields['chamberid'] = chamber_id.toString();
//   //
//   //   http.StreamedResponse response = await request.send();
//   //
//   //   if (response.statusCode == 200) {
//   //     var data = await response.stream.bytesToString();
//   //     return jsonDecode(data);
//   //   } else {
//   //     print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
//   //   }
//   // } catch (e) {
//   //   print( 'Error: $e');
//   // }
//   try {
//     var headers = {
//       'Authorization': 'Bearer $token',
//       'Accept': 'application/json',
//     };
//
//     var request = http.MultipartRequest('POST', Uri.parse(url));
//     File imageFile = await _convertUint8ListToFile(imageData);
//
//     // Add chamber_id to the request body
//     request.fields['chamberid'] = chamberId.toString();
//
//     // Add the image file
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         '${imageType}',
//         imageFile.path,
//         contentType: MediaType(
//             'image', 'jpeg'), // Change content type as needed
//       ),
//     );
//
//     // Add headers
//     request.headers.addAll(headers);
//
//     // Send request and handle response
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       print(await response.stream.bytesToString());
//     } else {
//       print(response.reasonPhrase);
//     }
//   }catch (e) {
//     print('Error: $e');
//   }
// }
Future sendDigitalSignImageToServer(String url, Uint8List imageData, chamber_id, String token) async {
  try {
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.jpg'));
    request.fields['chamber_id'] = chamber_id.toString();

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
    }
  } catch (e) {
    print( 'Error: $e');
  }
}
Future sendRxIconImageToServer(String url, Uint8List imageData, chamber_id, String token) async {
  try {
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.jpg'));
    request.fields['chamber_id'] = chamber_id.toString();

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
    }
  } catch (e) {
    print( 'Error: $e');
  }
}
Future error_patientDiseaseImageApiService(String url,String token, method, Uint8List imageData, irReportObject) async {
  var httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  var client = IOClient(httpClient);
  try {
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };


     var request = http.MultipartRequest('POST', Uri.parse(url));
     request.headers.addAll(headers);
     request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.png'));

     // Add chamber_id to the request body
     request.fields['appointment_id'] = irReportObject.app_id.toString();
     request.fields['disease_name'] = irReportObject.disease_name.toString();
     request.fields['title'] = irReportObject.title.toString();
     request.fields['details'] = irReportObject.details.toString();

     http.StreamedResponse response = await request.send();

     if (response.statusCode == 200) {
       var data = await response.stream.bytesToString();
       return jsonDecode(data);
     } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
     }
  } catch (e) {
    if(e is SocketException){
      Future.delayed(Duration(seconds: 3), () => patientDiseaseImageApiService(url,token, method, imageData, irReportObject));
    }
    print('Error: $e');
  }
}
Future error_profileImageApiService(String url,String token, method, Uint8List imageData, profileIngoObj) async {
  var httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  var client = IOClient(httpClient);
  try {
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };


     var request = http.MultipartRequest('POST', Uri.parse(url));
     request.headers.addAll(headers);
     request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.png'));
     //
     // // Add chamber_id to the request body
     // request.fields['appointment_id'] = irReportObject.app_id.toString();
     // request.fields['disease_name'] = irReportObject.disease_name.toString();
     // request.fields['title'] = irReportObject.title.toString();
     // request.fields['details'] = irReportObject.details.toString();

     http.StreamedResponse response = await request.send();

     if (response.statusCode == 200) {
       var data = await response.stream.bytesToString();
       return jsonDecode(data);
     } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
     }
  } catch (e) {
    if(e is SocketException){
      Future.delayed(Duration(seconds: 3), () => patientDiseaseImageApiService(url,token, method, imageData, profileIngoObj));
    }
    print('Error: $e');
  }
}

Future error_patientIRApiService(String url,String token, method, Uint8List imageData, irReportObject) async {

  try {
    var httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var client = IOClient(httpClient);
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
     var request = http.MultipartRequest('POST', Uri.parse(url));
     request.headers.addAll(headers);
     request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.png'));

     // Add chamber_id to the request body
     request.fields['appointment_id'] = irReportObject.app_id.toString();
     request.fields['inv_name'] = irReportObject.inv_name.toString();
     request.fields['title'] = irReportObject.title.toString();
     request.fields['details'] = irReportObject.details.toString();

     http.StreamedResponse response = await request.send();

     if (response.statusCode == 200) {
       var data = await response.stream.bytesToString();
       return jsonDecode(data);
     } else {
       print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
     }



  } catch (e) {
    print('Error: $e');
  }
}

Future error_sendHeaderImageToServer(String url, Uint8List imageData, chamberId, String token) async {

  try {
    var httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var client = IOClient(httpClient);
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes('header', imageData, filename: 'image.png'));

    // Add chamber_id to the request body
    request.fields['chamberid'] = chamberId.toString();

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
     return jsonDecode(data);
    } else {
      print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future error_sendFooterImageToServer(String url, Uint8List imageData, chamber_id, String token) async {
  try {
    var httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var client = IOClient(httpClient);
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes('footer', imageData, filename: 'image.jpg'));
    request.fields['chamberid'] = chamber_id.toString();

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
    }
  } catch (e) {
    print( 'Error: $e');
  }
}
Future error_sendDigitalSignImageToServer(String url, Uint8List imageData, chamber_id, String token) async {
  try {
    var httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var client = IOClient(httpClient);
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.jpg'));
    request.fields['chamber_id'] = chamber_id.toString();

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
    }
  } catch (e) {
    print( 'Error: $e');
  }
}
Future error_sendRxIconImageToServer(String url, Uint8List imageData, chamber_id, String token) async {
  try {
    var httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var client = IOClient(httpClient);
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes('file', imageData, filename: 'image.jpg'));
    request.fields['chamber_id'] = chamber_id.toString();

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      print('HTTP ${response.statusCode}: ${response.reasonPhrase} $url');
    }
  } catch (e) {
    print( 'Error: $e');
  }
}
