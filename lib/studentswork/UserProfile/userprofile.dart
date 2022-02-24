import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/postmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    print(userprovider.userdata.firstname);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: ListView(
        children: [
          Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 4),
                  height: 100,
                  width: 100,
                  child: userprovider.userdata.profile.isNotEmpty
                      ? CircleAvatar(
                          // child: Image.asset(
                          //   ('assets/images/aisa.png'),
                          // ),
                          backgroundImage:
                              NetworkImage(userprovider.userdata.profile),
                          backgroundColor: Colors.indigo,
                        )
                      : CircleAvatar(
                          // child: Image.asset(
                          //   ('assets/images/aisa.png'),
                          // ),
                          child: Center(
                              child: Text(
                            userprovider.userdata.firstname[0],
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "${userprovider.userdata.firstname} ${userprovider.userdata.lastname} ",
                        style: TextStyle(color: Colors.indigo, fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        userprovider.userdata.university,
                        style: TextStyle(color: Colors.indigo, fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        userprovider.userdata.cityname,
                        style: TextStyle(color: Colors.indigo, fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: .5,
            color: Colors.black,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<QuerySnapshot>(
              stream: userpost
                  .where("userid", isEqualTo: userprovider.userdata.userid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            PostModel.fromquerysnapshot(data, index);
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(posts.postimage),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        );
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
      ),
    );
  }
}
