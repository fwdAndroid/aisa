import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/mainpage.dart';
import 'package:aisa/studentswork/aboutus/about.dart';
import 'package:aisa/studentswork/bottomstudent/settings/changemobile.dart';
import 'package:aisa/studentswork/bottomstudent/settings/changepassword.dart';
import 'package:aisa/studentswork/bottomstudent/settings/editprofile.dart';
import 'package:aisa/studentswork/bottomstudent/settings/myposts.dart';
import 'package:aisa/studentswork/bottomstudent/settings/privacysetting.dart';
import 'package:aisa/studentswork/bottomstudent/settings/savedpost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Se extends StatefulWidget {
  const Se({Key? key}) : super(key: key);

  @override
  _SeState createState() => _SeState();
}

class _SeState extends State<Se> {
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Profile Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: userprovider.userdata.profile == ""
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
              // : Container(
              //     decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         image: DecorationImage(
              //             fit: BoxFit.cover,
              //             image:
              //                 NetworkImage(userprovider.userdata.profile))),
              //   ),
              title: Text(
                  "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}"),
              subtitle: Text(userprovider.userdata.university),
              trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfile(
                                university: userprovider.userdata.university,
                                cityname: userprovider.userdata.cityname)));
                  },
                  child: Icon(Icons.edit, color: Colors.indigo)),
            ),
            //Edit Mobile Number
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.mobile_friendly),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      TextButton(
                        child: Text(
                          "Mobile Number",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeMobile()));
                        },
                      ),
                      Text(userprovider.userdata.phonenumber)
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Divider(
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacySetting(
                      photovis: userprovider.userdata.photovis,
                      profilevis: userprovider.userdata.profilevis,
                      citynamevis: userprovider.userdata.citynamevis,
                      namevis: userprovider.userdata.namevis,
                      universityvis: userprovider.userdata.universityvis,
                    ),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Privacy Setting",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, right: 20),
            //   child: Divider(
            //     color: Colors.black,
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangedPassword()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                child: Row(
                  children: [
                    Icon(Icons.password),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Change Password",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, right: 20),
            //   child: Divider(
            //     color: Colors.black,
            //   ),
            // ),
            //My Posts
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyPost()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                child: Row(
                  children: [
                    Icon(Icons.post_add),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "My Posts",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, right: 20),
            //   child: Divider(
            //     color: Colors.black,
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SavedPost()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                child: Row(
                  children: [
                    Icon(Icons.save),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Saved Posts",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, right: 20),
            //   child: Divider(
            //     color: Colors.black,
            //   ),
            // ),
            InkWell(
              onTap: () async {
                final url = "mailto:${"help@aisa.education"}?subject="
                    "&body="
                    "";

                await launch(url);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                child: Row(
                  children: [
                    Icon(Icons.help),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Help",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, right: 20),
            //   child: Divider(
            //     color: Colors.black,
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutWebView()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                child: Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Contact Us",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
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
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, right: 20),
            //   child: Divider(
            //     color: Colors.black,
            //   ),
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     Container(
            //       height: 50,
            //       margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            //       child: MaterialButton(
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10.0)),
            //         color: Colors.pink,
            //         onPressed: () async {
            // SharedPreferences sharedPreferences =
            //     await SharedPreferences.getInstance();

            // await FirebaseAuth.instance.signOut().then((value) {
            //   sharedPreferences.clear();
            //   Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => MainPage()),
            //     (Route<dynamic> route) => false,
            //   );
            // });
            //         },
            //         child: Text(
            //           "Logout",
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
