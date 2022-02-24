import 'package:aisa/AppId/appid.dart';
import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UniversityRequest extends StatefulWidget {
  UniversityRequest({Key? key}) : super(key: key);

  @override
  _UniversityRequestState createState() => _UniversityRequestState();
}

class _UniversityRequestState extends State<UniversityRequest> {
  TextEditingController university = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController name = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("University Request"),
      ),
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: TextFormField(
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return 'Please Enter City Name';
                  }
                },
                controller: city,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City',
                    hintText: 'Enter City Name'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: TextFormField(
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return 'Please Enter Your University Name';
                  }
                },
                controller: university,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'University',
                    hintText: 'Enter University Name'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: TextFormField(
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return 'Please Enter Your Name';
                  }
                },
                controller: name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter Your Name'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
              height: 50,
              width: 400,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(20)),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    User? user = FirebaseAuth.instance.currentUser;
                    universityrequest.doc().set({
                      "cityname": city.text.trim(),
                      "university": university.text.trim(),
                      "name": name.text.trim(),
                      "email": user!.email
                    }).then((value) {
                      showDialog(
                          context: context,
                          builder: (_) => LogoutOverlay(
                              message: "Your Request is now send to admin"));
                    });
                  }
                },
                child: Text(
                  'Send Request',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Montserrat'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
