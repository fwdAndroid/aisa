import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/notificationmodel.dart';
import 'package:aisa/models/postmodel.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/post.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showbigpost.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comments2.dart';
import 'package:aisa/studentswork/notificationspages/notificationcomments.dart';
import 'package:aisa/studentswork/notificationspages/notificationspost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class SocialNotifications extends StatefulWidget {
  const SocialNotifications({Key? key}) : super(key: key);

  @override
  _SocialNotificationsState createState() => _SocialNotificationsState();
}

class _SocialNotificationsState extends State<SocialNotifications> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body:  StreamBuilder<QuerySnapshot>(
                stream: notification
                    .where("userid", isEqualTo: userprovider.userdata.userid).where("by",isNotEqualTo: userprovider.userdata.userid )
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot? data = snapshot.data;
                    return data!.size == 0
                        ? Center(
                            child: Text("No Notifications"),
                          )
                        : ListView.builder(
                          padding: EdgeInsets.zero,
                            itemCount: data.docs.length,
                            itemBuilder: (context, index) {
                              NotificationModel notificationModel =
                                  NotificationModel.fromquerysnapshot(
                                      data, index);
                              return Dismissible(
                                key: Key(data.docs[index].id),
                                onDismissed: (direction) {
                                  notification
                                      .doc(data.docs[index].id)
                                      .delete();
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    // ignore: unrelated_type_equality_checks
                                    if (notificationModel.message ==
                                        'likes Your Post') {
                                      if (clicked == false) {
                                        setState(() {
                                          clicked = true;
                                        });
                                        await userpost
                                            .doc(notificationModel.id)
                                            .get()
                                            .then((value) {
                                          PostModel postmodel =
                                              PostModel.fromdoc(value);
                                          Map<String, dynamic>? likesdata =
                                              value.data();
                                          DateTime date =
                                              postmodel.timestamp.toDate();
                                          setState(() {
                                            clicked = false;
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowBigPost(
                                                          posts: postmodel,
                                                          likesdata: likesdata,
                                                          date: date)));
                                        }).onError((error, stackTrace) {
                                          print(error);
                                        });
                                      } // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           PostNotification()),
                                      // );
                                    } else if (notificationModel.message ==
                                        'dislikes Your Post') {
                                      if (clicked == false) {
                                        setState(() {
                                          clicked = true;
                                        });
                                        await userpost
                                            .doc(notificationModel.id)
                                            .get()
                                            .then((value) {
                                          PostModel postmodel =
                                              PostModel.fromdoc(value);
                                          Map<String, dynamic>? likesdata =
                                              value.data();
                                          DateTime date =
                                              postmodel.timestamp.toDate();
                                          setState(() {
                                            clicked = false;
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowBigPost(
                                                          posts: postmodel,
                                                          likesdata: likesdata,
                                                          date: date)));
                                        }).onError((error, stackTrace) {
                                          print(error);
                                        });
                                      }
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           PostNotification()),
                                      // );
                                    } else if (notificationModel.message ==
                                        'Commented On your post') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Comments2(
                                                postid: notificationModel.id)),
                                      );
                                    }
                                  },
                                  child: notificationModel.by ==
                                          userprovider.userdata.userid
                                      ? Text("")
                                      : Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: ListTile(
                                                leading: notificationModel
                                                            .profile ==
                                                        ""
                                                    ? CircleAvatar(
                                                        child: Text(
                                                        notificationModel
                                                            .name[0],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                    : CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          notificationModel
                                                              .profile,
                                                        ),
                                                      ),
                                                title: Text(
                                                    notificationModel.name),
                                                subtitle: Text(
                                                    notificationModel.message),
                                                trailing: Text(timeago.format(
                                                    notificationModel.timestamp
                                                        .toDate())),
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                ),
                              );
                            });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
       
    );
  }
}
