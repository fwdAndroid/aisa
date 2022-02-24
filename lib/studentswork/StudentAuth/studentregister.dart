
import 'package:aisa/Functions/functions.dart';

import 'package:aisa/studentswork/StudentAuth/emailverification.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:provider/provider.dart';

class RegisterStudent extends StatefulWidget {
  RegisterStudent({Key? key}) : super(key: key);

  @override
  _RegisterStudentState createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool currentstate = false;
  bool view=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Registration'),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: currentstate,
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //First Name

              //Last Name

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

              //Email
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty && value.contains("@")) {
                      return null;
                    } else {
                      return 'Please enter only university domain email';
                    }
                  },
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Your University Email ID'),
                ),
              ),

              //Password
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10, bottom: 0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty && value.length > 6) {
                      return null;
                    } else {
                      return 'Password must be greater then 6';
                    }
                  },
                  controller: password,
                  obscureText: view,
                   
                  decoration: InputDecoration(
                     suffixIcon:GestureDetector(
                          onTap: (){
                            setState(() {
                              view=!view;
                            });
                          },
                          child:view? Icon(Icons.visibility):Icon(Icons.visibility_off)),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),

              //City

              // child: TextFormField(
              //   validator: (value) {
              //     if (value!.isNotEmpty) {
              //       return null;
              //     } else {
              //       return 'Please Add University Name';
              //     }
              //   },
              //   controller: university,
              //   decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: 'University',
              //       hintText: 'Select Your University'),
              // ),

              Container(
                margin:
                    EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10)),
                // ignore: deprecated_member_use
                child: FlatButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        currentstate = true;
                      });
                      var provider =
                          Provider.of<AuthFunction>(context, listen: false);
                      provider
                          .studentsignup(
                              context, email.text.trim(), password.text.trim())
                          .then((value) {
                        // ignore: unnecessary_null_comparison
                        if (provider.userDetails.uid != null &&
                            provider.dataError != true) {
                              setState(() {
                                currentstate=false;
                              });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmailVerification()));
                        } else {
                          setState(() {
                            currentstate = false;
                          });
                        }
                      });
                    }
                  },
                  child: Text(
                    'Register',
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
      ),
    );
  }
}
