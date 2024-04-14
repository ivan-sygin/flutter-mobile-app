import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sochi/api/main_api/controller.dart';
import 'package:sochi/classes/item.dart';
import 'package:sochi/classes/request.dart';
import 'package:sochi/classes/user.dart';

class MainApi {
  static bool test = true;

  static Future<List<ShopItem>> getAllRecommendedPrices() async {
    List<ShopItem> tmp = List.empty(growable: true);
    if (false) {
      Map jsonResponse = await ApiController.readJson('shop_items.json');
      for (var i = 0; i < jsonResponse['response'].length; i++) {
        tmp.add(ShopItem.fromJson(jsonResponse['response'][i]));
      }
    } else {
      Map jsonResponse =
          await ApiController.getRequest('/recommendations/all_products');
      for (var i = 0; i < jsonResponse['recommendations'].length; i++) {
        tmp.add(ShopItem.fromJson(jsonResponse['recommendations'][i]));
      }
    }
    return Future(() => tmp);
  }

  static Future<User> getUserInfo() async {
    User? tmp;
    if (false) {
      Map jsonResponse = await ApiController.readJson('user.json');
      tmp = User.fromJson(jsonResponse['response']);
    } else {
      final jsonResponse =
          await ApiController.getRequest('/users/me', auth: true);
      tmp = User.fromJson(jsonResponse['user']);
    }
    return Future(() => tmp!);
  }

  static Future<Map<int, RequestClass>> getMyRequests() async {
    Map<int, RequestClass> res = Map();

    Map jsonResponse = await ApiController.getRequest(
        '/applications/get_my_applications?status=0&count=10&offset=0',
        auth: true);

    for (var i = 0; i < jsonResponse['applications'].length; i++) {
      res[jsonResponse['applications'][i]['id']] =
          RequestClass.fromJson(jsonResponse['applications'][i]);
    }

    return res;
  }

  static Future<RequestClass> addNewRequest(name, photo, x, y) async {
    final body = {
      "photo": photo,
      "coordinates": [x, y],
      "name_product": name,
      "shop_id": 0
    };
    Map<String, dynamic> jsonResponse = await ApiController.postRequest(
        '/applications/add',
        auth: true,
        body: body);

    return RequestClass.fromJson(jsonResponse);
  }

  static Future<Map> updateRequest(reqId, photo, status) async {
    final body = {
      "application_id": reqId,
      "controller_photo": photo,
      "status": status,
      "controller_comment": "",
    };
    Map<String, dynamic> jsonResponse = await ApiController.postRequest(
        '/applications/changeStatus',
        auth: true,
        body: body);
    return jsonResponse;
  }
}
