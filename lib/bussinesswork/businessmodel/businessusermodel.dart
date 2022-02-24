import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessUserModel{
    final String userid;
  final String businessname;
  final String address;
  final String email;
  final String phonenumber;
  final String abn;
  final bool verify;

 


 BusinessUserModel(
      {required this.userid,
     
      required this.email,
      required this.phonenumber,
       required this.address,
        required this.abn,
         required this.businessname,
          required this.verify
  });
  factory BusinessUserModel.fromDocument(DocumentSnapshot snapshot) {
    return BusinessUserModel(
        userid: snapshot['userid'],
        businessname: snapshot['businessname'],
        
        email: snapshot['email'],
        phonenumber: snapshot['phonenumber'],
        abn: snapshot["abn"],
        address: snapshot["address"],
        verify: snapshot["verify"]
  
        );
  }
}