import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController forotpassword = TextEditingController();
    final formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: forotpassword,
                 validator: (value) {
                      if (value!.isNotEmpty && value.contains("@")) {
                        return null;
                      } else {
                        return 'Please enter valid email';
                      }
                    },
                decoration: InputDecoration(
                  
                    border: OutlineInputBorder(),
                    labelText:
                        'Please Enter Your Email To Reset The Password',
                    hintText: 'Enter your student Email'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                // ignore: deprecated_member_use
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 50,
                  width: 150,
                  child: MaterialButton(
                    color: Colors.pink,
                    onPressed: () {
                      if(formkey.currentState!.validate()){
                        forgot(context, forotpassword.text.trim());
                      }
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  forgot(BuildContext context, String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email).then((value) {
      showDialog(
          context: context,
          builder: (_) => LogoutOverlay(
              message: "Please Check your email to reset password"));
    }).onError((error, stackTrace) {
      showDialog(
          context: context, builder: (_) => LogoutOverlay(message: "Email is not found in our records"));
    });
  }
}
