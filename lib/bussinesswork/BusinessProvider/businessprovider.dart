import 'package:aisa/bussinesswork/businessmodel/businessusermodel.dart';
import 'package:flutter/cupertino.dart';

class BusinessProvider extends ChangeNotifier{
  late BusinessUserModel users;
 BusinessUserModel get userdata {
    return users;
  }

  void getdata(BusinessUserModel data) {
    this.users = data;
    notifyListeners();
  }
}