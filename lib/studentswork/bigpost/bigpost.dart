import 'package:aisa/models/postmodel.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comment.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comments2.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BigPost extends StatefulWidget {
  PostModel postModel;
  BigPost({required this.postModel});
  @override
  _BigPostState createState() => _BigPostState();
}

class _BigPostState extends State<BigPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          widget.postModel.type == "text"
              ? Text(widget.postModel.description)
              : Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Image.network(
                      widget.postModel.postimage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(widget.postModel.likes.toString()),
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ],
                ),
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      //Move To Comments Page
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) =>
                      //             Comments2(postid: widget.postModel.postid,commentModel: ,)));
                    },
                    child: Text('Comments'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
