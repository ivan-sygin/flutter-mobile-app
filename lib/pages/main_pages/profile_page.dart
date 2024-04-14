import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sochi/colors/colors.dart';
import 'package:sochi/pages/start_pade.dart';
import 'package:sochi/storages/user_storage.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final textWho = {"controller": "Контроллер", "client": "Покупатель"};

  @override
  Widget build(BuildContext context) {
    final userStorage = Provider.of<UserStorage>(context, listen: true);
    if (userStorage.hasData) {
      return Scaffold(
        body: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://sun9-66.userapi.com/impg/-2-DRKBtedotrP4yjI9q2a_6G05CWwg9jCkgHw/N13p8o8uCKw.jpg?size=960x384&quality=95&crop=0,1307,1916,765&sign=9dec3ed0c40462d1b14363f980643f52&c_uniq_tag=5Wgxa8BAeu5EA1s_8DRBg8YiaZQYt-Cq1lmDjDZF-68&type=helpers&quot'))),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 270,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 2)),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: []),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: ColorsApp.firstColor,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 2)),
                            ],
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(userStorage.user!.photo))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Text(
                          "${userStorage.user!.name} ${userStorage.user!.surname}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Text(
                          textWho[userStorage.user!.role]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "120",
                                    style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    "Заявок",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "58",
                                    style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    "Принято",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "10",
                                    style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    "Отклонено",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: ElevatedButton(
                            onPressed: () async {
                              final storage = FlutterSecureStorage();
                              await storage.delete(key: "access_token");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StartPage()),
                                  (route) => false);
                            },
                            child: Text("Выйти")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
