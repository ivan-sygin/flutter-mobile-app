import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sochi/colors/colors.dart';
import 'package:sochi/pages/create_request_pages/first_info_page.dart';

class SelectedCreateRequest extends StatefulWidget {
  const SelectedCreateRequest({super.key});

  @override
  State<SelectedCreateRequest> createState() => _SelectedCreateRequestState();
}

class _SelectedCreateRequestState extends State<SelectedCreateRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Выберите тип заявки",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Пожалуйста, выберите что Вы хотите сообщить",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              color: Colors.black26,
                              offset: Offset(0, 3))
                        ],
                        color: Color.fromARGB(255, 234, 234, 234),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'http://79.174.80.94:8015/photos/1c6d2d4705ca97f0d8abdafbffa998befc7a59d6.jpeg'))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreatingRequestPage()));
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: ColorsApp.fourthColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.monetization_on),
                            Text("Цена завышена")
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: ColorsApp.fourthColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.no_photography),
                            Text(
                              "Отсутсвие социальной цены",
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
