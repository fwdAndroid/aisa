import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Functions/functions.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/studentswork/StudentAuth/studentlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  bool state = false;
  //Functions
  showAlertDialog(BuildContext context) {
    // Create button
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
      child: Text("Change Email Address"),
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
      title: Text("Change Email Address"),
      content: Text("Are you to sure to reset the email address."),
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

  TextEditingController oldemailController = TextEditingController();
  TextEditingController newemailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Change Email'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: state,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Change Your Existing Email',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w800,
                      fontSize: 15),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: oldemailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Old Email Address',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: newemailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter New Email Address',
                  ),
                ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.indigo,
                  child: Text('Update'),
                  onPressed: () async {
                    var provider =
                        Provider.of<AuthFunction>(context, listen: false);
                    // ignore: unrelated_type_equality_checks
                    if (newemailController != "" && oldemailController != "") {
                      setState(() {
                        state = true;
                      });

                      final firebaseUser = FirebaseAuth.instance.currentUser;
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();

                      firebaseUser!
                          .updateEmail(newemailController.text.trim())
                          .then((value) {
                        sharedPreferences.setString(
                            "email", newemailController.text.trim());
                        provider
                            .updateprofile(
                          context,
                          userprovider.userdata.profile,
                          newemailController.text.trim(),
                          userprovider.userdata.phonenumber,
                          userprovider.userdata.firstname,
                          userprovider.userdata.lastname,
                          userprovider.userdata.cityname,
                          userprovider.userdata.userid,
                          userprovider.userdata.university,
                          userprovider.userdata.profilevis,
                          userprovider.userdata.namevis,
                          userprovider.userdata.photovis,
                          userprovider.userdata.universityvis,
                          userprovider.userdata.citynamevis,
                        )
                            .then((value) {
                          setState(() {
                            state = false;
                          });
                        });
                      }).catchError((onError) {
                        setState(() {
                          state = false;
                        });
                        showDialog(
                            context: context,
                            builder: (_) =>
                                // ignore: unnecessary_brace_in_string_interps
                                LogoutOverlay(message: "${onError}"));
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) =>
                              LogoutOverlay(message: "Add Fields data"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
