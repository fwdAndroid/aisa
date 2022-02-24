import 'package:aisa/Functions/functions.dart';
import 'package:aisa/studentswork/bottomstudent/studentbottompage.dart';
import 'package:aisa/studentswork/forgotpassword/forgot.dart';
import 'package:aisa/studentswork/StudentAuth/studentregister.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool currentstate = false;
  bool view = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: currentstate,
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
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
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'LogIn As University Student',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.all(15),
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
                        labelText: 'Student Email',
                        hintText: 'Enter Your University Email Id'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: view,
                    controller: password,
                    validator: (value) {
                      if (value!.isNotEmpty && value.length > 6) {
                        return null;
                      } else {
                        return 'Password must be greater then 6';
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                view = !view;
                              });
                            },
                            child: view
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        hintText: 'Enter secure password'),
                  ),
                ),
                // ignore: deprecated_member_use
                Container(
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {
                      //FORGOT PASSWORD SCREEN GOES HERE
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ForgotPassword()));
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: MaterialButton(
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.pink,
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          currentstate = true;
                        });
                        var provider =
                            Provider.of<AuthFunction>(context, listen: false);
                        provider
                            .studentlogin(context, email.text.trim(),
                                password.text.trim())
                            .then((value) {
                          // ignore: unnecessary_null_comparison

                          setState(() {
                            currentstate = false;
                          });
                        }).onError((error, stackTrace) {
                          setState(() {
                            currentstate = false;
                          });
                        });
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(left: 15, right: 15),
                //   height: 50,
                //   width: 400,
                //   decoration: BoxDecoration(
                //       color: Colors.pink,
                //       borderRadius: BorderRadius.circular(10)),
                //   // ignore: deprecated_member_use
                //   child: FlatButton(
                // onPressed: () {
                // if (formkey.currentState!.validate()) {
                //   setState(() {
                //     currentstate = true;
                //   });
                //   var provider =
                //       Provider.of<AuthFunction>(context, listen: false);
                //   provider
                //       .studentlogin(context, email.text.trim(),
                //           password.text.trim())
                //       .then((value) {
                //     // ignore: unnecessary_null_comparison

                //     setState(() {
                //       currentstate = false;
                //     });
                //   }).onError((error, stackTrace) {
                //     setState(() {
                //       currentstate = false;
                //     });
                //   });
                // }
                // },
                //     child: Text(
                //       'Login',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 25,
                //         fontFamily: 'Montserrat',
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {
                      //Register Account
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegisterStudent()));
                    },
                    child: Text(
                      'New User? Create Account',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                      ),
                    ),
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
