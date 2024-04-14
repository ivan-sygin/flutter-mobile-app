import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sochi/pages/login_page.dart';
import 'package:sochi/pages/main_pages/common_page.dart';
import 'package:sochi/pages/page_selector.dart';
import 'package:sochi/pages/register_page.dart';
import 'package:sochi/pages/start_pade.dart';

Widget startController(BuildContext context) {
  final storage = FlutterSecureStorage();
  Future<bool> authorized() async {
    final token = await storage.read(key: "access_token");
    return token != null;
  }

  return FutureBuilder(
      future: authorized(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!)
            return PageSelector();
          else
            return StartPage();
        } else {
          return CircularProgressIndicator();
        }
      });
}
