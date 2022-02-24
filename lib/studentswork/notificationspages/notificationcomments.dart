import 'package:aisa/models/commentmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationComments extends StatefulWidget {
  String id;
  NotificationComments({required this.id});

  @override
  _NotificationCommentsState createState() => _NotificationCommentsState();
}

class _NotificationCommentsState extends State<NotificationComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;
            return data!.size == 0
                ? Center(child: Text("No Data"))
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      CommentModel commentModel =
                          CommentModel.fromquerysnapshot(data, index);
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: commentModel.profile == ""
                                    ? Text(
                                        commentModel.firstname[0],
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Image.network(
                                        commentModel.profile,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              title: Text(commentModel.firstname),
                              subtitle: Text(commentModel.comment),
                              trailing: Text(
                                timeago.format(commentModel.timestamp.toDate()),
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                        ],
                      );
                    },
                    itemCount: data.docs.length,
                  );
          } else {
            return Text("Erros");
          }
        },
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('postid', isEqualTo: widget.id)
            .snapshots(),
      ),
    );
  }
}
