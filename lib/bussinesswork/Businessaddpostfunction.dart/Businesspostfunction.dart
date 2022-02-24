import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/bussinesswork/buisnessmainpage.dart';
import 'package:aisa/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BusinessPost{
   Future addpost(
    BuildContext context,
    File image,
    String title,
    String price,
    String description,
    String category,
    String location,
    String userid,
   
    String businessname,
    String id,
    String phone
    
  ) async {
    UploadTask uploadTask = storageRef.child("${image.path}").putFile(image);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    // ignore: unnecessary_null_comparison
    if (downloadUrl != null) {
      userpost.doc(id).set({
        "postimage": downloadUrl,
        "title": title,
        "description": description,
        "category": category,
        "location": location,
        "userid": userid,
        
        "postid": id,
        "likes": 0,
        "type": "image",
        "phone":phone,
        "price":price,
        "timestamp": DateTime.now(),
        "businessname": businessname,
        "posttype":"business",
        "approved":false
      }).then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>BusinessMainPage(
                  
                  )),
          (Route<dynamic> route) => false,
        );
      }).onError((error, stackTrace) {
        showDialog(
            context: context,
            // ignore: unnecessary_brace_in_string_interps
            builder: (_) => LogoutOverlay(message: "${error}"));
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => LogoutOverlay(message: "uploading error"));
    }
  }
}