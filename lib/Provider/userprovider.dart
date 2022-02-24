import 'package:aisa/models/userdatamodel.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late Users users;
  Users get userdata {
    return users;
  }

  void getdata(Users data) {
    this.users = data;
    notifyListeners();
  }
}
