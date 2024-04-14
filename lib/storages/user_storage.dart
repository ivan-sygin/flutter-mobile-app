import 'package:flutter/material.dart';
import 'package:sochi/classes/user.dart';

class UserStorage with ChangeNotifier {
  User? user;

  void setUserInfo(User? newUser) {
    user = newUser;
    notifyListeners();
  }

  bool get hasData => user != null;

  void updateAllListiners() {
    notifyListeners();
  }
}
