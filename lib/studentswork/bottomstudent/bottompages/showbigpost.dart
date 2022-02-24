import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/models/postmodel.dart';
import 'package:aisa/models/savedpostsmodel.dart';
import 'package:aisa/studentswork/UserProfile/userprofile.dart';
import 'package:aisa/studentswork/bigpost/bigpost.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showuserdata/showuserprofile.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comment.dart';
import 'package:aisa/studentswork/bottomstudent/posts/editpost.dart';
import 'package:aisa/studentswork/bottomstudent/posts/sharepost.dart';
import 'package:aisa/studentswork/bottomstudent/showinvisibleimage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../main.dart';

class ShowBigPost extends StatefulWidget {
  PostModel posts;
  Map<String, dynamic>? likesdata;
  DateTime date;

  ShowBigPost(
      {required this.posts, required this.likesdata, required this.date});

  @override
  _ShowBigPostState createState() => _ShowBigPostState();
}

class _ShowBigPostState extends State<ShowBigPost> {
  TextEditingController comment = TextEditingController();
  File? selectedfile;
  final formkey = GlobalKey<FormState>();
  final filter = ProfanityFilter();
  bool state = false;

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
    String userid = userprovider.userdata.userid;
    return Scaffold(
        bottomNavigationBar: Form(
          key: formkey,
          child: Row(
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
                      return 'Please write the comment';
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
                    if (userprovider.userdata.block == false) {
                      if (formkey.currentState!.validate()) {
                        if (selectedfile != null) {
                          setState(() {
                            state = true;
                          });
                          UploadTask uploadTask = storageRef
                              .child("${selectedfile}")
                              .putFile(selectedfile!);
                          TaskSnapshot storageSnap = await uploadTask
                              .whenComplete(() => null)
                              .onError((error, stackTrace) {
                            setState(() {
                              state = false;
                            });
                            throw error.toString();
                          });
                          String downloadUrl =
                              await storageSnap.ref.getDownloadURL();
                          if (downloadUrl != null) {
                            comments.doc().set({
                              "userid": userprovider.userdata.userid,
                              "username": userprovider.userdata.firstname,
                              "profile": userprovider.userdata.profile,
                              "postid": widget.posts.postid,
                              "comment": comment.text.trim(),
                              "type": "image",
                              "image": downloadUrl,
                              "likes": 0,
                              "timestamp": DateTime.now()
                            }).then((value) {
                              setState(() {
                                state = false;
                              });
                            });
                            notification.doc().set({
                              "id": widget.posts.postid,
                              "username": userprovider.userdata.firstname,
                              "profile": userprovider.userdata.profile,
                              "userid": widget.posts.postid,
                              "message": "Commented On your post",
                              "by": userprovider.userdata.userid,
                              "timestamp": DateTime.now()
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) => LogoutOverlay(
                                    message: "Comments is not sent try again"));
                          }
                        } else {
                          comments.doc().set({
                            "userid": userprovider.userdata.userid,
                            "username": userprovider.userdata.firstname,
                            "profile": userprovider.userdata.profile,
                            "postid": widget.posts.postid,
                            "comment": comment.text.trim(),
                            "type": "text",
                            "image": "null",
                            "likes": 0,
                            "timestamp": DateTime.now()
                          }).then((value) {
                            notification.doc().set({
                              "id": widget.posts.postid,
                              "username": userprovider.userdata.firstname,
                              "profile": userprovider.userdata.profile,
                              "userid": widget.posts.postid,
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
                                        message: "Please write the comment"));
                          });
                        }
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
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(color: Colors.indigo),
                  ))
            ],
          ),
        ),
        body: DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 1,
            expand: false,
            builder: (context, scrollcontroller) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: userpost.doc(widget.posts.postid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      DocumentSnapshot<Object?>? data = snapshot.data;
                      PostModel posts = PostModel.fromdoc(data!);
                      Map<String, dynamic>? likesdata =
                          data.data() as Map<String, dynamic>;
                      bool value;
                      if (posts.userid == userprovider.userdata.userid) {
                        value = true;
                      } else {
                        value = false;
                      }
                      return ListView(
                        controller: scrollcontroller,
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        trailing: GestureDetector(
                                            onTap: () {
                                              _popmenuoption(context, posts,
                                                  userid, value);
                                            },
                                            child: Icon(Icons.more_vert)),

                                        //Profile Image
                                        leading: GestureDetector(
                                          onTap: () {
                                            if (posts.userid == userid) {
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
                                                          ShowUserProfile(
                                                              userid: posts
                                                                  .userid)));
                                            }
                                          },
                                          child: posts.profile == ""
                                              ? Container(
                                                  child: CircleAvatar(
                                                      child: Text(
                                                  posts.firstname[0],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )))
                                              : Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              posts.profile))),
                                                ),
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              posts.firstname,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                  timeago.format(widget.date),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ],
                                        ),

                                        subtitle: SizedBox(
                                          height: 30,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                posts.useruni,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  posts.location,
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 15),
                                        child: Text(
                                          posts.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: ReadMoreText(
                                          posts.description,
                                          trimLines: 2,
                                          style: TextStyle(color: Colors.black),
                                          colorClickableText: Colors.pink,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: '...Show more',
                                          trimExpandedText: ' show less',
                                        ),
                                      ),
                                      posts.type == "image"
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BigPostInvisible(
                                                                postModel:
                                                                    posts,
                                                                likesdata:
                                                                    likesdata)));
                                              },
                                              child: Center(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: 250,
                                                  child: Image.network(
                                                    posts.postimage,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text(""),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // ignore: deprecated_member_use
                                          FlatButton.icon(
                                              onPressed: () {
                                                print("object");
                                                if (likesdata[userid] ==
                                                        userid &&
                                                    likesdata["likes"] != 0) {
                                                  userpost
                                                      .doc(posts.postid)
                                                      .update({
                                                    "postimage":
                                                        posts.postimage,
                                                    "title": posts.title,
                                                    "description":
                                                        posts.description,
                                                    "category": posts.category,
                                                    "location": posts.location,
                                                    "userid": posts.userid,
                                                    "userimage": posts.profile,
                                                    "postid": posts.postid,
                                                    "timestamp":
                                                        posts.timestamp,
                                                    "username": posts.firstname,
                                                    "likes": posts.likes - 1,
                                                    userid: "null",
                                                    "notification": userid,
                                                    "${posts.postid}name":
                                                        "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}"
                                                  });
                                                  notification.doc().set({
                                                    "id": posts.postid,
                                                    "username":
                                                        "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                                                    "profile": userprovider
                                                        .userdata.profile,
                                                    "userid": posts.userid,
                                                    "message":
                                                        "dislikes Your Post",
                                                    "by": userid,
                                                    "timestamp": DateTime.now()
                                                  });
                                                } else {
                                                  userpost
                                                      .doc(posts.postid)
                                                      .update({
                                                    "postimage":
                                                        posts.postimage,
                                                    "title": posts.title,
                                                    "description":
                                                        posts.description,
                                                    "category": posts.category,
                                                    "location": posts.location,
                                                    "userid": posts.userid,
                                                    "userimage": posts.profile,
                                                    "postid": posts.postid,
                                                    "timestamp":
                                                        posts.timestamp,
                                                    "username": posts.firstname,
                                                    "likes": posts.likes + 1,
                                                    "notification": userid,
                                                    userid: userid,
                                                    "${posts.postid}name":
                                                        "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}"
                                                  });
                                                  notification.doc().set({
                                                    "id": posts.postid,
                                                    "username":
                                                        "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                                                    "profile": userprovider
                                                        .userdata.profile,
                                                    "userid": posts.userid,
                                                    "message":
                                                        "likes Your Post",
                                                    "by": userid,
                                                    "timestamp": DateTime.now()
                                                  });
                                                }
                                              },
                                              icon: likesdata[userid] == userid
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(Icons.favorite_border),
                                              label: Text(likesdata["likes"]
                                                  .toString())),
                                          // ignore: deprecated_member_use
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (_) => Comments(
                                                  //             postid: posts.postid,)));
                                                },
                                                icon: Icon(
                                                  Icons.message,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                  stream: comments
                                                      .where("postid",
                                                          isEqualTo:
                                                              posts.postid)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      QuerySnapshot?
                                                          commentdata =
                                                          snapshot.data;
                                                      return Text(commentdata!
                                                          .docs.length
                                                          .toString());
                                                    } else {
                                                      return Text("0");
                                                    }
                                                  })
                                            ],
                                          ),
                                          // ignore: deprecated_member_use
                                          IconButton(
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
                                                          ShareInChat(
                                                              posts: posts)));
                                            },
                                            icon: Icon(
                                              Icons.share,
                                              color: Colors.indigo,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 700,
                              child: Comments(
                                postid: posts.postid,
                                scrollController: scrollcontroller,
                                postby: posts.userid,
                              ))
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  });
            }));
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

class ShowBigPost2 extends StatelessWidget {
  late SavedPostModel posts2;
  dynamic likesdata;
  DateTime date;

  ShowBigPost2(
      {required this.posts2, required this.likesdata, required this.date});

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    String userid = userprovider.userdata.userid;
    return Scaffold(
        appBar: AppBar(),
        body: DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 1,
            expand: false,
            builder: (context, scrollcontroller) {
              return ListView(
                controller: scrollcontroller,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                trailing: myPopMenu2(context, posts2, userid),
                                //Profile Image
                                leading: GestureDetector(
                                  onTap: () {
                                    if (posts2.userid == userid) {
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
                                                  ShowUserProfile(
                                                      userid: posts2.userid)));
                                    }
                                  },
                                  child: posts2.profile == ""
                                      ? Container(
                                          child: CircleAvatar(
                                              child: Text(
                                          posts2.firstname[0],
                                          style: TextStyle(color: Colors.white),
                                        )))
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      posts2.profile))),
                                        ),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      posts2.firstname,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(timeago.format(date),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      posts2.university,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        posts2.location,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 15),
                                child: Text(
                                  posts2.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ReadMoreText(
                                  posts2.description,
                                  trimLines: 2,
                                  style: TextStyle(color: Colors.black),
                                  colorClickableText: Colors.pink,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '...Show more',
                                  trimExpandedText: ' show less',
                                ),
                              ),
                              posts2.type == "image"
                                  ? GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => BigPost(
                                        //               postModel: posts,
                                        //             )));
                                      },
                                      child: Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 250,
                                          child: Image.network(
                                            posts2.postimage,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(""),
                              Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  FlatButton.icon(
                                      onPressed: () {
                                        print("preesed");
                                        if (likesdata[userid] == userid &&
                                            likesdata["likes"] != 0) {
                                          userpost.doc(posts2.postid).update({
                                            "postimage": posts2.postimage,
                                            "title": posts2.title,
                                            "description": posts2.description,
                                            "category": posts2.category,
                                            "location": posts2.location,
                                            "userid": posts2.userid,
                                            "userimage": posts2.profile,
                                            "postid": posts2.postid,
                                            "timestamp": posts2.timestamp,
                                            "username": posts2.firstname,
                                            "likes": posts2.likes - 1,
                                            userid: "null",
                                            "${posts2.postid}name":
                                                "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}"
                                          });
                                          notification.doc().set({
                                            "id": posts2.postid,
                                            "username":
                                                "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                                            "profile":
                                                userprovider.userdata.profile,
                                            "userid": posts2.userid,
                                            "message": "dislikes Your Post",
                                            "by": userid,
                                            "timestamp": DateTime.now()
                                          });
                                        } else {
                                          userpost.doc(posts2.postid).update({
                                            "postimage": posts2.postimage,
                                            "title": posts2.title,
                                            "description": posts2.description,
                                            "category": posts2.category,
                                            "location": posts2.location,
                                            "userid": posts2.userid,
                                            "userimage": posts2.profile,
                                            "postid": posts2.postid,
                                            "timestamp": posts2.timestamp,
                                            "username": posts2.firstname,
                                            "likes": posts2.likes + 1,
                                            userid: userid,
                                            "${posts2.postid}name":
                                                "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}"
                                          });
                                          notification.doc().set({
                                            "id": posts2.postid,
                                            "username":
                                                "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                                            "profile":
                                                userprovider.userdata.profile,
                                            "userid": posts2.userid,
                                            "message": "likes Your Post",
                                            "by": userid,
                                            "timestamp": DateTime.now()
                                          });
                                        }
                                      },
                                      icon: likesdata![userid] == userid
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.favorite_border),
                                      label:
                                          Text(likesdata["likes"].toString())),
                                  // ignore: deprecated_member_use
                                  Row(
                                    children: [
                                      FlatButton.icon(
                                        onPressed: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (_) => Comments(
                                          //             postid: posts.postid,)));
                                        },
                                        icon: Icon(
                                          Icons.message,
                                          color: Colors.indigo,
                                        ),
                                        label: Text('Comments'),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: comments
                                              .where("postid",
                                                  isEqualTo: posts2.postid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              QuerySnapshot? commentdata =
                                                  snapshot.data;
                                              return Text(commentdata!
                                                  .docs.length
                                                  .toString());
                                            } else {
                                              return Text("0");
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
                                                  ShareInChat2(posts: posts2)));
                                    },
                                    icon: Icon(
                                      Icons.save,
                                      color: Colors.indigo,
                                    ),
                                    label: Text('Share'),
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
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 700,
                      child: Comments(
                        postid: posts2.postid,
                        scrollController: scrollcontroller,
                        postby: posts2.userid,
                      ))
                ],
              );
            }));
  }
}

Widget myPopMenu2(BuildContext context, SavedPostModel posts, String userid) {
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

void _popmenuoption(
    BuildContext context, PostModel posts, String userid, bool value) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: new Icon(
                Icons.save,
                color: Colors.indigo,
              ),
              title: new Text(
                'Save',
              ),
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
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (_) => LogoutOverlay(message: "Post Saved"));
                }).onError((error, stackTrace) {
                  showDialog(
                      context: context,
                      builder: (_) => LogoutOverlay(
                          // ignore: unnecessary_brace_in_string_interps
                          message: "${error}"));
                });
              },
            ),
            Visibility(
              visible: value,
              child: ListTile(
                leading: new Icon(Icons.edit),
                title: new Text('Edit'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Editpost(
                                posts: posts,
                              )));
                },
              ),
            ),
            Visibility(
              visible: value,
              child: ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Delete'),
                onTap: () {
                  if (posts.type == "image") {
                    FirebaseStorage.instance
                        .refFromURL(posts.postimage)
                        .delete()
                        .then((value) {
                      userpost.doc(posts.postid).delete().then((value) {
                        showDialog(
                            context: context,
                            builder: (_) =>
                                LogoutOverlay(message: "Post Deleted"));
                      });
                    });
                  } else {
                    userpost.doc(posts.postid).delete().then((value) {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (_) =>
                              LogoutOverlay(message: "Post Deleted"));
                    });
                  }
                },
              ),
            ),
            Visibility(
              visible: value == false ? true : false,
              child: ListTile(
                leading: new Icon(
                  Icons.report,
                  color: Colors.indigo,
                ),
                title: new Text(
                  'Report Post',
                ),
                onTap: () {
                  reportpost.doc(posts.postid).set({
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
                    "reportedby": userid
                  }).then((value) {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (_) =>
                            LogoutOverlay(message: "Post Reported"));
                  }).onError((error, stackTrace) {
                    showDialog(
                        context: context,
                        builder: (_) => LogoutOverlay(
                            // ignore: unnecessary_brace_in_string_interps
                            message: "${error}"));
                  });
                },
              ),
            ),
          ],
        );
      });
}
