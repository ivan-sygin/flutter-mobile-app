import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PhotoApi {
  static String url = "";

  static Future<String> uploadPhoto(XFile file) async {
    var url = Uri.parse('http://79.174.80.94:8015/uploadPhoto');
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "access_token");
    var request = http.MultipartRequest('POST', url);
    request.headers['accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = "Bearer $token";
    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType('image', 'jpeg')));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print('Photo uploaded successfully');
      return Future(() => jsonDecode(response.body)['url']);
    } else {
      print('Error uploading photo. StatusCode: ${response.statusCode}');
    }
    return Future(() => "no_ssilka");
  }
}
