import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/mainpage.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/set.dart';
import 'package:aisa/studentswork/bottomstudent/notific/socailnotification.dart';
import 'package:aisa/studentswork/bottomstudent/settings/editprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userprovider.userdata.profile == ""
                      ? CircleAvatar(
                          radius: 35,
                          child: Center(
                            child: Text(
                              userprovider.userdata.firstname[0],
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(userprovider.userdata.profile),
                          radius: 35,
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(
                            university: userprovider.userdata.university,
                            cityname: userprovider.userdata.cityname)));
              },
            ),
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SocialNotifications()),
                );
              },
            ),
          ),
          InkWell(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Se()),
                );
              },
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ),
          InkWell(
            child: ListTile(
              onTap: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();

                await FirebaseAuth.instance.signOut().then((value) {
                  sharedPreferences.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (Route<dynamic> route) => false,
                  );
                });
              },
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
