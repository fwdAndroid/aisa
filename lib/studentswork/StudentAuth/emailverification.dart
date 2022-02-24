import 'dart:async';

import 'package:aisa/studentswork/StudentAuth/adduserdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;
  @override
  void initState() {
    user = auth.currentUser;
    user!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkverifiedemail();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 80),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 200,
                        child: Text('ASIP',textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontSize: 48,fontStyle: FontStyle.italic),)),
                  ),
                ),
            Container(
              child: Text(
                "We'll send an email to",
                // ${user!.email} ",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
             Container(
              child: Text(
                
                " ${user!.email} ",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
           
              Container(
              child: Text(
                "in 5 minutes. Open it up to activate your account. ",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 100),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Image.asset(
            //         'assets/images/australia.png',
            //         width: 100,
            //         height: 100,
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       Image.asset(
            //         'assets/images/aisa.png',
            //         width: 100,
            //         height: 100,
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       Image.asset(
            //         'assets/images/firebase.png',
            //         width: 100,
            //         height: 100,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> checkverifiedemail() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AddUserData()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
