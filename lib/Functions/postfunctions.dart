import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/main.dart';

import 'package:aisa/studentswork/bottomstudent/studentbottompage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostFunctions extends ChangeNotifier {
  Future addpost(
    BuildContext context,
    File image,
    String title,
    String description,
    String category,
    String location,
    String userid,
    String profile,
    String firstname,
    String id,
    String university,
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
        "userimage": profile,
        "postid": id,
        "likes": 0,
        "type": "image",
        "university": university,
        "timestamp": DateTime.now(),
        "username": firstname,
        "posttype": "student",
        "approved": true
      }).then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => StudentBottomPage(
                    index: 0,
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

  Future addposttext(
    BuildContext context,
    String title,
    String description,
    String category,
    String location,
    String userid,
    String profile,
    String firstname,
    String id,
    String university,
    String image,
  ) async {
    userpost.doc(id).set({
      "postimage": image,
      "title": title,
      "description": description,
      "category": category,
      "location": location,
      "userid": userid,
      "userimage": profile,
      "postid": id,
      "likes": 0,
      "type": "text",
      "posttype": "student",
      "university": university,
      "timestamp": DateTime.now(),
      "username": firstname,
      "approved": true
    }).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => StudentBottomPage(
                  index: 0,
                )),
        (Route<dynamic> route) => false,
      );
    }).onError((error, stackTrace) {
      showDialog(
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(message: "${error}"));
    });
  }
}

class EditPostData {

    Future updateposttext(
      BuildContext context,
      String title,
      String description,
      String category,
      String location,
      String id,
    ) async {
      userpost.doc(id).update({
        "title": title,
        "description": description,
        "category": category,
        "location": location,
        // "userimage": profile,
        "postid": id,
        // "comments": comments,
        // "type": "text",
        // "posttype": "student",
        // "timestamp": DateTime.now(),
        "approved": true
      }).then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => StudentBottomPage(
                    index: 0,
                  )),
          (Route<dynamic> route) => false,
        );
      }).onError((error, stackTrace) {
        showDialog(
            context: context,
            // ignore: unnecessary_brace_in_string_interps
            builder: (_) => LogoutOverlay(message: "${error}"));
      });
    }
  }

