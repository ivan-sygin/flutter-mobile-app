import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sochi/api/main_api/main_api.dart';
import 'package:sochi/api/photo_api/photo_api.dart';
import 'package:sochi/classes/request.dart';
import 'package:sochi/colors/colors.dart';
import 'package:sochi/pages/page_selector.dart';
import 'package:sochi/storages/requests_storage.dart';

class ControllerStartPage extends StatefulWidget {
  const ControllerStartPage({super.key, required this.rqcls});
  final RequestClass rqcls;
  @override
  State<ControllerStartPage> createState() => _ControllerStartPageState();
}

class _ControllerStartPageState extends State<ControllerStartPage> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String? urlImage;
  //Image.file(File(image!.path))
  int? _selectedValue;
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(
      source: media,
      imageQuality: 25,
    );
    if (img != null) {
      urlImage = await PhotoApi.uploadPhoto(img!);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Фото загружено")));
      setState(() {
        image = img;
      });
    }
  }

  bool _loading = false;

  Future<Map?> updateRequest() async {
    if (urlImage == null) return null;
    setState(() {
      _loading = true;
    });
    final res = await MainApi.updateRequest(widget.rqcls.id!, urlImage!, 1);
    print(res);
    setState(() {
      _loading = false;
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PageSelector()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Исправление цены",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Пожалуйста, сфотографируйте или прикрепите новую фотографию ценника",
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
                              image: NetworkImage(widget.rqcls.photoURL!))),
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
                          getImage(ImageSource.camera);
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt),
                                Text(
                                  "Сделать фото новой цены",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload),
                                Text(
                                  "Прикрепить фото новой цены",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      updateRequest();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Продолжить",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.normal),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black54,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Проверяем Вашу фотографию",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
