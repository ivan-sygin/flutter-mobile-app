import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ApiController {
  static String ipServer = 'http://172.16.0.151:8011';

  static String testAdress = 'assets/json_examples/';
  static Future<Map> readJson(file) async {
    final String response =
        await rootBundle.loadString('assets/json_examples/${file}');

    return json.decode(response);
  }

  static Future<Map<String, dynamic>> getRequest(address, {auth}) async {
    Map<String, String> header = {"Content-Type": "application/json"};
    if (auth != null) {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: "access_token");
      header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
    }
    final res =
        await http.get(Uri.parse('${ipServer}${address}'), headers: header);
    final jsonBody = json.decode(utf8.decode(res.bodyBytes));

    return jsonBody;
  }

  static Future<Map<String, dynamic>> postRequest(address, {body, auth}) async {
    Map<String, String> header = {"Content-Type": "application/json"};
    if (auth != null) {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: "access_token");
      header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
    }
    final res = await http.post(Uri.parse('${ipServer}${address}'),
        headers: header, body: jsonEncode(body));
    final jsonBody = json.decode(utf8.decode(res.bodyBytes));
    return jsonBody;
  }
}
