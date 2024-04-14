import 'package:flutter/material.dart';
import 'package:sochi/api/main_api/main_api.dart';
import 'package:sochi/classes/request.dart';
import 'package:sochi/classes/user.dart';

class RequestStorage with ChangeNotifier {
  Map<int, RequestClass> requests = Map();

  void loadRequestsFromServer() async {
    requests = await MainApi.getMyRequests();
    notifyListeners();
  }

  void addRequestLocal(RequestClass rs) {
    if (rs.error == null) return;
    requests[rs.id!] = rs;
    notifyListeners();
  }
}
