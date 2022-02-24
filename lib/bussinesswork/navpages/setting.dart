import 'package:aisa/bussinesswork/BusinessProvider/businessprovider.dart';

import 'package:aisa/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<BusinessProvider>(context, listen: false);
    FirebaseAuth auth;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Business Profile Setting'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
                  height: 150,
                  child: Card(
                    color: Colors.indigo,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 33,
                          child: Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Image.asset('assets/images/aisa.png')),
                        ),
                        Expanded(
                          flex: 66,
                          child: Container(
                            margin: EdgeInsets.only(top: 40, bottom: 10),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 25,
                                  child: Text(
                                  userprovider.userdata.businessname,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                             
                                // ignore: deprecated_member_use
                                // Expanded(
                                //     flex: 25,
                                //     // ignore: deprecated_member_use
                                //     child: RaisedButton(
                                //       color: Colors.indigo,
                                //       onPressed: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (_) => UserProfileBu(),
                                //           ),
                                //         );
                                //       },
                                //       child: Text(
                                //         'User Profile',
                                //         style: TextStyle(color: Colors.white),
                                //       ),
                                //     )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                //   child: Row(
                //     children: [
                //       Icon(Icons.edit),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       // TextButton(
                //       //     onPressed: () {
                //       //       Navigator.push(
                //       //         context,
                //       //         MaterialPageRoute(
                //       //             builder: (context) => EditProfile()),
                //       //       );
                //       //     },
                //       //     child: Text(
                //       //       'Edit Profile',
                //       //       style:
                //       //           TextStyle(color: Colors.black54, fontSize: 18),
                //       //     ))
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                //   child: Divider(
                //     color: Colors.black,
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                //   child: Row(
                //     children: [
                //       Icon(Icons.mobile_friendly),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       TextButton(
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => MobileNumber()),
                //             );
                //           },
                //           child: Text(
                //             'Mobile Number',
                //             style:
                //                 TextStyle(color: Colors.black54, fontSize: 18),
                //           ))
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                //   child: Divider(
                //     color: Colors.black,
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                //   child: Row(
                //     children: [
                //       Icon(Icons.email),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       TextButton(
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(builder: (context) => Email()),
                //             );
                //           },
                //           child: Text(
                //             'Email',
                //             style:
                //                 TextStyle(color: Colors.black54, fontSize: 18),
                //           ))
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 20,
                //     right: 20,
                //   ),
                //   child: Divider(
                //     color: Colors.black,
                //   ),
                // ),
                // Padding(
                //     padding: EdgeInsets.only(left: 20, top: 10),
                //     child: TextButton(
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => PrivacySetting()),
                //           );
                //         },
                //         child: Text(
                //           ' Privicy Setting',
                //           style: TextStyle(color: Colors.black54, fontSize: 18),
                //         ))),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 20,
                //     right: 20,
                //   ),
                //   child: Divider(
                //     color: Colors.black,
                //   ),
                // ),
                // Padding(
                //     padding: EdgeInsets.only(left: 20, top: 10),
                //     child: TextButton(
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => ChangePassword()),
                //           );
                //         },
                //         child: Text(
                //           ' Change Password',
                //           style: TextStyle(color: Colors.black54, fontSize: 18),
                //         ))),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 20,
                //     right: 20,
                //   ),
                //   child: Divider(
                //     color: Colors.black,
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 20, top: 10),
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (_) => MyPostBu()));
                //     },
                //     child: Text(
                //       ' My Post',
                //       style: TextStyle(color: Colors.black54, fontSize: 18),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 20,
                //     right: 20,
                //   ),
                //   child: Divider(
                //     color: Colors.black,
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 100, right: 20),
                  height: 50,
                  width: 200,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.pink,
                    onPressed: ()  {
                      FirebaseAuth auth=FirebaseAuth.instance;
                      auth.signOut();
                       Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                            (Route<dynamic> route) => false,
                          );

                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
