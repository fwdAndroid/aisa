import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileBu extends StatefulWidget {
  const UserProfileBu({Key? key}) : super(key: key);

  @override
  _UserProfileBuState createState() => _UserProfileBuState();
}

class _UserProfileBuState extends State<UserProfileBu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bussiness Profile'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                        //Background Image Course
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Profile Name
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Profile Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Fawad Kaleem ",
                          style: TextStyle(color: Colors.indigo, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  //Bussiness Named
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bussiness Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Amentiy Sols',
                          style: TextStyle(color: Colors.indigo, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'City Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Sydney',
                          style: TextStyle(color: Colors.indigo, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<QuerySnapshot>(
              // stream: userpost
              //     .where("userid", isEqualTo: userprovider.userdata.userid)
              //     .snapshots(),
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
                        // PostModel posts =
                        //     PostModel.fromquerysnapshot(data, index);
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              // image: DecorationImage(
                              //   image: NetworkImage(posts.postimage),
                              //   fit: BoxFit.cover,
                              // ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
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
          )
        ],
      ),
    );
  }
}
