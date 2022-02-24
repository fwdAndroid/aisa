import 'package:aisa/Functions/functions.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ChangeMobile extends StatefulWidget {
  ChangeMobile({Key? key}) : super(key: key);

  @override
  _ChangeMobileState createState() => _ChangeMobileState();
}

class _ChangeMobileState extends State<ChangeMobile> {
  TextEditingController existingMobileNumberController =
      TextEditingController();
  TextEditingController newMobileNumberController = TextEditingController();
  bool state = false;

  //Functions
  showAlertDialog(BuildContext context) {
    // Create button
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
      child: Text("Change Mobile Number"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget noButton = TextButton(
      child: Text("No, Thanks"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change Mobile Number"),
      content: Text("Are you to sure to reset the mobile number."),
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
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Change Mobile Number'),
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
                  'Change Your Existing Mobile Number',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w800,
                      fontSize: 15),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: existingMobileNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Existing Mobile Number',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: newMobileNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New  Mobile Number',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10)),
                // ignore: deprecated_member_use
                child: OutlineButton(
                  textColor: Colors.white,
                  color: Colors.pink,
                  child: Text('Update'),
                  onPressed: () {
                    setState(() {
                      state = true;
                    });
                    var provider =
                        Provider.of<AuthFunction>(context, listen: false);
                    provider
                        .updateprofile(
                            context,
                            provider.profileurl,
                            userprovider.userdata.email,
                            newMobileNumberController.text != ""
                                ? newMobileNumberController.text.trim()
                                : userprovider.userdata.phonenumber,
                            userprovider.userdata.firstname,
                            userprovider.userdata.lastname,
                            userprovider.userdata.cityname,
                            userprovider.userdata.userid,
                            userprovider.userdata.university,
                            userprovider.userdata.profilevis,
                            userprovider.userdata.namevis,
                            userprovider.userdata.photovis,
                            userprovider.userdata.universityvis,
                            userprovider.userdata.citynamevis)
                        .then((value) {
                      setState(() {
                        state = false;
                      });
                    });
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
