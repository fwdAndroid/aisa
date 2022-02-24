import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/commentmodel.dart';
import 'package:aisa/studentswork/UserProfile/userprofile.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showuserdata/showuserprofile.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comment.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comments2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments3 extends StatefulWidget {
  String postid;
  String postby;

  Comments3({required this.postid, required this.postby});

  @override
  _Comments3State createState() => _Comments3State();
}

class _Comments3State extends State<Comments3> {
  TextEditingController comment = TextEditingController();
  File? selectedfile;
  final formkey = GlobalKey<FormState>();
  final filter = ProfanityFilter();

  // ignore: unused_element
  void handleGallery() async {
    await Permission.photos.request();

    var permission = await Permission.photos.status;
    if (permission.isGranted) {
      // final picker = ImagePicker();
      final pickedfile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      File file = File(pickedfile!.path);
      setState(() {
        Navigator.pop(context);
        this.selectedfile = file;
      });
    } else {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () => Navigator.pop(context),
      );
      return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              title: Text("Permissons"),
              content: Text("Please grant the access permission."),
              actions: [
                okButton,
              ],
            ),
          );
        },
      );
    }

    // final picker = ImagePicker();
    // PickedFile pickedfile = await picker.getImage(source: ImageSource.gallery);
    // file = File(pickedfile.path);
  }

  void handleCamera() async {
    Navigator.pop(context);
    await Permission.photos.request();

    var permission = await Permission.photos.status;
    if (permission.isGranted) {
      // final picker = ImagePicker();
      final pickedfile =
          await ImagePicker().getImage(source: ImageSource.camera);
      var file = File(pickedfile!.path);
      // File file = await ImagePicker.platform
      //     .pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 970)
      //     .then((value) => null);
      setState(() {
        Navigator.pop(context);
        this.selectedfile = file;
      });
    } else {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () => Navigator.pop(context),
      );
      return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              title: Text("Permissons"),
              content: Text("Please grant the access permission."),
              actions: [
                okButton,
              ],
            ),
          );
        },
      );
    }
  }

  selectImage(parentcontext) {
    return showDialog(
        context: parentcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text("create post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Select From Gallery"),
                onPressed: () => handleGallery(),
              ),
              SimpleDialogOption(
                child: Text("Select From Camera"),
                onPressed: () => handleCamera(),
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 23),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: comments
                          .where("postid", isEqualTo: widget.postid)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot? commentdata = snapshot.data;

                          return SizedBox(
                              height: commentdata!.size == 0
                                  ? MediaQuery.of(context).size.height * 0.9
                                  : MediaQuery.of(context).size.height * 0.9,
                              child: commentdata.size == 0
                                  ? Center(child: Text("No Comments"))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: commentdata.docs.length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic>? commentlikes =
                                            commentdata.docs[index].data()
                                                as Map<String, dynamic>?;

                                        CommentModel usercomment =
                                            CommentModel.fromquerysnapshot(
                                                commentdata, index);
                                        String commentid =
                                            commentdata.docs[index].id;
                                        return usercomment.type == "text"
                                            ? Column(
                                                children: [
                                                  ListTile(
                                                    leading:
                                                        usercomment.profile ==
                                                                ""
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  if (usercomment
                                                                          .userid ==
                                                                      userprovider
                                                                          .userdata
                                                                          .userid) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                UserProfile()));
                                                                  } else {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ShowUserProfile(userid: usercomment.userid)));
                                                                  }
                                                                },
                                                                child: Container(
                                                                    child: CircleAvatar(
                                                                        child: Text(
                                                                  usercomment
                                                                      .firstname[0],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ))),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  if (usercomment
                                                                          .userid ==
                                                                      userprovider
                                                                          .userdata
                                                                          .userid) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                UserProfile()));
                                                                  } else {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ShowUserProfile(userid: usercomment.userid)));
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              NetworkImage(usercomment.profile))),
                                                                ),
                                                              ),
                                                    title: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: Card(
                                                        color: Colors
                                                            .blueGrey[200],
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                        child: ListTile(
                                                          trailing: usercomment
                                                                      .userid ==
                                                                  userprovider
                                                                      .userdata
                                                                      .userid
                                                              ? IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    deletecomment1(
                                                                        context,
                                                                        commentid);
                                                                  },
                                                                )
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    reportcomment(
                                                                        context,
                                                                        usercomment);
                                                                  },
                                                                  child: Icon(Icons
                                                                      .more_vert)),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                  height: 2),
                                                              Text(
                                                                usercomment
                                                                    .comment,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "${timeago.format(usercomment.timestamp.toDate())}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          ),
                                                          title: Text(
                                                              usercomment
                                                                  .firstname),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 30),
                                                        child: Row(
                                                          children: [
                                                            Text(usercomment
                                                                .likes
                                                                .toString()),
                                                            TextButton(
                                                                onPressed: () {
                                                                  if (commentlikes![userprovider
                                                                              .userdata
                                                                              .userid] ==
                                                                          userprovider
                                                                              .userdata
                                                                              .userid &&
                                                                      usercomment
                                                                              .likes !=
                                                                          0) {
                                                                    comments
                                                                        .doc(
                                                                            commentid)
                                                                        .update({
                                                                      "likes":
                                                                          usercomment.likes -
                                                                              1,
                                                                      userprovider
                                                                          .userdata
                                                                          .userid: "null"
                                                                    });
                                                                  } else {
                                                                    comments
                                                                        .doc(
                                                                            commentid)
                                                                        .update({
                                                                      "likes":
                                                                          usercomment.likes +
                                                                              1,
                                                                      userprovider
                                                                              .userdata
                                                                              .userid:
                                                                          userprovider
                                                                              .userdata
                                                                              .userid
                                                                    });
                                                                  }
                                                                },
                                                                child: commentlikes![userprovider
                                                                            .userdata
                                                                            .userid] ==
                                                                        userprovider
                                                                            .userdata
                                                                            .userid
                                                                    ? Text(
                                                                        "Liked")
                                                                    : Text(
                                                                        "Like")),
                                                          ],
                                                        ),
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        Comments2(
                                                                          postid:
                                                                              commentid,
                                                                        )));
                                                          },
                                                          child: Text("Reply")),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20.0,
                                                      bottom: 20,
                                                    ),
                                                    child: StreamBuilder<
                                                            QuerySnapshot>(
                                                        stream: comments
                                                            .where("postid",
                                                                isEqualTo:
                                                                    commentid)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            QuerySnapshot?
                                                                querySnapshot =
                                                                snapshot.data;
                                                            return SizedBox(
                                                              height: querySnapshot!
                                                                          .size ==
                                                                      0
                                                                  ? 0
                                                                  : 100,
                                                              child: ListView
                                                                  .builder(
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      itemCount:
                                                                          querySnapshot.size == 1
                                                                              ? 1
                                                                              : 1,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        Map<String,
                                                                                dynamic>?
                                                                            commentlike =
                                                                            commentdata.docs[index].data()
                                                                                as Map<String, dynamic>?;
                                                                        CommentModel
                                                                            usercomments =
                                                                            CommentModel.fromquerysnapshot(querySnapshot,
                                                                                index);
                                                                        String id = querySnapshot
                                                                            .docs[index]
                                                                            .id;
                                                                        return usercomments.type ==
                                                                                "text"
                                                                            ? Column(
                                                                                children: [
                                                                                  ListTile(
                                                                                    leading: usercomments.profile == ""
                                                                                        ? Container(
                                                                                            child: CircleAvatar(
                                                                                                child: Text(
                                                                                            usercomments.firstname[0],
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          )))
                                                                                        : Container(
                                                                                            height: 30,
                                                                                            width: 30,
                                                                                            decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(usercomments.profile))),
                                                                                          ),
                                                                                    title: Card(
                                                                                      color: Colors.blueGrey[200],
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                                      child: SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.8,
                                                                                        child: ListTile(
                                                                                          trailing: usercomments.userid == userprovider.userdata.userid
                                                                                              ? IconButton(
                                                                                                  icon: Icon(
                                                                                                    Icons.delete,
                                                                                                    color: Colors.red,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    deletecomment1(context, id);
                                                                                                  },
                                                                                                )
                                                                                              : Text(""),
                                                                                          subtitle: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              SizedBox(height: 2),
                                                                                              Text(
                                                                                                usercomments.comment,
                                                                                                style: TextStyle(fontSize: 14),
                                                                                              ),
                                                                                              Text("${timeago.format(usercomments.timestamp.toDate())}", style: TextStyle(fontSize: 12)),
                                                                                            ],
                                                                                          ),
                                                                                          title: Text(usercomments.firstname),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.only(left: 30),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(usercomments.likes.toString()),
                                                                                            TextButton(
                                                                                                onPressed: () {
                                                                                                  if (commentlike![userprovider.userdata.userid] == userprovider.userdata.userid && usercomments.likes != 0) {
                                                                                                    comments.doc(commentid).update({
                                                                                                      "likes": usercomments.likes - 1,
                                                                                                      userprovider.userdata.userid: "null"
                                                                                                    });
                                                                                                  } else {
                                                                                                    comments.doc(commentid).update({
                                                                                                      "likes": usercomments.likes + 1,
                                                                                                      userprovider.userdata.userid: userprovider.userdata.userid
                                                                                                    });
                                                                                                  }
                                                                                                },
                                                                                                child: commentlike![userprovider.userdata.userid] == userprovider.userdata.userid ? Text("Liked") : Text("Like")),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                    builder: (_) => Comments2(
                                                                                                          postid: commentid,
                                                                                                        )));
                                                                                          },
                                                                                          child: Text("Reply"))
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              )
                                                                            : Column(
                                                                                children: [
                                                                                  ListTile(
                                                                                    leading: usercomments.profile == ""
                                                                                        ? Container(
                                                                                            child: CircleAvatar(
                                                                                                child: Text(
                                                                                            usercomments.firstname[0],
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          )))
                                                                                        : Container(
                                                                                            height: 30,
                                                                                            width: 30,
                                                                                            decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(usercomments.profile))),
                                                                                          ),
                                                                                    title: Card(
                                                                                      color: Colors.blueGrey[200],
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                                      child: SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.8,
                                                                                        child: ListTile(
                                                                                          trailing: usercomments.userid == userprovider.userdata.userid
                                                                                              ? IconButton(
                                                                                                  icon: Icon(
                                                                                                    Icons.delete,
                                                                                                    color: Colors.red,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    deletecomment1(context, commentid);
                                                                                                  },
                                                                                                )
                                                                                              : Text(""),
                                                                                          subtitle: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                "${timeago.format(usercomments.timestamp.toDate())}",
                                                                                                style: TextStyle(fontSize: 12),
                                                                                              ),
                                                                                              Text(
                                                                                                usercomments.comment,
                                                                                                style: TextStyle(fontSize: 18),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          title: Text(usercomments.firstname),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Center(
                                                                                    child: Container(
                                                                                      width: MediaQuery.of(context).size.width * 0.9,
                                                                                      height: 250,
                                                                                      child: Image.network(
                                                                                        usercomments.image,
                                                                                        fit: BoxFit.fill,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(usercomments.likes.toString()),
                                                                                          TextButton(
                                                                                              onPressed: () {
                                                                                                if (commentlike![userprovider.userdata.userid] == userprovider.userdata.userid && usercomments.likes != 0) {
                                                                                                  comments.doc(commentid).update({
                                                                                                    "likes": usercomments.likes - 1,
                                                                                                    userprovider.userdata.userid: "null"
                                                                                                  });
                                                                                                } else {
                                                                                                  comments.doc(commentid).update({
                                                                                                    "likes": usercomments.likes + 1,
                                                                                                    userprovider.userdata.userid: userprovider.userdata.userid
                                                                                                  });
                                                                                                }
                                                                                              },
                                                                                              child: commentlike![userprovider.userdata.userid] == userprovider.userdata.userid ? Text("Liked") : Text("Like")),
                                                                                        ],
                                                                                      ),
                                                                                      TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.push(context, MaterialPageRoute(builder: (_) => Comments2(postid: commentid)));
                                                                                          },
                                                                                          child: Text("Reply"))
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              );
                                                                      }),
                                                            );
                                                          } else {
                                                            return Text("0");
                                                          }
                                                        }),
                                                  )
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  ListTile(
                                                    leading:
                                                        usercomment.profile ==
                                                                ""
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  if (usercomment
                                                                          .userid ==
                                                                      userprovider
                                                                          .userdata
                                                                          .userid) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                UserProfile()));
                                                                  } else {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ShowUserProfile(userid: usercomment.userid)));
                                                                  }
                                                                },
                                                                child: Container(
                                                                    child: CircleAvatar(
                                                                        child: Text(
                                                                  usercomment
                                                                      .firstname[0],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ))),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  if (usercomment
                                                                          .userid ==
                                                                      userprovider
                                                                          .userdata
                                                                          .userid) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                UserProfile()));
                                                                  } else {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ShowUserProfile(userid: usercomment.userid)));
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              NetworkImage(usercomment.profile))),
                                                                ),
                                                              ),
                                                    title: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              trailing: usercomment
                                                                          .userid ==
                                                                      userprovider
                                                                          .userdata
                                                                          .userid
                                                                  ? IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        deletecomment1(
                                                                            context,
                                                                            commentid);
                                                                      },
                                                                    )
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        reportcomment(
                                                                            context,
                                                                            usercomment);
                                                                      },
                                                                      child: Icon(
                                                                          Icons
                                                                              .more_vert)),
                                                              subtitle: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${timeago.format(usercomment.timestamp.toDate())}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Text(
                                                                    usercomment
                                                                        .comment,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18),
                                                                  )
                                                                ],
                                                              ),
                                                              title: Text(
                                                                  usercomment
                                                                      .firstname),
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.9,
                                                                height: 250,
                                                                child: Image
                                                                    .network(
                                                                  usercomment
                                                                      .image,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(usercomment.likes
                                                              .toString()),
                                                          TextButton(
                                                              onPressed: () {
                                                                if (commentlikes![userprovider
                                                                            .userdata
                                                                            .userid] ==
                                                                        userprovider
                                                                            .userdata
                                                                            .userid &&
                                                                    usercomment
                                                                            .likes !=
                                                                        0) {
                                                                  comments
                                                                      .doc(
                                                                          commentid)
                                                                      .update({
                                                                    "likes":
                                                                        usercomment.likes -
                                                                            1,
                                                                    userprovider
                                                                        .userdata
                                                                        .userid: "null"
                                                                  });
                                                                } else {
                                                                  comments
                                                                      .doc(
                                                                          commentid)
                                                                      .update({
                                                                    "likes":
                                                                        usercomment.likes +
                                                                            1,
                                                                    userprovider
                                                                            .userdata
                                                                            .userid:
                                                                        userprovider
                                                                            .userdata
                                                                            .userid
                                                                  });
                                                                }
                                                              },
                                                              child: commentlikes![userprovider
                                                                          .userdata
                                                                          .userid] ==
                                                                      userprovider
                                                                          .userdata
                                                                          .userid
                                                                  ? Text(
                                                                      "Liked")
                                                                  : Text(
                                                                      "Like")),
                                                        ],
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) => Comments3(
                                                                        postby: widget
                                                                            .postby,
                                                                        postid:
                                                                            commentid)));
                                                          },
                                                          child: Text("Reply"))
                                                    ],
                                                  )
                                                ],
                                              );
                                      }));
                        } else {
                          return Center(child: Text("no data"));
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.photo),
                          iconSize: 25,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            selectImage(context);
                          },
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: comment,
                            validator: (value) {
                              if (value!.isNotEmpty &&
                                  filter.hasProfanity(value) == false) {
                                return null;
                              } else if (filter.hasProfanity(value) == true) {
                                return "Vulgar Words are not allowed";
                              } else {
                                return 'Please Comment on Post';
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: ' Comment',
                                hintText: 'Write Your  Comment About the post'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                if (userprovider.userdata.block == false) {
                                  if (selectedfile != null) {
                                    UploadTask uploadTask = storageRef
                                        .child("${selectedfile}")
                                        .putFile(selectedfile!);
                                    TaskSnapshot storageSnap = await uploadTask
                                        .whenComplete(() => null);
                                    String downloadUrl =
                                        await storageSnap.ref.getDownloadURL();
                                    if (downloadUrl != null) {
                                      comments.doc().set({
                                        "userid": userprovider.userdata.userid,
                                        "username":
                                            userprovider.userdata.firstname,
                                        "profile":
                                            userprovider.userdata.profile,
                                        "postid": widget.postid,
                                        "comment": comment.text.trim(),
                                        "type": "image",
                                        "image": downloadUrl,
                                        "likes": 0,
                                        "timestamp": DateTime.now()
                                      });
                                      notification.doc().set({
                                        "id": widget.postid,
                                        "username":
                                            userprovider.userdata.firstname,
                                        "profile":
                                            userprovider.userdata.profile,
                                        "userid": widget.postby,
                                        "message": "Commented On your post",
                                        "by": userprovider.userdata.userid,
                                        "timestamp": DateTime.now()
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (_) => LogoutOverlay(
                                              message: "Some Error Occur"));
                                    }
                                  } else {
                                    comments.doc().set({
                                      "userid": userprovider.userdata.userid,
                                      "username":
                                          userprovider.userdata.firstname,
                                      "profile": userprovider.userdata.profile,
                                      "postid": widget.postid,
                                      "comment": comment.text.trim(),
                                      "type": "text",
                                      "image": "null",
                                      "likes": 0,
                                      "timestamp": DateTime.now()
                                    }).then((value) {
                                      notification.doc().set({
                                        "id": widget.postid,
                                        "username":
                                            userprovider.userdata.firstname,
                                        "profile":
                                            userprovider.userdata.profile,
                                        "userid": widget.postby,
                                        "message": "Commented On your post",
                                        "by": userprovider.userdata.userid,
                                        "timestamp": DateTime.now()
                                      });
                                      comment.clear();
                                    }).onError((error, stackTrace) {
                                      showDialog(
                                          context: context,
                                          // ignore: unnecessary_brace_in_string_interps
                                          builder: (_) =>
                                              // ignore: unnecessary_brace_in_string_interps
                                              LogoutOverlay(
                                                  message: "${error}"));
                                    });
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      // ignore: unnecessary_brace_in_string_interps
                                      builder: (_) =>
                                          // ignore: unnecessary_brace_in_string_interps
                                          LogoutOverlay(
                                              message:
                                                  "Your are blocked by admin to comment on any post"));
                                }
                              }
                              //  else {
                              //   showDialog(
                              //       context: context,
                              //       // ignore: unnecessary_brace_in_string_interps
                              //       builder: (_) =>
                              //           // ignore: unnecessary_brace_in_string_interps
                              //           LogoutOverlay(
                              //               message:
                              //                   "Your are blocked by admin to comment on any post"));
                              // }
                            },
                            child: Text(
                              'Send',
                              style: TextStyle(color: Colors.indigo),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void deletecomment1(BuildContext context, String commentid) {
    comments.doc(commentid).delete().onError((error, stackTrace) {
      showDialog(
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(message: "${error}"));
    });
  }
}
