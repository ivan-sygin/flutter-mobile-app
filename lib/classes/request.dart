import 'package:http/http.dart';

class RequestClass {
  int? id;
  int? status;
  String? shopName;
  String? itemCategory;
  double? itemRecommendedPrice;
  double? pricerInfo;
  String? photoURL;
  String? error;

  RequestClass(this.id, this.status, this.shopName, this.itemCategory,
      this.itemRecommendedPrice, this.pricerInfo, this.photoURL);
  RequestClass.error(this.error);

  factory RequestClass.fromJson(Map<String, dynamic> json) {
    if (json['status'] == false) {
      return RequestClass.error(json['error']);
    }
    final id = json['id'];
    final status = json['status'];
    final shopName = json['shop']['name'].toString();
    final itemCategory = json['category'].toString();
    final photo = json['photo'];
    final itemRecommendedPrice = json['price'];
    final pricerInfo = json['max_price'];

    final req = RequestClass(id, status, shopName, itemCategory,
        itemRecommendedPrice, pricerInfo, photo);
    return req;
  }
}
