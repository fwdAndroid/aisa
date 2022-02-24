import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 160,
              width: 160,
              decoration: new BoxDecoration(
                border: Border.all(),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircleAvatar(
                  child: Image.asset('assets/images/aisa.png'),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Chose Profile Image',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15,
                  ),
                ),
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
                    labelText: 'Enter First Name',
                    hintText: 'Please Write Your First Name'),
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
                    labelText: 'Enter Last Name',
                    hintText: 'Please Write Your Last Name'),
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
                    labelText: 'Enter City Name',
                    hintText: 'Please Write Your City Name'),
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
                    labelText: 'Your Bussiness Name',
                    hintText: 'Enter Your Bussiness Name'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              height: 50,
              width: 20,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
      ),
    );
  }
}
