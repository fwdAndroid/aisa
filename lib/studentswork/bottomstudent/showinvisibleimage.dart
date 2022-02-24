import 'dart:async';
import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/models/commentmodel.dart';
import 'package:aisa/models/postmodel.dart';
import 'package:aisa/studentswork/UserProfile/userprofile.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showbigpost.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showuserdata/showuserprofile.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comments2.dart';
import 'package:aisa/studentswork/bottomstudent/posts/sharepost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../main.dart';

class BigPostInvisible extends StatefulWidget {
  late PostModel postModel;
  Map<String, dynamic>? likesdata;
  BigPostInvisible({required this.postModel, required this.likesdata});

  @override
  _BigPostInvisibleState createState() => _BigPostInvisibleState();
}

class _BigPostInvisibleState extends State<BigPostInvisible> {
   bool visible = true;
  // late Timer timer;
  // @override
  // void initState() {
  //   timer = Timer.periodic(Duration(seconds: 2), (t) {
  //     setState(() {
  //       visible = false;
  //     });
  //   });
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    String userid = userprovider.userdata.userid;
    DateTime date = widget.postModel.timestamp.toDate();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: visible == true ? 1 : 0,
            curve: Curves.linearToEaseOut,
            duration: Duration(milliseconds: 500),
            child: Visibility(
           //   visible: visible,
              child: ListTile(
                trailing: myPopMenu(context, widget.postModel, userid),

                //Profile Image
                leading: GestureDetector(
                  onTap: () {
                    if (widget.postModel.userid == userid) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowUserProfile(
                                  userid: widget.postModel.userid)));
                    }
                  },
                  child: widget.postModel.profile == ""
                      ? Container(
                          child: CircleAvatar(
                              child: Text(
                          widget.postModel.firstname[0],
                          style: TextStyle(color: Colors.white),
                        )))
                      : Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(widget.postModel.profile))),
                        ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(widget.postModel.firstname,
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(timeago.format(date),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),

                subtitle: Row(
                  children: [
                    Expanded(
                        child: Text(
                      widget.postModel.useruni,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.white),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.postModel.location,
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: visible == true ? 1 : 0,
            curve: Curves.linearToEaseOut,
            duration: Duration(milliseconds: 500),
            child: Visibility(
              visible: visible,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 15),
                child: Text(
                  widget.postModel.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: visible == true ? 1 : 0,
            curve: Curves.linearToEaseOut,
            duration: Duration(milliseconds: 500),
            child: Visibility(
              visible: visible,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ReadMoreText(
                  widget.postModel.description,
                  trimLines: 2,
                  style: TextStyle(color: Colors.white),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: ' show less',
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  visible = !visible;
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.postModel.postimage,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: visible == true ? 1 : 0,
            curve: Curves.linearToEaseOut,
            duration: Duration(milliseconds: 500),
            child: Visibility(
              visible: visible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ignore: deprecated_member_use
                  FlatButton.icon(
                      onPressed: () {
                        if (widget.likesdata![userid] == userid &&
                            widget.likesdata!["likes"] != 0) {
                          userpost.doc(widget.postModel.postid).update({
                            "postimage": widget.postModel.postimage,
                            "title": widget.postModel.title,
                            "description": widget.postModel.description,
                            "category": widget.postModel.category,
                            "location": widget.postModel.location,
                            "userid": widget.postModel.userid,
                            "userimage": widget.postModel.profile,
                            "postid": widget.postModel.postid,
                            "timestamp": widget.postModel.timestamp,
                            "username": widget.postModel.firstname,
                            "likes": widget.postModel.likes - 1,
                            userid: "null"
                          });
                          notification.doc(widget.postModel.postid).set({
                            "id": widget.postModel.postid,
                            "username": userprovider.userdata.firstname,
                            "profile": userprovider.userdata.profile,
                            "userid": widget.postModel.userid,
                            "message": "likes Your Post",
                            "by": userid
                          });
                        } else {
                          userpost.doc(widget.postModel.postid).update({
                            "postimage": widget.postModel.postimage,
                            "title": widget.postModel.title,
                            "description": widget.postModel.description,
                            "category": widget.postModel.category,
                            "location": widget.postModel.location,
                            "userid": widget.postModel.userid,
                            "userimage": widget.postModel.profile,
                            "postid": widget.postModel.postid,
                            "timestamp": widget.postModel.timestamp,
                            "username": widget.postModel.firstname,
                            "likes": widget.postModel.likes + 1,
                            userid: userid
                          });
                          notification.doc(widget.postModel.postid).set({
                            "id": widget.postModel.postid,
                            "username": userprovider.userdata.firstname,
                            "profile": userprovider.userdata.profile,
                            "userid": widget.postModel.userid,
                            "message": "dislikes Your Post",
                            "by": userid
                          });
                        }
                      },
                      icon: widget.likesdata![userid] == userid
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                      label: Text(
                        widget.likesdata!["likes"].toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                  // ignore: deprecated_member_use
                  Row(
                    children: [
                      FlatButton.icon(
                        onPressed: () {
                          _settingModalBottomSheet(context,
                              widget.postModel.postid, widget.postModel.userid);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) =>  ShowBigPost (
                          //            posts: widget.postModel,
                          //            date: date,
                          //            likesdata:widget.likesdata,)));
                        },
                        icon: Icon(
                          Icons.message,
                          color: Colors.indigo,
                        ),
                        label: Text(
                          'Comments',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: comments
                              .where("postid",
                                  isEqualTo: widget.postModel.postid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              QuerySnapshot? commentdata = snapshot.data;
                              return Text(
                                commentdata!.docs.length.toString(),
                                style: TextStyle(color: Colors.white),
                              );
                            } else {
                              return Text(
                                "0",
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          })
                    ],
                  ),
                  // ignore: deprecated_member_use
                  FlatButton.icon(
                    onPressed: () {
                      // saveMyposts.doc(posts.postid).set({
                      //   "postimage": posts.postimage,
                      //   "title": posts.title,
                      //   "description": posts.description,
                      //   "category": posts.category,
                      //   "location": posts.location,
                      //   "userid": posts.userid,
                      //   "userimage": posts.profile,
                      //   "postid": posts.postid,
                      //   "timestamp": posts.timestamp,
                      //   "username": posts.firstname,
                      //   "likes": posts.likes,
                      //   "savedby": userid
                      // }).then((value) {
                      //   showDialog(
                      //       context: context,
                      //       builder: (_) => LogoutOverlay(
                      //           message: "Post Saved"));
                      // }).onError((error, stackTrace) {
                      //   showDialog(
                      //       context: context,
                      //       builder: (_) => LogoutOverlay(
                      //           // ignore: unnecessary_brace_in_string_interps
                      //           message: "${error}"));
                      // });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShareInChat(posts: widget.postModel)));
                    },
                    icon: Icon(
                      Icons.save,
                      color: Colors.indigo,
                    ),
                    label: Text(
                      'Share',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                  // ignore: deprecated_member_use
                  // FlatButton.icon(
                  //   onPressed: () {
                  //     //Navigate to chat screen to chat the users chat will initialize when other user responsed to the message
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (_) => Chat()));
                  //   },
                  //   icon: Icon(
                  //     Icons.chat,
                  //     color: Colors.indigo,
                  //   ),
                  //   label: Text('Chat'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget myPopMenu(BuildContext context, PostModel posts, String userid) {
  return PopupMenuButton(
      onSelected: (value) {},
      itemBuilder: (context) => [
            PopupMenuItem(
                value: 3,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          saveMyposts.doc(posts.postid).set({
                            "postimage": posts.postimage,
                            "title": posts.title,
                            "description": posts.description,
                            "category": posts.category,
                            "location": posts.location,
                            "userid": posts.userid,
                            "userimage": posts.profile,
                            "postid": posts.postid,
                            "timestamp": posts.timestamp,
                            "username": posts.firstname,
                            "likes": posts.likes,
                            "type": posts.type,
                            "university": posts.useruni,
                            "savedby": userid
                          }).then((value) {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    LogoutOverlay(message: "Post Saved"));
                          }).onError((error, stackTrace) {
                            showDialog(
                                context: context,
                                builder: (_) => LogoutOverlay(
                                    // ignore: unnecessary_brace_in_string_interps
                                    message: "${error}"));
                          });

                          Navigator.pop(context);
                        },
                        child: Text('Save'))
                  ],
                )),
          ]);
}

void _settingModalBottomSheet(context, postid, postby) {
  TextEditingController comment = TextEditingController();
  File? selectedfile;
  final formkey = GlobalKey<FormState>();
  final filter = ProfanityFilter();
  void handleGallery() async {
    await Permission.photos.request();

    var permission = await Permission.photos.status;
    if (permission.isGranted) {
      // final picker = ImagePicker();
      final pickedfile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      File file = File(pickedfile!.path);

      selectedfile = file;
      Navigator.pop(context);
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

      selectedfile = file;
      Navigator.pop(context);
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

  showModalBottomSheet(
      enableDrag: true,
      elevation: 10,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        var userprovider = Provider.of<UserProvider>(context, listen: false);
        return Scaffold(
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
                          .where("postid", isEqualTo: postid)
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
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 28.0),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: commentdata.docs.length,
                                          itemBuilder: (context, index) {
                                            Map<String, dynamic>? commentlike =
                                                commentdata.docs[index].data()
                                                    as Map<String, dynamic>?;

                                            CommentModel usercomments =
                                                CommentModel.fromquerysnapshot(
                                                    commentdata, index);
                                            String commentid =
                                                commentdata.docs[index].id;
                                            return usercomments.type == "text"
                                                ? Column(
                                                    children: [
                                                      ListTile(
                                                        leading: usercomments
                                                                    .profile ==
                                                                ""
                                                            ? Container(
                                                                child:
                                                                    CircleAvatar(
                                                                        child:
                                                                            Text(
                                                                usercomments
                                                                    .firstname[0],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )))
                                                            : Container(
                                                                height: 30,
                                                                width: 30,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: NetworkImage(
                                                                            usercomments.profile))),
                                                              ),
                                                        trailing: usercomments
                                                                    .userid ==
                                                                userprovider
                                                                    .userdata
                                                                    .userid
                                                            ? IconButton(
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                onPressed: () {
                                                                  deletecomment(
                                                                      context,
                                                                      commentid);
                                                                },
                                                              )
                                                            : Text(""),
                                                        subtitle: Text(
                                                            "${timeago.format(usercomments.timestamp.toDate())}"),
                                                        title: Text(
                                                            "${usercomments.firstname} :   ${usercomments.comment}"),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(usercomments
                                                                  .likes
                                                                  .toString()),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (commentlike![userprovider.userdata.userid] ==
                                                                            userprovider
                                                                                .userdata.userid &&
                                                                        usercomments.likes !=
                                                                            0) {
                                                                      comments
                                                                          .doc(
                                                                              commentid)
                                                                          .update({
                                                                        "likes":
                                                                            usercomments.likes -
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
                                                                            usercomments.likes +
                                                                                1,
                                                                        userprovider.userdata.userid: userprovider
                                                                            .userdata
                                                                            .userid
                                                                      });
                                                                    }
                                                                  },
                                                                  child: commentlike![userprovider
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
                                                                        builder: (_) =>
                                                                            Comments2(
                                                                              postid: commentid,
                                                                            )));
                                                              },
                                                              child:
                                                                  Text("Reply"))
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      ListTile(
                                                        leading: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: NetworkImage(
                                                                      usercomments
                                                                          .profile))),
                                                        ),
                                                        trailing: usercomments
                                                                    .userid ==
                                                                userprovider
                                                                    .userdata
                                                                    .userid
                                                            ? IconButton(
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                onPressed: () {
                                                                  deletecomment(
                                                                      context,
                                                                      commentid);
                                                                },
                                                              )
                                                            : Text(""),
                                                        subtitle: Text(
                                                            "${timeago.format(usercomments.timestamp.toDate())}"),
                                                        title: Text(
                                                            "${usercomments.firstname} :   ${usercomments.comment}"),
                                                      ),
                                                      Center(
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
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
                                                              Text(usercomments
                                                                  .likes
                                                                  .toString()),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (commentlike![userprovider.userdata.userid] ==
                                                                            userprovider
                                                                                .userdata.userid &&
                                                                        usercomments.likes !=
                                                                            0) {
                                                                      comments
                                                                          .doc(
                                                                              commentid)
                                                                          .update({
                                                                        "likes":
                                                                            usercomments.likes -
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
                                                                            usercomments.likes +
                                                                                1,
                                                                        userprovider.userdata.userid: userprovider
                                                                            .userdata
                                                                            .userid
                                                                      });
                                                                    }
                                                                  },
                                                                  child: commentlike![userprovider
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
                                                                        builder: (_) => Comments2(

                                                                            // postby:postby,
                                                                            postid: commentid)));
                                                              },
                                                              child:
                                                                  Text("Reply"))
                                                        ],
                                                      )
                                                    ],
                                                  );
                                          }),
                                    ));
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
                                return 'Please Add Post Title';
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
                                if (selectedfile != null) {
                                  UploadTask uploadTask = storageRef
                                      .child("${selectedfile}")
                                      .putFile(selectedfile!);
                                  TaskSnapshot storageSnap =
                                      await uploadTask.whenComplete(() => null);
                                  String downloadUrl =
                                      await storageSnap.ref.getDownloadURL();
                                  if (downloadUrl != null) {
                                    comments.doc().set({
                                      "userid": userprovider.userdata.userid,
                                      "username":
                                          userprovider.userdata.firstname,
                                      "profile": userprovider.userdata.profile,
                                      "postid": postid,
                                      "comment": comment.text.trim(),
                                      "type": "image",
                                      "image": downloadUrl,
                                      "likes": 0,
                                      "timestamp": DateTime.now()
                                    });
                                    notification.doc(postid).set({
                                      "id": postid,
                                      "username":
                                          userprovider.userdata.firstname,
                                      "profile": userprovider.userdata.profile,
                                      "userid": postby,
                                      "message": "Commented On your post",
                                      "by": userprovider.userdata.userid
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
                                    "username": userprovider.userdata.firstname,
                                    "profile": userprovider.userdata.profile,
                                    "postid": postid,
                                    "comment": comment.text.trim(),
                                    "type": "text",
                                    "image": "null",
                                    "likes": 0,
                                    "timestamp": DateTime.now()
                                  }).then((value) {
                                    notification.doc(postid).set({
                                      "id": postid,
                                      "username":
                                          userprovider.userdata.firstname,
                                      "profile": userprovider.userdata.profile,
                                      "userid": postby,
                                      "message": "Commented On your post",
                                      "by": userprovider.userdata.userid
                                    });
                                    comment.clear();
                                  }).onError((error, stackTrace) {
                                    showDialog(
                                        context: context,
                                        // ignore: unnecessary_brace_in_string_interps
                                        builder: (_) =>
                                            // ignore: unnecessary_brace_in_string_interps
                                            LogoutOverlay(message: "${error}"));
                                  });
                                }
                              }
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
        );
      });
}

void deletecomment(BuildContext context, String commentid) {
  comments.doc(commentid).delete().onError((error, stackTrace) {
    showDialog(
        context: context,
        // ignore: unnecessary_brace_in_string_interps
        builder: (_) => LogoutOverlay(message: "${error}"));
  });
}
