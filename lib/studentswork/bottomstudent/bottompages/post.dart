import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/bussinesswork/businessmodel/businesspostmodel.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/commentmodel.dart';
import 'package:aisa/models/postmodel.dart';
import 'package:aisa/studentswork/Drawer/drawer.dart';
import 'package:aisa/studentswork/Search/searchcity.dart';
import 'package:aisa/studentswork/UserProfile/userprofile.dart';
import 'package:aisa/studentswork/bigpost/bigpost.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showbigpost.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showuserdata/showuserprofile.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comment.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comment3.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comments2.dart';
import 'package:aisa/studentswork/bottomstudent/notific/socailnotification.dart';
import 'package:aisa/studentswork/bottomstudent/posts/addpost.dart';
import 'package:aisa/studentswork/bottomstudent/posts/editpost.dart';
import 'package:aisa/studentswork/bottomstudent/posts/sharepost.dart';
import 'package:aisa/studentswork/bottomstudent/settings/savedpost.dart';
import 'package:aisa/studentswork/bottomstudent/showinvisibleimage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {
  Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

bool isliked = false;
showAlertDialog(BuildContext context) {
  // Create button
  // ignore: deprecated_member_use
  Widget okButton = FlatButton(
    child: Text("Save Post"),
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SavedPost()));
    },
  );

  // ignore: deprecated_member_use
  Widget noButton = FlatButton(
    child: Text("No, Thanks"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Posts"),
    content: Text("You want to Save the Post."),
    actions: [okButton, noButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _PostState extends State<Post> {
  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    String utoken = (await FirebaseMessaging.instance.getToken())!;
    FirebaseAuth user = FirebaseAuth.instance;
    userfirestore.doc(user.currentUser!.uid).update({"token": utoken});
    print(utoken);
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    String userid = userprovider.userdata.userid;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        // automaticallyImplyLeading: false,
        title: Text('AISP'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchCity()));
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: userpost.orderBy("timestamp", descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;

            return data!.size == 0
                ? Center(
                    child: Text("No Posts"),
                  )
                : ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic>? likesdata =
                          data.docs[index].data() as Map<String, dynamic>?;
                      return postsshow(
                          likesdata,
                          data,
                          index,
                          userid,
                          userprovider.userdata.cityname,
                          userprovider.userdata.firstname,
                          userprovider.userdata.profile,
                          userprovider);

                      // String id = data.docs[index].id;
                      // ignore: unused_local_variable
                    });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPost(
                        location: userprovider.userdata.cityname,
                      )));
        },
      ),
      //Functions
    );

    //Fuctions
  }

  Widget postsshow(
      likesdata,
      QuerySnapshot data,
      index,
      String userid,
      String usercity,
      String username,
      String userprofile,
      UserProvider userprovider) {
    if (likesdata["posttype"] == "business") {
      BusinesspostModel businesspost =
          BusinesspostModel.fromquerysnapshot(data, index);
      DateTime date = businesspost.timestamp.toDate();
      return businesspost.location != usercity
          ? Text("")
          : Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                shadowColor: Colors.white70,
                color: Colors.white60,
                child: SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Image.asset('assets/images/aisa.png'),
                        ),
                        title: Text(businesspost.firstname),
                        trailing: Text(timeago.format(date).toString()),
                        subtitle: Text(
                          businesspost.title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ReadMoreText(
                          businesspost.description,
                          trimLines: 2,
                          style: TextStyle(color: Colors.black),
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...Show more',
                          trimExpandedText: ' show less',
                        ),
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 250,
                          child: Image.network(
                            businesspost.postimage,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ignore: deprecated_member_use
                            FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.price_change,
                                color: Colors.indigo,
                              ),
                              label: Text(businesspost.price),
                            ),

                            // ignore: deprecated_member_use
                            FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.phone,
                                color: Colors.indigo,
                              ),
                              label: Text(businesspost.businessphone),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    } else {
      PostModel posts = PostModel.fromquerysnapshot(data, index);
      DateTime date = posts.timestamp.toDate();
      bool value;
      if (posts.userid == userid) {
        value = true;
      } else {
        value = false;
      }
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      trailing: GestureDetector(
                          onTap: () {
                            _popmenuoption(context, posts, userid, value);
                          },
                          child: Icon(Icons.more_vert)),
                      // myPopMenu(context, posts, userid),

                      //Profile Image
                      leading: GestureDetector(
                        onTap: () {
                          if (posts.userid == userid) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfile()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowUserProfile(userid: posts.userid)));
                          }
                        },
                        child: posts.profile == ""
                            ? Container(
                                child: CircleAvatar(
                                    child: Text(
                                posts.firstname[0],
                                style: TextStyle(color: Colors.white),
                              )))
                            : Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(posts.profile))),
                              ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            posts.firstname,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(timeago.format(date),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                posts.location,
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 15),
                      child: Text(
                        posts.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowBigPost(
                                    posts: posts,
                                    likesdata: likesdata,
                                    date: date)));
                      },
                      child: Padding(
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
                    ),
                    posts.type == "image"
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowBigPost(
                                          posts: posts,
                                          likesdata: likesdata,
                                          date: date)));
                              // Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (_) =>  BigPostInvisible (
                              //                    postModel: posts,

                              //                    likesdata: likesdata,)));
                            },
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 250,
                                child: Image.network(
                                  posts.postimage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        : Text(""),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ignore: deprecated_member_use
                          FlatButton.icon(
                              onPressed: () {
                                if (likesdata[userid] == userid &&
                                    likesdata["likes"] != 0) {
                                  userpost.doc(posts.postid).update({
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
                                    "likes": posts.likes - 1,
                                    userid: "null",
                                    "notification": userid,
                                    "${posts.postid}name":
                                        "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}"
                                  });
                                  notification.doc().set({
                                    "id": posts.postid,
                                    "username": username,
                                    "profile": userprofile,
                                    "userid": posts.userid,
                                    "message": "dislikes Your Post",
                                    "by": userid,
                                    "timestamp": DateTime.now()
                                  });
                                } else {
                                  userpost.doc(posts.postid).update({
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
                                    "likes": posts.likes + 1,
                                    "notification": userid,
                                    userid: userid,
                                    "${posts.postid}name":
                                        "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}"
                                  });
                                  notification.doc().set({
                                    "id": posts.postid,
                                    "username": username,
                                    "profile": userprofile,
                                    "userid": posts.userid,
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
                              label: Text(likesdata["likes"].toString())),
                          // ignore: deprecated_member_use
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _settingModalBottomSheet(
                                      context, posts.postid, posts.userid);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (_) =>  ShowBigPost (
                                  //            posts: posts,
                                  //            date: date,
                                  //            likesdata: likesdata,)));
                                },
                                icon: Icon(
                                  Icons.message,
                                  color: Colors.indigo,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: comments
                                      .where("postid", isEqualTo: posts.postid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot? commentdata =
                                          snapshot.data;
                                      return Text(
                                          commentdata!.docs.length.toString());
                                    } else {
                                      return Text("");
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
                                          ShareInChat(posts: posts)));
                            },
                            icon: Icon(
                              Icons.share,
                              color: Colors.indigo,
                            ),
                            label: Text(''),
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
                    SizedBox(
                      height: 15,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: comments
                            .where("postid", isEqualTo: posts.postid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot? commentdata = snapshot.data;
                            return Column(
                              children: [
                                Visibility(
                                  visible:
                                      commentdata!.size == 0 ? false : true,
                                  child: Divider(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Visibility(
                                      visible:
                                          commentdata.size == 0 ? false : true,
                                      child: GestureDetector(
                                        onTap: () {
                                          _settingModalBottomSheet(context,
                                              posts.postid, posts.userid);
                                        },
                                        child: SizedBox(
                                          height: 140,
                                          child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                Map<String, dynamic>?
                                                    commentlike = commentdata
                                                            .docs[index]
                                                            .data()
                                                        as Map<String,
                                                            dynamic>?;
                                                CommentModel usercomments =
                                                    CommentModel
                                                        .fromquerysnapshot(
                                                            commentdata, index);
                                                String commentid =
                                                    commentdata.docs[index].id;
                                                return usercomments.type ==
                                                        "text"
                                                    ? Column(
                                                        children: [
                                                          ListTile(
                                                            leading: usercomments
                                                                        .profile ==
                                                                    ""
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      if (usercomments
                                                                              .userid ==
                                                                          userprovider
                                                                              .userdata
                                                                              .userid) {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => UserProfile()));
                                                                      } else {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ShowUserProfile(userid: usercomments.userid)));
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        child: CircleAvatar(
                                                                            child: Text(
                                                                      usercomments
                                                                          .firstname[0],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ))),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      if (usercomments
                                                                              .userid ==
                                                                          userprovider
                                                                              .userdata
                                                                              .userid) {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => UserProfile()));
                                                                      } else {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ShowUserProfile(userid: usercomments.userid)));
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: NetworkImage(usercomments.profile))),
                                                                    ),
                                                                  ),
                                                            title: Card(
                                                              color: Colors
                                                                  .grey[300],
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.8,
                                                                child: ListTile(
                                                                  trailing: usercomments
                                                                              .userid ==
                                                                          userprovider
                                                                              .userdata
                                                                              .userid
                                                                      ? IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            deletecomment(context,
                                                                                commentid);
                                                                          },
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            reportcomment(context,
                                                                                usercomments);
                                                                          },
                                                                          child:
                                                                              Icon(Icons.more_vert)),
                                                                  subtitle:
                                                                      Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        usercomments
                                                                            .comment,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "${timeago.format(usercomments.timestamp.toDate())}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  title: Text(
                                                                      usercomments
                                                                          .firstname),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            30),
                                                                child: Row(
                                                                  children: [
                                                                    Text(usercomments
                                                                        .likes
                                                                        .toString()),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (commentlike![userprovider.userdata.userid] == userprovider.userdata.userid &&
                                                                              usercomments.likes != 0) {
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
                                                                        child: commentlike![userprovider.userdata.userid] ==
                                                                                userprovider.userdata.userid
                                                                            ? Text("Liked")
                                                                            : Text("Like")),
                                                                  ],
                                                                ),
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (_) => Comments2(
                                                                                  postid: commentid,
                                                                                )));
                                                                  },
                                                                  child: Text(
                                                                      "Reply"))
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          ListTile(
                                                            leading: usercomments
                                                                        .profile ==
                                                                    ""
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      if (usercomments
                                                                              .userid ==
                                                                          userprovider
                                                                              .userdata
                                                                              .userid) {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => UserProfile()));
                                                                      } else {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ShowUserProfile(userid: usercomments.userid)));
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        child: CircleAvatar(
                                                                            child: Text(
                                                                      usercomments
                                                                          .firstname[0],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ))),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      if (usercomments
                                                                              .userid ==
                                                                          userprovider
                                                                              .userdata
                                                                              .userid) {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => UserProfile()));
                                                                      } else {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ShowUserProfile(userid: usercomments.userid)));
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: NetworkImage(usercomments.profile))),
                                                                    ),
                                                                  ),
                                                            title: Card(
                                                              shape: RoundedRectangleBorder(
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
                                                                      trailing: usercomments.userid ==
                                                                              userprovider.userdata.userid
                                                                          ? IconButton(
                                                                              icon: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.red,
                                                                              ),
                                                                              onPressed: () {
                                                                                deletecomment(context, commentid);
                                                                              },
                                                                            )
                                                                          : GestureDetector(
                                                                              onTap: () {
                                                                                reportcomment(context, usercomments);
                                                                              },
                                                                              child: Icon(Icons.more_vert)),
                                                                      subtitle:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "${timeago.format(usercomments.timestamp.toDate())}",
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                          ),
                                                                          Text(
                                                                            usercomments.comment,
                                                                            style:
                                                                                TextStyle(fontSize: 18),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      title: Text(
                                                                          usercomments
                                                                              .firstname),
                                                                    ),
                                                                    //             Center(
                                                                    //   child: Container(
                                                                    //     width: MediaQuery.of(context)
                                                                    //             .size
                                                                    //             .width *
                                                                    //         0.9,
                                                                    //     height: 250,
                                                                    //     child: Image.network(
                                                                    //       usercomments.image,
                                                                    //       fit: BoxFit.fill,
                                                                    //     ),
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
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
                                                                        if (commentlike![userprovider.userdata.userid] == userprovider.userdata.userid &&
                                                                            usercomments.likes !=
                                                                                0) {
                                                                          comments
                                                                              .doc(
                                                                                  commentid)
                                                                              .update({
                                                                            "likes":
                                                                                usercomments.likes - 1,
                                                                            userprovider.userdata.userid:
                                                                                "null"
                                                                          });
                                                                        } else {
                                                                          comments
                                                                              .doc(commentid)
                                                                              .update({
                                                                            "likes":
                                                                                usercomments.likes + 1,
                                                                            userprovider.userdata.userid:
                                                                                userprovider.userdata.userid
                                                                          });
                                                                        }
                                                                      },
                                                                      child: commentlike![userprovider.userdata.userid] ==
                                                                              userprovider
                                                                                  .userdata.userid
                                                                          ? Text(
                                                                              "Liked")
                                                                          : Text(
                                                                              "Like")),
                                                                ],
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                Comments2(postid: commentid)));
                                                                  },
                                                                  child: Text(
                                                                      "Reply"))
                                                            ],
                                                          )
                                                        ],
                                                      );
                                              }),
                                        ),
                                      )),
                                ),
                              ],
                            );
                          } else {
                            return Text("0");
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
//  Widget myPopMenu(
//     BuildContext context, PostModel posts, String userid ) {
//   return PopupMenuButton(
//       onSelected: (value) {},
//       itemBuilder: (context) => [

//             PopupMenuItem(
//                 value: 1,
//                 child: Row(
//                   children: <Widget>[
//                     GestureDetector(
//                         onTap: () {

//                           saveMyposts.doc(posts.postid).set({
//                                         "postimage": posts.postimage,
//                                         "title": posts.title,
//                                         "description": posts.description,
//                                         "category": posts.category,
//                                         "location": posts.location,
//                                         "userid": posts.userid,
//                                         "userimage": posts.profile,
//                                         "postid": posts.postid,
//                                         "timestamp": posts.timestamp,
//                                         "username": posts.firstname,
//                                         "likes": posts.likes,
//                                         "type":posts.type,
//                                         "university":posts.useruni,
//                                         "savedby": userid
//                                       }).then((value) {
//                                         showDialog(
//                                             context: context,
//                                             builder: (_) => LogoutOverlay(
//                                                 message: "Post Saved"));
//                                       }).onError((error, stackTrace) {
//                                         showDialog(
//                                             context: context,
//                                             builder: (_) => LogoutOverlay(
//                                                 // ignore: unnecessary_brace_in_string_interps
//                                                 message: "${error}"));
//                                       });

//                           Navigator.pop(context);
//                         },
//                         child: Text('Save'))
//                   ],
//                 )),
//                   PopupMenuItem(
//                     enabled: posts.userid==userid?true:false,
//                height:     posts.userid==userid?10:0,

//                 value: 2,
//                 child: Row(
//                   children: <Widget>[
//                     GestureDetector(
//                         onTap: () {
//                           if(posts.type=="image"){
//     FirebaseStorage.instance.refFromURL(posts.postimage).delete().then((value){
//  userpost.doc(posts.postid).delete().then((value){

//                              showDialog(
//                                             context: context,
//                                             builder: (_) => LogoutOverlay(
//                                                 message: "Post Deleted"));
//                           });
//                        });
//                           }else{
//                             userpost.doc(posts.postid).delete().then((value){

//                              showDialog(
//                                             context: context,
//                                             builder: (_) => LogoutOverlay(
//                                                 message: "Post Deleted"));
//                           });
//                           }

//                           Navigator.pop(context);
//                         },
//                         child: Text('delete'))
//                   ],
//                 )),

//           ]);
// }
void _settingModalBottomSheet(context, postid, postby) {
  // TextEditingController comment = TextEditingController();
  // File? selectedfile;
  // final formkey = GlobalKey<FormState>();
  // final filter = ProfanityFilter();
  //  void handleGallery() async {
  //   await Permission.photos.request();

  //   var permission = await Permission.photos.status;
  //   if (permission.isGranted) {
  //     // final picker = ImagePicker();
  //     final pickedfile =
  //         await ImagePicker().getImage(source: ImageSource.gallery);
  //     File file = File(pickedfile!.path);

  //       selectedfile = file;
  //     Navigator.pop(context);

  //   } else {
  //     Widget okButton = TextButton(
  //       child: Text("OK"),
  //       onPressed: () => Navigator.pop(context),
  //     );
  //     return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Center(
  //           child: AlertDialog(
  //             title: Text("Permissons"),
  //             content: Text("Please grant the access permission."),
  //             actions: [
  //               okButton,
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   }

  //   // final picker = ImagePicker();
  //   // PickedFile pickedfile = await picker.getImage(source: ImageSource.gallery);
  //   // file = File(pickedfile.path);
  // }

  // void handleCamera() async {
  //   Navigator.pop(context);
  //   await Permission.photos.request();

  //   var permission = await Permission.photos.status;
  //   if (permission.isGranted) {
  //     // final picker = ImagePicker();
  //     final pickedfile =
  //         await ImagePicker().getImage(source: ImageSource.camera);
  //     var file = File(pickedfile!.path);
  //     // File file = await ImagePicker.platform
  //     //     .pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 970)
  //     //     .then((value) => null);

  //       selectedfile = file;
  //        Navigator.pop(context);

  //   } else {
  //     Widget okButton = TextButton(
  //       child: Text("OK"),
  //       onPressed: () => Navigator.pop(context),
  //     );
  //     return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Center(
  //           child: AlertDialog(
  //             title: Text("Permissons"),
  //             content: Text("Please grant the access permission."),
  //             actions: [
  //               okButton,
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }

  // selectImage(parentcontext) {
  //   return showDialog(
  //       context: parentcontext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text("create post"),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //               child: Text("Select From Gallery"),
  //               onPressed: () => handleGallery(),
  //             ),
  //             SimpleDialogOption(
  //               child: Text("Select From Camera"),
  //               onPressed: () => handleCamera(),
  //             ),
  //             SimpleDialogOption(
  //               child: Text("Cancel"),
  //               onPressed: () => Navigator.pop(context),
  //             ),
  //           ],
  //         );
  //       });
  // }

  showModalBottomSheet(
      enableDrag: true,
      elevation: 10,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        var userprovider = Provider.of<UserProvider>(context, listen: false);
        return SafeArea(
          child: Scaffold(

              // body: SingleChildScrollView(

              //         child: Container(
              //           margin: EdgeInsets.only(left: 10, right: 10),
              //           child: Form(
              //             key: formkey,
              //             // child: Column(
              //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             //   children: [
              //              child:
              body: Comments3(
            postby: postby,
            postid: postid,
          )
              //  StreamBuilder<QuerySnapshot>(
              //     stream: comments
              //         .where("postid", isEqualTo: postid)
              //         .snapshots(),
              //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.hasData) {
              //         QuerySnapshot? commentdata = snapshot.data;

              //         return SizedBox(
              //   height:commentdata!.size==0?MediaQuery.of(context).size.height * 0.9: MediaQuery.of(context).size.height * 0.9,
              //   child: commentdata.size==0?Center(child: Text("No Comments")): Padding(
              //     padding: const EdgeInsets.only(top:28.0),
              //     child: ListView.builder(

              //               shrinkWrap: true,
              //               itemCount: commentdata.docs.length,
              //               itemBuilder: (context, index) {
              //                 Map<String, dynamic>? commentlike =
              //                     commentdata.docs[index].data()
              //                         as Map<String, dynamic>?;

              //                 CommentModel usercomments =
              //                     CommentModel.fromquerysnapshot(
              //                         commentdata, index);
              //                 String commentid = commentdata.docs[index].id;
              //                 return usercomments.type == "text"
              //                     ? Column(
              //                         children: [
              //                           ListTile(
              //                             leading: usercomments.profile==""?Container(
              //                         child:CircleAvatar(child:Text(usercomments.firstname[0],style: TextStyle(color: Colors.white),))):Container(
              //                               height: 30,
              //                               width: 30,
              //                               decoration: BoxDecoration(
              //                                   shape: BoxShape.circle,
              //                                   image: DecorationImage(
              //                                       fit: BoxFit.cover,
              //                                       image: NetworkImage(
              //                                           usercomments.profile))),
              //                             ),
              //                             trailing: usercomments.userid ==
              //                                     userprovider.userdata.userid
              //                                 ? IconButton(
              //                                     icon: Icon(
              //                                       Icons.delete,
              //                                       color: Colors.red,
              //                                     ),
              //                                     onPressed: () {
              //                                       deletecomment(
              //                                           context, commentid);
              //                                     },
              //                                   )
              //                                 : Text(""),
              //                             subtitle: Text(
              //                                 "${timeago.format(usercomments.timestamp.toDate())}"),
              //                             title: Text(
              //                                 "${usercomments.firstname} :   ${usercomments.comment}"),
              //                           ),
              //                           Row(
              //                             children: [
              //                               Row(
              //                                 children: [
              //                                   Text(usercomments.likes
              //                                       .toString()),
              //                                   TextButton(
              //                                       onPressed: () {
              //                                         if (commentlike![
              //                                                     userprovider
              //                                                         .userdata
              //                                                         .userid] ==
              //                                                 userprovider
              //                                                     .userdata
              //                                                     .userid &&
              //                                             usercomments.likes !=
              //                                                 0) {
              //                                           comments
              //                                               .doc(commentid)
              //                                               .update({
              //                                             "likes":
              //                                                 usercomments.likes -
              //                                                     1,
              //                                             userprovider.userdata
              //                                                 .userid: "null"
              //                                           });
              //                                         } else {
              //                                           comments
              //                                               .doc(commentid)
              //                                               .update({
              //                                             "likes":
              //                                                 usercomments.likes +
              //                                                     1,
              //                                             userprovider.userdata
              //                                                     .userid:
              //                                                 userprovider
              //                                                     .userdata.userid
              //                                           });
              //                                         }
              //                                       },
              //                                       child: commentlike![
              //                                                   userprovider
              //                                                       .userdata
              //                                                       .userid] ==
              //                                               userprovider
              //                                                   .userdata.userid
              //                                           ? Text("Liked")
              //                                           : Text("Like")),
              //                                 ],
              //                               ),
              //                               TextButton(
              //                                   onPressed: () {
              //                                     Navigator.push(
              //                                         context,
              //                                         MaterialPageRoute(
              //                                             builder: (_) => Comments2(
              //                                                 postid:
              //                                                     commentid,)));
              //                                   },
              //                                   child: Text("Reply"))
              //                             ],
              //                           )
              //                         ],
              //                       )
              //                     : Column(
              //                         children: [
              //                           ListTile(
              //                             leading: Container(
              //                               height: 30,
              //                               width: 30,
              //                               decoration: BoxDecoration(
              //                                   shape: BoxShape.circle,
              //                                   image: DecorationImage(
              //                                       fit: BoxFit.cover,
              //                                       image: NetworkImage(
              //                                           usercomments.profile))),
              //                             ),
              //                             trailing: usercomments.userid ==
              //                                     userprovider.userdata.userid
              //                                 ? IconButton(
              //                                     icon: Icon(
              //                                       Icons.delete,
              //                                       color: Colors.red,
              //                                     ),
              //                                     onPressed: () {
              //                                       deletecomment(
              //                                           context, commentid);
              //                                     },
              //                                   )
              //                                 : Text(""),
              //                             subtitle: Text(
              //                                 "${timeago.format(usercomments.timestamp.toDate())}"),
              //                             title: Text(
              //                                 "${usercomments.firstname} :   ${usercomments.comment}"),
              //                           ),
              //                           Center(
              //                             child: Container(
              //                               width: MediaQuery.of(context)
              //                                       .size
              //                                       .width *
              //                                   0.9,
              //                               height: 250,
              //                               child: Image.network(
              //                                 usercomments.image,
              //                                 fit: BoxFit.fill,
              //                               ),
              //                             ),
              //                           ),
              //                           Row(
              //                             children: [
              //                               Row(
              //                                 children: [
              //                                   Text(usercomments.likes
              //                                       .toString()),
              //                                   TextButton(
              //                                       onPressed: () {
              //                                         if (commentlike![
              //                                                     userprovider
              //                                                         .userdata
              //                                                         .userid] ==
              //                                                 userprovider
              //                                                     .userdata
              //                                                     .userid &&
              //                                             usercomments.likes !=
              //                                                 0) {
              //                                           comments
              //                                               .doc(commentid)
              //                                               .update({
              //                                             "likes":
              //                                                 usercomments.likes -
              //                                                     1,
              //                                             userprovider.userdata
              //                                                 .userid: "null"
              //                                           });
              //                                         } else {
              //                                           comments
              //                                               .doc(commentid)
              //                                               .update({
              //                                             "likes":
              //                                                 usercomments.likes +
              //                                                     1,
              //                                             userprovider.userdata
              //                                                     .userid:
              //                                                 userprovider
              //                                                     .userdata.userid
              //                                           });
              //                                         }
              //                                       },
              //                                       child: commentlike![
              //                                                   userprovider
              //                                                       .userdata
              //                                                       .userid] ==
              //                                               userprovider
              //                                                   .userdata.userid
              //                                           ? Text("Liked")
              //                                           : Text("Like")),
              //                                 ],
              //                               ),
              //                               TextButton(
              //                                   onPressed: () {
              //                                     Navigator.push(
              //                                         context,
              //                                         MaterialPageRoute(
              //                                             builder: (_) => Comments2(

              //                                               // postby:postby,
              //                                                 postid:
              //                                                     commentid)));
              //                                   },
              //                                   child: Text("Reply"))
              //                             ],
              //                           )
              //                         ],
              //                       );
              //               }),
              //   ));
              //       } else {
              //         return Center(child: Text("no data"));
              //       }
              //     },
              //   ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.photo),
              //       iconSize: 25,
              //       color: Theme.of(context).primaryColor,
              //       onPressed: () {
              //         selectImage(context);
              //       },
              //     ),
              //     Flexible(
              //       child: TextFormField(
              //         controller: comment,
              //         validator: (value) {
              //           if (value!.isNotEmpty&&filter.hasProfanity(value)==false) {
              //             return null;
              //           } else if(filter.hasProfanity(value)==true){
              //             return "Vulgar Words are not allowed";
              //           }

              //            else {
              //             return 'Please Add Post Title';
              //           }
              //         },
              //         decoration: InputDecoration(
              //             border: OutlineInputBorder(),
              //             labelText: ' Comment',
              //             hintText: 'Write Your  Comment About the post'),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     // ignore: deprecated_member_use
              //     FlatButton(
              //         onPressed: () async {
              //           if(formkey.currentState!.validate()){
              //           if (selectedfile != null) {
              //             UploadTask uploadTask = storageRef
              //                 .child("${selectedfile}")
              //                 .putFile(selectedfile!);
              //             TaskSnapshot storageSnap =
              //                 await uploadTask.whenComplete(() => null);
              //             String downloadUrl =
              //                 await storageSnap.ref.getDownloadURL();
              //             if (downloadUrl != null) {
              //               comments.doc().set({
              //                 "userid": userprovider.userdata.userid,
              //                 "username": userprovider.userdata.firstname,
              //                 "profile": userprovider.userdata.profile,
              //                 "postid": postid,
              //                 "comment": comment.text.trim(),
              //                 "type": "image",
              //                 "image": downloadUrl,
              //                 "likes": 0,
              //                 "timestamp": DateTime.now()
              //               });
              //                notification.doc(postid).set({
              //                               "id":postid,
              //                               "username":userprovider.userdata.firstname,
              //                               "profile":userprovider.userdata.profile,
              //                               "userid":postby,
              //                               "message":"Commented On your post",
              //                               "by":userprovider.userdata.userid
              //                             });
              //             } else {
              //               showDialog(
              //                   context: context,
              //                   builder: (_) =>
              //                       LogoutOverlay(message: "Some Error Occur"));
              //             }
              //           } else {
              //             comments.doc().set({
              //               "userid": userprovider.userdata.userid,
              //               "username": userprovider.userdata.firstname,
              //               "profile": userprovider.userdata.profile,
              //               "postid": postid,
              //               "comment": comment.text.trim(),
              //               "type": "text",
              //               "image": "null",
              //               "likes": 0,
              //               "timestamp": DateTime.now()
              //             }).then((value) {
              //                notification.doc(postid).set({
              //                               "id":postid,
              //                               "username":userprovider.userdata.firstname,
              //                               "profile":userprovider.userdata.profile,
              //                               "userid":postby,
              //                               "message":"Commented On your post",
              //                                "by":userprovider.userdata.userid
              //                             });
              //               comment.clear();
              //             }).onError((error, stackTrace) {
              //               showDialog(
              //                   context: context,
              //                   // ignore: unnecessary_brace_in_string_interps
              //                   builder: (_) =>
              //                       // ignore: unnecessary_brace_in_string_interps
              //                       LogoutOverlay(message: "${error}"));
              //             });
              //           }
              //           }
              //         },
              //         child: Text(
              //           'Send',
              //           style: TextStyle(color: Colors.indigo),
              //         ))
              //   ],
              // ),
              //   ],
              // ),
              //     ),
              //   ),
              // ) ,

              ),
        );
      });
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
                leading: new Icon(
                  Icons.edit,
                  color: Colors.indigo,
                ),
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
                leading: new Icon(
                  Icons.delete,
                  color: Colors.indigo,
                ),
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
                    "reportedby": userid,
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

void deletecomment(BuildContext context, String commentid) {
  comments.doc(commentid).delete().onError((error, stackTrace) {
    showDialog(
        context: context,
        // ignore: unnecessary_brace_in_string_interps
        builder: (_) => LogoutOverlay(message: "${error}"));
  });
}
