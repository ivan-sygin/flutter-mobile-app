import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sochi/api/photo_api/photo_api.dart';
import 'package:sochi/pages/create_request_pages/position_page.dart';

class CreatingRequestPage extends StatefulWidget {
  const CreatingRequestPage({super.key});

  @override
  State<CreatingRequestPage> createState() => _CreatingRequestPageState();
}

class _CreatingRequestPageState extends State<CreatingRequestPage> {
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

      setState(() {
        image = img;
      });
    }
  }

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
                  "Создание заявки",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Пожалуйста, сфотографируйте или прикрепите фотографию ценника",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                if (image == null)
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
                          color: Color.fromARGB(255, 234, 234, 234)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.photo_outlined, size: 100)],
                      ),
                    ),
                  )
                else
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
                              image: FileImage(File(image!.path)))),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () => getImage(ImageSource.camera),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt),
                            Text("Сделать фото")
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => getImage(ImageSource.gallery),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload),
                            Text("Прикрепить фото")
                          ],
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
                    if (image != null)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreatingPositionPage(url: urlImage!)));
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
      ),
    );
  }
}
