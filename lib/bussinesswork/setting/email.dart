import 'package:flutter/material.dart';

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Change Email'),
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Change Your Existing Email',
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
                  labelText: 'Enter Old Email Address',
                  hintText: 'Enter Old Email Address'),
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
                  labelText: 'Enter New Email Address',
                  hintText: 'Enter New Email Address'),
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
