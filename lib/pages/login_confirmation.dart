// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sochi/api/auth_api.dart';
import 'package:sochi/colors/colors.dart';
import 'package:sochi/pages/page_selector.dart';
import 'package:sochi/pages/register_page.dart';

class LoginPageConfirmation extends StatefulWidget {
  const LoginPageConfirmation(
      {super.key, required this.email, required this.role});
  final String email;
  final String role;
  @override
  State<LoginPageConfirmation> createState() => _LoginPageConfirmationState();
}

class _LoginPageConfirmationState extends State<LoginPageConfirmation> {
  final TextEditingController emailController = TextEditingController();
  String role = "client";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Введите код",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Проверьте эл. почту",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            label: Text(
                          'Код из письма',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        )),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter your username.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorsApp.firstColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  )),
                              onPressed: () async {
                                Map res = await AuthApi.sendLoginCode(
                                    widget.email,
                                    widget.role,
                                    int.parse(emailController.text));
                                if (res['status']) {
                                  const storage = FlutterSecureStorage();
                                  await storage.delete(key: 'access_token');
                                  await storage.write(
                                      key: 'access_token',
                                      value: res['access_token']);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PageSelector()),
                                      (route) => false);
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "ВОЙТИ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 28),
                                ),
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
