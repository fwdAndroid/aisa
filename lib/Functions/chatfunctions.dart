import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/main.dart';

import 'package:aisa/studentswork/bottomstudent/chats/chatscreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class ChatFunction {
  Future creategroup(
      BuildContext context,
      String userid,
      String groupid,
      File image,
      String groupname,
      String groupdes,
      String location,
      String type) async {
    UploadTask uploadTask = storageRef.child("${image.path}").putFile(image);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    // ignore: unnecessary_null_comparison
    if (downloadUrl != null) {
      userfirestore.doc(userid).update({
        "groups": FieldValue.arrayUnion([groupid])
      });
      groups.doc(groupid).set({
        "groupname": groupname,
        "groupdescription": groupdes,
        "members": FieldValue.arrayUnion([userid]),
        "groupid": groupid,
        "image": downloadUrl,
        "location": location,
        "type": type
      }).then((value) {
        showDialog(
            context: context,
            builder: (_) => LogoutOverlay(message: "Group Created"));
      }).onError((error, stackTrace) {
        showDialog(
            context: context,
            // ignore: unnecessary_brace_in_string_interps
            builder: (_) => LogoutOverlay(message: "${error}"));
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => LogoutOverlay(message: "Some Error Occur"));
    }
  }

  Future createsinglechat(
    BuildContext context,
    String userid,
    String groupid,
    String image,
    String groupname,
    String groupdes,
    String location,
    String type,
    String user2,
    String user2uni,
    String user2city,
  ) async {
    userfirestore.doc(userid).update({
      "groups": FieldValue.arrayUnion([groupid])
    });
    userfirestore.doc(user2).update({
      "groups": FieldValue.arrayUnion([groupid])
    });
    groups.doc(groupid).set({
      "groupname": groupname,
      "groupdescription": groupdes,
      "members": FieldValue.arrayUnion([userid, user2]),
      "groupid": groupid,
      "image": image,
      "location": location,
      "type": type,
      "${groupid}_uni": user2uni,
      "${groupid}_city": user2city
    }).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    groupid: groupid,
                    groupname: groupname,
                    type: "user",
                    myid: userid,
                    members: [userid, user2],
                  )));
    }).onError((error, stackTrace) {
      showDialog(
          // ignore: unnecessary_brace_in_string_interps
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(message: "${error}"));
    });
  }
}
