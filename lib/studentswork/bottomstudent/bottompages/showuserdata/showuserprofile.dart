import 'dart:math';

import 'package:aisa/Functions/chatfunctions.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/getusermodel.dart';
import 'package:aisa/models/groupsmodel.dart';
import 'package:aisa/models/postmodel.dart';
import 'package:aisa/studentswork/bottomstudent/chats/chatscreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ShowUserProfile extends StatefulWidget {
  String userid;
  ShowUserProfile({required this.userid});

  @override
  _ShowUserProfileState createState() => _ShowUserProfileState();
}

class _ShowUserProfileState extends State<ShowUserProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String randomid;
  bool state = false;
  bool click = false;
  @override
  void initState() {
    super.initState();
    generateRandomString();
  }

  void generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    setState(() {
      randomid =
          List.generate(70, (index) => _chars[r.nextInt(_chars.length)]).join();
      print(randomid);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .where("userid", isEqualTo: widget.userid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;
            GetUserModel userdata = GetUserModel.fromquersnapshot(data!, 0);
            return userdata.profilevis == true
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: userdata.profile == ""
                                      ? CircleAvatar(
                                          // child: Image.asset(
                                          //   ('assets/images/aisa.png'),
                                          // ),
                                          child: Center(
                                            child: Text(
                                              userdata.firstname[0],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          // child: Image.asset(
                                          //   ('assets/images/aisa.png'),
                                          // ),
                                          backgroundImage:
                                              NetworkImage(userdata.profile),
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //Profile Name
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //   'Name',
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    userdata.namevis == false
                                        ? Center(
                                            child: Text(
                                              "Private",
                                              style: TextStyle(
                                                  color: Colors.indigo,
                                                  fontSize: 15),
                                            ),
                                          )
                                        : Expanded(
                                            child: Center(
                                              child: Text(
                                                "${userdata.firstname} ${userdata.lastname} ",
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),

                              //University Named
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Text(
                                      //   'University',
                                      //   style: TextStyle(
                                      //       color: Colors.black,
                                      //       fontSize: 15,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      // SizedBox(
                                      //   width: 10,
                                      // ),
                                      userdata.universityvis == false
                                          ? Center(
                                              child: Text(
                                                "Private",
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 15),
                                              ),
                                            )
                                          : Expanded(
                                              child: Center(
                                                child: Text(
                                                  userdata.university,
                                                  style: TextStyle(
                                                      color: Colors.indigo,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // // Text(
                                      // //   'City',
                                      // //   style: TextStyle(
                                      // //       color: Colors.black,
                                      // //       fontSize: 15,
                                      // //       fontWeight: FontWeight.bold),
                                      // // ),
                                      // SizedBox(
                                      //   width: 10,
                                      // ),
                                      userdata.citynamevis == false
                                          ? Center(
                                              child: Text(
                                                "Private",
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 15),
                                              ),
                                            )
                                          : Expanded(
                                              child: Center(
                                                child: Text(
                                                  userdata.cityname,
                                                  style: TextStyle(
                                                      color: Colors.indigo,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              // ignore: deprecated_member_use
                              InkWell(
                                child: RaisedButton(
                                  color: Colors.pink,
                                  onPressed: () async {
                                    if (click == false) {
                                      setState(() {
                                        click = true;
                                      });

                                      QuerySnapshot snapshot = await groups
                                          .where("groupname",
                                              isEqualTo:
                                                  "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}_${userdata.firstname} ${userdata.lastname}")
                                          .get();
                                      print(snapshot.size);
                                      QuerySnapshot snapshot2 = await groups
                                          .where("groupname",
                                              isEqualTo:
                                                  "${userdata.firstname} ${userdata.lastname}_${userprovider.userdata.firstname} ${userprovider.userdata.lastname}")
                                          .get();
                                      print(snapshot.size);

                                      // ignore: unnecessary_null_comparison
                                      if (snapshot.size == 0 &&
                                          snapshot2.size == 0) {
                                        ChatFunction()
                                            .createsinglechat(
                                                context,
                                                userprovider.userdata.userid,
                                                randomid,
                                                "${userprovider.userdata.profile}_${userdata.profile}",
                                                "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}_${userdata.firstname} ${userdata.lastname}",
                                                "",
                                                randomid,
                                                "user",
                                                userdata.userid,
                                                userdata.university,
                                                userdata.cityname)
                                            .then((value) {
                                          setState(() {
                                            state = false;
                                          });
                                        });
                                      } else if (snapshot.size == 0 &&
                                          snapshot2.size == 1) {
                                        GroupsModel model1 =
                                            GroupsModel.fromquersnapshot(
                                                snapshot2, 0);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                        groupid: model1.groupid,
                                                        groupname:
                                                            model1.groupname,
                                                        type: model1.type,
                                                        members: model1.userids,
                                                        myid: userprovider
                                                            .userdata.userid)));
                                      } else if (snapshot.size == 1 &&
                                          snapshot2.size == 0) {
                                        GroupsModel model =
                                            GroupsModel.fromquersnapshot(
                                                snapshot, 0);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                        groupid: model.groupid,
                                                        groupname:
                                                            model.groupname,
                                                        type: model.type,
                                                        members: model.userids,
                                                        myid: userprovider
                                                            .userdata.userid)));
                                      } else {
                                        setState(() {
                                          state = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Private Message',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      userdata.photovis == false
                          ? Center(
                              child: Text("private"),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: userpost
                                    .where("userid", isEqualTo: userdata.userid)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    QuerySnapshot? data = snapshot.data;
                                    return Container(
                                      child: GridView.builder(
                                        gridDelegate:
                                            new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        shrinkWrap: true,
                                        itemCount: data!.docs.length,
                                        itemBuilder: (context, index) {
                                          PostModel posts =
                                              PostModel.fromquerysnapshot(
                                                  data, index);
                                          return posts.type == "image"
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            posts.postimage),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Text("");
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                    ],
                  )
                : Center(
                    child: Text("Private"),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
