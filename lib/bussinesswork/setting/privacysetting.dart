import 'package:flutter/material.dart';

class PrivacySetting extends StatefulWidget {
  const PrivacySetting({Key? key}) : super(key: key);

  @override
  _PrivacySettingState createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> {
  // ignore: unused_field
  bool _value = false;
  bool profile = false;
  bool name = false;
  bool universityname = false;
  bool photo = false;
  bool cityname = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Privacy Setting'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: ListTile(
                  trailing: Icon(Icons.arrow_forward),
                  title: Text(
                    'Missing Notification',
                    style: TextStyle(color: Colors.indigo),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Privacy Setting',
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              SizedBox(height: 10),
              SwitchListTile(
                  value: profile,
                  onChanged: (val) {
                    setState(() {
                      profile = val;
                    });
                  },
                  title: Text(
                    'Profile is Visible for Everyone',
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(height: 10),
              SwitchListTile(
                  value: name,
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                  title: Text(
                    'Name',
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(height: 10),
              SwitchListTile(
                  value: photo,
                  onChanged: (val) {
                    setState(() {
                      photo = val;
                    });
                  },
                  title: Text(
                    'Photo',
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(height: 10),
              SwitchListTile(
                  value: universityname,
                  onChanged: (val) {
                    setState(() {
                      universityname = val;
                    });
                  },
                  title: Text(
                    'Bussiness Name',
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(height: 10),
              SwitchListTile(
                  value: cityname,
                  onChanged: (val) {
                    setState(() {
                      cityname = val;
                    });
                  },
                  title: Text(
                    'City Name',
                    style: TextStyle(color: Colors.black),
                  )),
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                height: 50,
                width: 200,
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () => {},
                  child: Text(
                    'Saved',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
