import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/mainpage.dart';
import 'package:aisa/studentswork/StudentAuth/studentlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangedPassword extends StatefulWidget {
  const ChangedPassword({Key? key}) : super(key: key);

  @override
  _ChangedPasswordState createState() => _ChangedPasswordState();
}

class _ChangedPasswordState extends State<ChangedPassword> {
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confrimpasswordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool state = false;
  //Functions
  showAlertDialog(BuildContext context) {
    // Create button
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
      child: Text("Change Password"),
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StudentLogin()));
      },
    );

    // ignore: deprecated_member_use
    Widget noButton = FlatButton(
      child: Text("No, Thanks"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change Password"),
      content: Text("Are you to sure to reset the password."),
      actions: [okButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Change  Password'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: state,
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Change Your Existing Password',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w800,
                        fontSize: 15),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter existing password';
                      }
                      return null;
                    },
                    controller: oldpasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Old Password',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter New Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: newpasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Password',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Confirm Password';
                      } else if (confrimpasswordController.text !=
                          newpasswordController.text) {
                        return 'Please make sure your new passwords match';
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: confrimpasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10)),
                  // ignore: deprecated_member_use
                  child: OutlineButton(
                    textColor: Colors.white,
                    color: Colors.pink,
                    child: Text('Update',
                        style: TextStyle(
                          fontSize: 15,
                        )),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          state = true;
                        });
                        final firebaseUser = FirebaseAuth.instance.currentUser;
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        firebaseUser!
                            .updatePassword(newpasswordController.text.trim())
                            .then((value) async {
                          await FirebaseAuth.instance.signOut().then((value) {
                            sharedPreferences.clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                              (Route<dynamic> route) => false,
                            );
                          });
                        }).onError((error, stackTrace) {
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  // ignore: unnecessary_brace_in_string_interps
                                  LogoutOverlay(message: "${error}"));
                          setState(() {
                            state = false;
                          });
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
