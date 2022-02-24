import 'package:aisa/models/postmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyPostBu extends StatefulWidget {
  const MyPostBu({Key? key}) : super(key: key);

  @override
  _MyPostBuState createState() => _MyPostBuState();
}

class _MyPostBuState extends State<MyPostBu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Bussiness Post'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // stream: userpost.where("userid", isEqualTo: userid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;
            return GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: data!.docs.length,
              itemBuilder: (context, index) {
                PostModel posts = PostModel.fromquerysnapshot(data, index);
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => BigPost(postModel: posts,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.network(posts.postimage),
                  ),
                );
              },
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
