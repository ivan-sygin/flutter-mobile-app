// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sochi/api/auth_api.dart';
import 'package:sochi/colors/colors.dart';
import 'package:sochi/pages/login_confirmation.dart';
import 'package:sochi/pages/page_selector.dart';
import 'package:sochi/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                        "Вход",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Пожалуйста, войдите в аккаунт",
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
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            label: Text(
                          'Номер телефона',
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
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButton(
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            isExpanded: true,
                            value: role,
                            items: [
                              DropdownMenuItem(
                                  value: "client", child: Text("Клиент")),
                              DropdownMenuItem(
                                  value: "controller", child: Text("Работник"))
                            ],
                            onChanged: (d) {
                              setState(() {
                                role = d!;
                              });
                            }),
                      ),
                      SizedBox(
                        height: 30,
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
                                bool res =
                                    await AuthApi.requestEmailConfiramtion(
                                        emailController.text, role);
                                if (res)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginPageConfirmation(
                                                email: emailController.text,
                                                role: role)),
                                  );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "ПРОДОЛЖИТЬ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 28),
                                ),
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return RegisterPage();
                                    },
                                  ));
                                },
                                child: Text(
                                  "Забыли пароль?",
                                  style: TextStyle(color: ColorsApp.firstColor),
                                )),
                          ],
                        ),
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
