import 'package:flutter/material.dart';

class ShopItem {
  int? id;
  String? name;
  double? recommendedPrice;
  String? imageURL;
  ShopItem(
      {required this.id,
      required this.name,
      required this.recommendedPrice,
      required this.imageURL});

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    final id = json['id'],
        name = json['name'],
        recommendedPrice = json['price'],
        imageURL = json['photo'];
    String image = imageURL;
    if (imageURL == "")
      image =
          "https://www.downloadclipart.net/large/4269-ambox-blue-question-design.png";

    return ShopItem(
      id: id,
      name: name,
      recommendedPrice: recommendedPrice,
      imageURL: image,
    );
  }
}
