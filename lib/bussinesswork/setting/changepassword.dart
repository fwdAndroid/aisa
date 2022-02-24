import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Change Mobile Number',
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Change Your Existing Mobile Number',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 20, left: 30, right: 30),
            height: 60.0,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Old Password',
                  hintText: 'Old Password'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 30, right: 30),
            height: 60.0,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New Password',
                  hintText: 'New Password'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 30, right: 30),
            height: 60.0,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 30,
            ),
            height: 50.0,
            width: 200,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Colors.indigo,
              onPressed: () => {},
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
