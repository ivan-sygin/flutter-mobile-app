import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiCustom {
  static String ipServer = 'http://79.174.80.94:8000';
  static Future<Map> postRequest(address, {body}) async {
    final res = await http.post(Uri.parse('${ipServer}${address}'),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    final jsonBody = json.decode(utf8.decode(res.bodyBytes));
    return jsonBody;
  }
}
