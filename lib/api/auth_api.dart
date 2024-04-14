import 'package:sochi/api/api.dart';

class AuthApi {
  static Future<bool> requestEmailConfiramtion(email, role) async {
    final json = await ApiCustom.postRequest('/auth/auth',
        body: {"email": email, "role": role});

    return json['status'];
  }

  static Future<Map> sendLoginCode(email, role, code) async {
    final json = await ApiCustom.postRequest('/auth/auth_check',
        body: {"email": email, "role": role, "code": code});
    return json;
  }
}
