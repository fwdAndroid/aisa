import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/bussinesswork/businessmodel/businesspostmodel.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/commentmodel.dart';
import 'package:aisa/models/postmodel.dart';
import 'package:aisa/studentswork/UserProfile/userprofile.dart';
import 'package:aisa/studentswork/bigpost/bigpost.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/post.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showbigpost.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showuserdata/showuserprofile.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comment.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comment3.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comments2.dart';
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

class SearchCity extends StatefulWidget {
  @override
  _SearchCityState createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  TextEditingController searchcontroller = TextEditingController();
  Stream<QuerySnapshot>? searchResults;
  handleSearch(String query) {
    Stream<QuerySnapshot> users = userpost
        .where('location',
            isGreaterThanOrEqualTo: query.substring(0).toUpperCase())
        .snapshots();
    setState(() {
      searchResults = users;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: TextFormField(
        decoration: InputDecoration(
            hintText: "search city posts.",
            filled: true,
            prefixIcon: Icon(
              Icons.search,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchcontroller.clear();
              },
            )),
        onFieldSubmitted: handleSearch,
        onChanged: handleSearch,
        controller: searchcontroller,
      ),
    );
  }

  Container buildnoContent() {
    return Container(
      child: Center(
        child: ListView(
          children: <Widget>[
            Text(
              "Find City",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 60.0),
            )
          ],
        ),
      ),
    );
  }

  buildSearchResults(String userid, cityname, String username,
      String userprofile, UserProvider userprovider) {
    return StreamBuilder<QuerySnapshot>(
        stream: searchResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          QuerySnapshot? data = snapshot.data;
          return ListView.builder(
              itemCount: data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic>? likesdata =
                    data.docs[index].data() as Map<String, dynamic>?;
                // String id = data.docs[index].id;
                // ignore: unused_local_variable

                return postsshow(likesdata, data, index, userid, cityname,
                    username, userprofile, userprovider);
              });
        });
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
              padding: const EdgeInsets.only(top: 10.0),
              child: Card(
                elevation: 10,
                shadowColor: Colors.white70,
                color: Colors.white60,
                child: SizedBox(
                  width: 100,
                  child: Column(
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
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                    Row(
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
                                  "notification": userid,
                                  userid: "null",
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
                                  userid: userid
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
                                    QuerySnapshot? commentdata = snapshot.data;
                                    return Text(
                                        commentdata!.docs.length.toString());
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
                                        ShareInChat(posts: posts)));
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    String userid = userprovider.userdata.userid;
    return Scaffold(
      appBar: buildSearchField(),
      body: searchResults == null
          ? buildnoContent()
          : buildSearchResults(
              userid,
              userprovider.userdata.cityname,
              userprovider.userdata.firstname,
              userprovider.userdata.profile,
              userprovider),
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
          body: Comments3(
            postby: postby,
            postid: postid,
          ),

// body: SingleChildScrollView(

//         child: Container(
//           margin: EdgeInsets.only(left: 10, right: 10),
//           child: Form(
//             key: formkey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                  StreamBuilder<QuerySnapshot>(
//                     stream: comments
//                         .where("postid", isEqualTo: postid)
//                         .snapshots(),
//                     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (snapshot.hasData) {
//                         QuerySnapshot? commentdata = snapshot.data;

//                         return SizedBox(
//                   height:commentdata!.size==0?MediaQuery.of(context).size.height * 0.9: MediaQuery.of(context).size.height * 0.9,
//                   child: commentdata.size==0?Center(child: Text("No Comments")): Padding(
//                     padding: const EdgeInsets.only(top:28.0),
//                     child: ListView.builder(

//                               shrinkWrap: true,
//                               itemCount: commentdata.docs.length,
//                               itemBuilder: (context, index) {
//                                 Map<String, dynamic>? commentlike =
//                                     commentdata.docs[index].data()
//                                         as Map<String, dynamic>?;

//                                 CommentModel usercomments =
//                                     CommentModel.fromquerysnapshot(
//                                         commentdata, index);
//                                 String commentid = commentdata.docs[index].id;
//                                 return usercomments.type == "text"
//                                     ? Column(
//                                         children: [
//                                           ListTile(
//                                             leading: usercomments.profile==""?Container(
//                                         child:CircleAvatar(child:Text(usercomments.firstname[0],style: TextStyle(color: Colors.white),))):Container(
//                                               height: 30,
//                                               width: 30,
//                                               decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   image: DecorationImage(
//                                                       fit: BoxFit.cover,
//                                                       image: NetworkImage(
//                                                           usercomments.profile))),
//                                             ),
//                                             trailing: usercomments.userid ==
//                                                     userprovider.userdata.userid
//                                                 ? IconButton(
//                                                     icon: Icon(
//                                                       Icons.delete,
//                                                       color: Colors.red,
//                                                     ),
//                                                     onPressed: () {
//                                                       deletecomment(
//                                                           context, commentid);
//                                                     },
//                                                   )
//                                                 : Text(""),
//                                             subtitle: Text(
//                                                 "${timeago.format(usercomments.timestamp.toDate())}"),
//                                             title: Text(
//                                                 "${usercomments.firstname} :   ${usercomments.comment}"),
//                                           ),
//                                           Row(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(usercomments.likes
//                                                       .toString()),
//                                                   TextButton(
//                                                       onPressed: () {
//                                                         if (commentlike![
//                                                                     userprovider
//                                                                         .userdata
//                                                                         .userid] ==
//                                                                 userprovider
//                                                                     .userdata
//                                                                     .userid &&
//                                                             usercomments.likes !=
//                                                                 0) {
//                                                           comments
//                                                               .doc(commentid)
//                                                               .update({
//                                                             "likes":
//                                                                 usercomments.likes -
//                                                                     1,
//                                                             userprovider.userdata
//                                                                 .userid: "null"
//                                                           });
//                                                         } else {
//                                                           comments
//                                                               .doc(commentid)
//                                                               .update({
//                                                             "likes":
//                                                                 usercomments.likes +
//                                                                     1,
//                                                             userprovider.userdata
//                                                                     .userid:
//                                                                 userprovider
//                                                                     .userdata.userid
//                                                           });
//                                                         }
//                                                       },
//                                                       child: commentlike![
//                                                                   userprovider
//                                                                       .userdata
//                                                                       .userid] ==
//                                                               userprovider
//                                                                   .userdata.userid
//                                                           ? Text("Liked")
//                                                           : Text("Like")),
//                                                 ],
//                                               ),
//                                               TextButton(
//                                                   onPressed: () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (_) => Comments2(
//                                                                 postid:
//                                                                     commentid,)));
//                                                   },
//                                                   child: Text("Reply"))
//                                             ],
//                                           )
//                                         ],
//                                       )
//                                     : Column(
//                                         children: [
//                                           ListTile(
//                                             leading: Container(
//                                               height: 30,
//                                               width: 30,
//                                               decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   image: DecorationImage(
//                                                       fit: BoxFit.cover,
//                                                       image: NetworkImage(
//                                                           usercomments.profile))),
//                                             ),
//                                             trailing: usercomments.userid ==
//                                                     userprovider.userdata.userid
//                                                 ? IconButton(
//                                                     icon: Icon(
//                                                       Icons.delete,
//                                                       color: Colors.red,
//                                                     ),
//                                                     onPressed: () {
//                                                       deletecomment(
//                                                           context, commentid);
//                                                     },
//                                                   )
//                                                 : Text(""),
//                                             subtitle: Text(
//                                                 "${timeago.format(usercomments.timestamp.toDate())}"),
//                                             title: Text(
//                                                 "${usercomments.firstname} :   ${usercomments.comment}"),
//                                           ),
//                                           Center(
//                                             child: Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.9,
//                                               height: 250,
//                                               child: Image.network(
//                                                 usercomments.image,
//                                                 fit: BoxFit.fill,
//                                               ),
//                                             ),
//                                           ),
//                                           Row(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(usercomments.likes
//                                                       .toString()),
//                                                   TextButton(
//                                                       onPressed: () {
//                                                         if (commentlike![
//                                                                     userprovider
//                                                                         .userdata
//                                                                         .userid] ==
//                                                                 userprovider
//                                                                     .userdata
//                                                                     .userid &&
//                                                             usercomments.likes !=
//                                                                 0) {
//                                                           comments
//                                                               .doc(commentid)
//                                                               .update({
//                                                             "likes":
//                                                                 usercomments.likes -
//                                                                     1,
//                                                             userprovider.userdata
//                                                                 .userid: "null"
//                                                           });
//                                                         } else {
//                                                           comments
//                                                               .doc(commentid)
//                                                               .update({
//                                                             "likes":
//                                                                 usercomments.likes +
//                                                                     1,
//                                                             userprovider.userdata
//                                                                     .userid:
//                                                                 userprovider
//                                                                     .userdata.userid
//                                                           });
//                                                         }
//                                                       },
//                                                       child: commentlike![
//                                                                   userprovider
//                                                                       .userdata
//                                                                       .userid] ==
//                                                               userprovider
//                                                                   .userdata.userid
//                                                           ? Text("Liked")
//                                                           : Text("Like")),
//                                                 ],
//                                               ),
//                                               TextButton(
//                                                   onPressed: () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (_) => Comments2(

//                                                               // postby:postby,
//                                                                 postid:
//                                                                     commentid)));
//                                                   },
//                                                   child: Text("Reply"))
//                                             ],
//                                           )
//                                         ],
//                                       );
//                               }),
//                   ));
//                       } else {
//                         return Center(child: Text("no data"));
//                       }
//                     },
//                   ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.photo),
//                       iconSize: 25,
//                       color: Theme.of(context).primaryColor,
//                       onPressed: () {
//                         selectImage(context);
//                       },
//                     ),
//                     Flexible(
//                       child: TextFormField(
//                         controller: comment,
//                         validator: (value) {
//                           if (value!.isNotEmpty&&filter.hasProfanity(value)==false) {
//                             return null;
//                           } else if(filter.hasProfanity(value)==true){
//                             return "Vulgar Words are not allowed";
//                           }

//                            else {
//                             return 'Please Add Post Title';
//                           }
//                         },
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: ' Comment',
//                             hintText: 'Write Your  Comment About the post'),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     // ignore: deprecated_member_use
//                     FlatButton(
//                         onPressed: () async {
//                           if(formkey.currentState!.validate()){
//                           if (selectedfile != null) {
//                             UploadTask uploadTask = storageRef
//                                 .child("${selectedfile}")
//                                 .putFile(selectedfile!);
//                             TaskSnapshot storageSnap =
//                                 await uploadTask.whenComplete(() => null);
//                             String downloadUrl =
//                                 await storageSnap.ref.getDownloadURL();
//                             if (downloadUrl != null) {
//                               comments.doc().set({
//                                 "userid": userprovider.userdata.userid,
//                                 "username": userprovider.userdata.firstname,
//                                 "profile": userprovider.userdata.profile,
//                                 "postid": postid,
//                                 "comment": comment.text.trim(),
//                                 "type": "image",
//                                 "image": downloadUrl,
//                                 "likes": 0,
//                                 "timestamp": DateTime.now()
//                               });
//                                notification.doc(postid).set({
//                                               "id":postid,
//                                               "username":userprovider.userdata.firstname,
//                                               "profile":userprovider.userdata.profile,
//                                               "userid":postby,
//                                               "message":"Commented On your post",
//                                               "by":userprovider.userdata.userid
//                                             });
//                             } else {
//                               showDialog(
//                                   context: context,
//                                   builder: (_) =>
//                                       LogoutOverlay(message: "Some Error Occur"));
//                             }
//                           } else {
//                             comments.doc().set({
//                               "userid": userprovider.userdata.userid,
//                               "username": userprovider.userdata.firstname,
//                               "profile": userprovider.userdata.profile,
//                               "postid": postid,
//                               "comment": comment.text.trim(),
//                               "type": "text",
//                               "image": "null",
//                               "likes": 0,
//                               "timestamp": DateTime.now()
//                             }).then((value) {
//                                notification.doc(postid).set({
//                                               "id":postid,
//                                               "username":userprovider.userdata.firstname,
//                                               "profile":userprovider.userdata.profile,
//                                               "userid":postby,
//                                               "message":"Commented On your post",
//                                                "by":userprovider.userdata.userid
//                                             });
//                               comment.clear();
//                             }).onError((error, stackTrace) {
//                               showDialog(
//                                   context: context,
//                                   // ignore: unnecessary_brace_in_string_interps
//                                   builder: (_) =>
//                                       // ignore: unnecessary_brace_in_string_interps
//                                       LogoutOverlay(message: "${error}"));
//                             });
//                           }
//                           }
//                         },
//                         child: Text(
//                           'Send',
//                           style: TextStyle(color: Colors.indigo),
//                         ))
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ) ,
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
                  'ReportPost',
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

void deletecomment(BuildContext context, String commentid) {
  comments.doc(commentid).delete().onError((error, stackTrace) {
    showDialog(
        context: context,
        // ignore: unnecessary_brace_in_string_interps
        builder: (_) => LogoutOverlay(message: "${error}"));
  });
}
