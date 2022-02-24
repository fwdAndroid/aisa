import 'package:flutter/material.dart';

class ForgotPasswordBu extends StatefulWidget {
  const ForgotPasswordBu({Key? key}) : super(key: key);

  @override
  _ForgotPasswordBuState createState() => _ForgotPasswordBuState();
}

class _ForgotPasswordBuState extends State<ForgotPasswordBu> {
  TextEditingController forotpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: forotpassword,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      'Please Enter Your Email To Regenerater The Password',
                  hintText: 'Enter your student Email'),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Colors.indigo,
                onPressed: () {},
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
