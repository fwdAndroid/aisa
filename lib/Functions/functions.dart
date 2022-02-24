import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/userdatamodel.dart';
import 'package:aisa/studentswork/bottomstudent/studentbottompage.dart';
import 'package:aisa/studentswork/StudentAuth/emailverification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthFunction extends ChangeNotifier {
  late User userdata;
  late bool error;

  late String profileurl;

  User get userDetails => userdata;
  bool get dataError => error;
  String get newprofileurl => profileurl;
  Future studentsignup(
      BuildContext context, String email, String password) async {
    try {
      final User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      userdata = user!;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("id", userdata.uid);
      sharedPreferences.setString("email", email);
      sharedPreferences.setString("password", password);
      error = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = true;
        showDialog(
            context: context,
            builder: (_) => LogoutOverlay(
                message: "Password is weak it lenght must be greater than 6 "));
      } else if (e.code == 'email-already-in-use') {
        error = true;
        showDialog(
            context: context,
            builder: (_) =>
                LogoutOverlay(message: "Email is already registered"));
      }
    } catch (e) {
      error = true;
      showDialog(
          // ignore: unnecessary_brace_in_string_interps
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(message: "${e}"));
    }
  }

  Future saveuserdata(
    BuildContext context,
    File file,
    String email,
    String phonenumber,
    String firstname,
    String lastname,
    String cityname,
    String university,
  ) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    UploadTask uploadTask =
        storageRef.child('${userdata.uid}.jpg').putFile(file);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    // ignore: unnecessary_null_comparison
    if (downloadUrl != null) {
      userfirestore.doc(firebaseUser!.uid).set({
        "block": false,
        "email": email,
        "userid": firebaseUser.uid,
        "phonenumber": phonenumber,
        "cityname": cityname,
        "firstname": firstname,
        "profile": downloadUrl,
        "lastname": lastname,
        "university": university,
        "profilevis": true,
        "namevis": true,
        "photovis": true,
        "universityvis": true,
        "citynamevis": true
      }).then((value) async {
        DocumentSnapshot docu = await userfirestore.doc(firebaseUser.uid).get();
        var userprovider = Provider.of<UserProvider>(context, listen: false);
        userprovider.getdata(Users.fromDocument(docu));
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
            builder: (_) => LogoutOverlay(
                message: "Some Error occur while saving information"));
      });
    } else {
      showDialog(
          // ignore: unnecessary_brace_in_string_interps
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(
              message: "Some Error occur while saving information"));
    }
  }

  Future saveuserdata2(
    BuildContext context,
    String email,
    String phonenumber,
    String firstname,
    String lastname,
    String cityname,
    String university,
  ) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    userfirestore.doc(firebaseUser!.uid).set({
      "block": false,
      "email": email,
      "userid": firebaseUser.uid,
      "phonenumber": phonenumber,
      "cityname": cityname,
      "firstname": firstname,
      "profile": "",
      "lastname": lastname,
      "university": university,
      "profilevis": true,
      "namevis": true,
      "photovis": true,
      "universityvis": true,
      "citynamevis": true
    }).then((value) async {
      DocumentSnapshot docu = await userfirestore.doc(userdata.uid).get();
      var userprovider = Provider.of<UserProvider>(context, listen: false);
      userprovider.getdata(Users.fromDocument(docu));
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
          builder: (_) => LogoutOverlay(
              message: "Some Error occur while saving information"));
    });
  }

  Future studentlogin(
      BuildContext context, String email, String password) async {
    try {
      final User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      userdata = user!;

      if (user != null && !user.emailVerified) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmailVerification()));
      } else if (user != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("id", userdata.uid);
        sharedPreferences.setString("email", email);
        sharedPreferences.setString("password", password);
        DocumentSnapshot document = await userfirestore.doc(user.uid).get();
        if (document.exists) {
          var userprovider = Provider.of<UserProvider>(context, listen: false);
          userprovider.getdata(Users.fromDocument(document));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => StudentBottomPage(
                      index: 0,
                    )),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmailVerification()));
        }

        error = false;
      }
      error = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = true;
        showDialog(
            context: context,
            builder: (_) =>
                LogoutOverlay(message: "Email Address not registered"));
      } else if (e.code == 'wrong-password') {
        error = true;
        showDialog(
            context: context,
            builder: (_) => LogoutOverlay(
                message: "Password you entered did not match our records. "));
      }
    }
  }

  Future updateprofile(
    BuildContext context,
    String profile,
    String email,
    String phonenumber,
    String firstname,
    String lastname,
    String cityname,
    String userid,
    String university,
    bool profilevis,
    bool namevis,
    bool photovis,
    bool universityvis,
    bool citynamevis,
  ) async {
    userfirestore.doc(userid).update({
      "email": email,
      "userid": userid,
      "phonenumber": phonenumber,
      "cityname": cityname,
      "firstname": firstname,
      "profile": profile,
      "lastname": lastname,
      "university": university,
      "profilevis": profilevis,
      "namevis": namevis,
      "photovis": photovis,
      "universityvis": universityvis,
      "citynamevis": citynamevis
    }).then((value) async {
      error = false;
      DocumentSnapshot docu = await userfirestore.doc(userid).get();
      var userprovider = Provider.of<UserProvider>(context, listen: false);
      userprovider.getdata(Users.fromDocument(docu));
      showDialog(
          context: context,
          builder: (_) => LogoutOverlay(message: "Profile Updated"));
    }).onError((error, stackTrace) {
      error = true;
      showDialog(
          // ignore: unnecessary_brace_in_string_interps
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(message: "Profile Not Updated"));
    });
  }

  Future updatephoto(
      BuildContext context, File file, String userid, String url) async {
    // ignore: unnecessary_brace_in_string_interps
    if (url != "") {
      FirebaseStorage.instance.refFromURL(url).delete();
    }
    UploadTask uploadTask = storageRef.child('${userid}.jpg').putFile(file);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    // ignore: unnecessary_null_comparison
    if (downloadUrl != null) {
      profileurl = downloadUrl;
      error = false;
    } else {
      error = true;
      showDialog(
          // ignore: unnecessary_brace_in_string_interps
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(
              message: "Profile image is not uploaded sucessfully"));
    }
  }

  resetEmail(BuildContext context, String newEmail) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(firebaseUser!.email);
    firebaseUser.updateEmail(newEmail).then((value) {
      sharedPreferences.setString("email", newEmail);
      error = false;
    }).catchError((onError) {
      error = true;
      showDialog(
          // ignore: unnecessary_brace_in_string_interps
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) =>
              LogoutOverlay(message: "Email address is not verify"));
    });
  }
}
