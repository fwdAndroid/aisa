import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/commentmodel.dart';
import 'package:aisa/models/savedpostsmodel.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showbigpost.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comment.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comments2.dart';
import 'package:aisa/studentswork/bottomstudent/posts/sharepost.dart';
import 'package:aisa/studentswork/bottomstudent/posts/sharesavepost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class SavedPost extends StatefulWidget {
  const SavedPost({Key? key}) : super(key: key);

  @override
  _SavedPostState createState() => _SavedPostState();
}

class _SavedPostState extends State<SavedPost> {
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    var userid = userprovider.userdata.userid;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Saved Posts'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: saveMyposts
              .where("savedby", isEqualTo: userprovider.userdata.userid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot? data = snapshot.data;

              return ListView.builder(
                  itemCount: data!.docs.length,
                  itemBuilder: (context, index) {
                    SavedPostModel posts =
                        SavedPostModel.fromquerysnapshot(data, index);
                    Map<String, dynamic>? likesdata =
                        data.docs[index].data() as Map<String, dynamic>?;
                    String docid = data.docs[index].id;
                    // ignore: unused_local_variable
  DateTime date=posts.timestamp.toDate();
                    return Container(
                      margin: EdgeInsets.all(5),
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
                                  //Profile Image
                                  trailing: GestureDetector(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ShareSaveChat(posts: posts)));
                                    },
                                    child: Icon(Icons.share)),
                                  leading: posts.profile==""?Container(  height: 40,
                                    width: 40,
                                    color: Colors.indigo,
                                    child:CircleAvatar(child:Text(posts.firstname[0],style: TextStyle(color: Colors.white),))): Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                NetworkImage(posts.profile))),
                                  ),
                                 title:  
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        
                                        children: [
                       Text(posts.firstname,),
                                           Padding(
                                             padding: const EdgeInsets.only(left:10.0),
                                             child: Text(timeago.format(date),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color:Colors.black,)),
                                            
                                           ),
                                        ],
                                      ),
                                     
                                
                                                    subtitle: 
                                    
                                  
                                         
                                     
                                    Row(
                                      children: [
                                        Expanded(child: Text(posts.university,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,),)),
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child:  Text(posts.location,style: TextStyle(fontSize: 10),),
                                        )
                                      ],
                                    ),
                              ),
                               Padding(
                                 padding: const EdgeInsets.only(top:8.0,left: 15),
                                 child: Text(posts.title,style: TextStyle(fontWeight: FontWeight.bold),),
                               ),
                               Padding(
                                padding: const EdgeInsets.all(15.0),
                                child:  ReadMoreText(
                  posts.description,
                  trimLines: 2,
                  style: TextStyle(color: Colors.black),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: ' show less',
                ),),
                               
                                posts.type=="image"?GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>  ShowBigPost2 (
                                                     posts2: posts,
                                                     date: date,
                                                     likesdata: likesdata,)));
                                },
                                child: Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 250,
                                    child: Image.network(
                                      posts.postimage,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ):Text(""),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ignore: deprecated_member_use
                                    FlatButton.icon(
                                        onPressed: () {
                                          if (likesdata![userid] == userid &&
                                              likesdata["likes"] != 0) {
                                            saveMyposts
                                                .doc(posts.postid)
                                                .update({
                                              "postimage": posts.postimage,
                                              "title": posts.title,
                                              "description": posts.description,
                                              "category": posts.category,
                                              "location": posts.location,
                                              "userid": posts.userid,
                                              "userimage": posts.profile,
                                              "postid": docid,
                                              "timestamp": posts.timestamp,
                                              "username": posts.firstname,
                                              "likes": posts.likes - 1,
                                              userid: "null"
                                            });
                                          } else {
                                            saveMyposts
                                                .doc(posts.postid)
                                                .update({
                                              "postimage": posts.postimage,
                                              "title": posts.title,
                                              "description": posts.description,
                                              "category": posts.category,
                                              "location": posts.location,
                                              "userid": posts.userid,
                                              "userimage": posts.profile,
                                              "postid": docid,
                                              "timestamp": posts.timestamp,
                                              "username": posts.firstname,
                                              "likes": posts.likes + 1,
                                              userid: userid
                                            });
                                          }
                                        },
                                        icon: likesdata![userid] == userid
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(Icons.favorite_border),
                                        label: Text(
                                            likesdata["likes"].toString())),
                                    // ignore: deprecated_member_use
                                    FlatButton.icon(
                                      onPressed: () {
                                         _settingModalBottomSheet(context,posts.postid,posts.userid);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) => Comments2(
                                        //             postid: posts.postid)));
                                      },
                                      icon: Icon(
                                        Icons.message,
                                        color: Colors.indigo,
                                      ),
                                      label: Text('Comments'),
                                    ),
                                    // ignore: deprecated_member_use
                                    FlatButton.icon(
                                      onPressed: () {
                                        saveMyposts.doc(docid).delete();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.indigo,
                                      ),
                                      label: Text('Delete'),
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
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

void _settingModalBottomSheet(context,postid,postby){
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
     elevation:10,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc){
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
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot? commentdata = snapshot.data;
          
                        return SizedBox(
                  height:commentdata!.size==0?MediaQuery.of(context).size.height * 0.9: MediaQuery.of(context).size.height * 0.9,
                  child: commentdata.size==0?Center(child: Text("No Comments")): Padding(
                    padding: const EdgeInsets.only(top:28.0),
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
                                String commentid = commentdata.docs[index].id;
                                return usercomments.type == "text"
                                    ? Column(
                                        children: [
                                          ListTile(
                                            leading: usercomments.profile==""?Container(  
                                        child:CircleAvatar(child:Text(usercomments.firstname[0],style: TextStyle(color: Colors.white),))):Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          usercomments.profile))),
                                            ),
                                            trailing: usercomments.userid ==
                                                    userprovider.userdata.userid
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      deletecomment(
                                                          context, commentid);
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
                                                  Text(usercomments.likes
                                                      .toString()),
                                                  TextButton(
                                                      onPressed: () {
                                                        if (commentlike![
                                                                    userprovider
                                                                        .userdata
                                                                        .userid] ==
                                                                userprovider
                                                                    .userdata
                                                                    .userid &&
                                                            usercomments.likes !=
                                                                0) {
                                                          comments
                                                              .doc(commentid)
                                                              .update({
                                                            "likes":
                                                                usercomments.likes -
                                                                    1,
                                                            userprovider.userdata
                                                                .userid: "null"
                                                          });
                                                        } else {
                                                          comments
                                                              .doc(commentid)
                                                              .update({
                                                            "likes":
                                                                usercomments.likes +
                                                                    1,
                                                            userprovider.userdata
                                                                    .userid:
                                                                userprovider
                                                                    .userdata.userid
                                                          });
                                                        }
                                                      },
                                                      child: commentlike![
                                                                  userprovider
                                                                      .userdata
                                                                      .userid] ==
                                                              userprovider
                                                                  .userdata.userid
                                                          ? Text("Liked")
                                                          : Text("Like")),
                                                ],
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => Comments2(
                                                                postid:
                                                                    commentid,)));
                                                  },
                                                  child: Text("Reply"))
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
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          usercomments.profile))),
                                            ),
                                            trailing: usercomments.userid ==
                                                    userprovider.userdata.userid
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      deletecomment(
                                                          context, commentid);
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
                                              width: MediaQuery.of(context)
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
                                                  Text(usercomments.likes
                                                      .toString()),
                                                  TextButton(
                                                      onPressed: () {
                                                        if (commentlike![
                                                                    userprovider
                                                                        .userdata
                                                                        .userid] ==
                                                                userprovider
                                                                    .userdata
                                                                    .userid &&
                                                            usercomments.likes !=
                                                                0) {
                                                          comments
                                                              .doc(commentid)
                                                              .update({
                                                            "likes":
                                                                usercomments.likes -
                                                                    1,
                                                            userprovider.userdata
                                                                .userid: "null"
                                                          });
                                                        } else {
                                                          comments
                                                              .doc(commentid)
                                                              .update({
                                                            "likes":
                                                                usercomments.likes +
                                                                    1,
                                                            userprovider.userdata
                                                                    .userid:
                                                                userprovider
                                                                    .userdata.userid
                                                          });
                                                        }
                                                      },
                                                      child: commentlike![
                                                                  userprovider
                                                                      .userdata
                                                                      .userid] ==
                                                              userprovider
                                                                  .userdata.userid
                                                          ? Text("Liked")
                                                          : Text("Like")),
                                                ],
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => Comments2(
                                                             
                                                              // postby:postby,
                                                                postid:
                                                                    commentid)));
                                                  },
                                                  child: Text("Reply"))
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
                          if (value!.isNotEmpty&&filter.hasProfanity(value)==false) {
                            return null;
                          } else if(filter.hasProfanity(value)==true){
                            return "Vulgar Words are not allowed";
                          }
                          
                           else {
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
                          if(formkey.currentState!.validate()){
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
                                "username": userprovider.userdata.firstname,
                                "profile": userprovider.userdata.profile,
                                "postid": postid,
                                "comment": comment.text.trim(),
                                "type": "image",
                                "image": downloadUrl,
                                "likes": 0,
                                "timestamp": DateTime.now()
                              });
                               notification.doc(postid).set({
                                              "id":postid,
                                              "username":userprovider.userdata.firstname,
                                              "profile":userprovider.userdata.profile,
                                              "userid":postby,
                                              "message":"Commented On your post",
                                              "by":userprovider.userdata.userid
                                            });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      LogoutOverlay(message: "Some Error Occur"));
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
                                              "id":postid,
                                              "username":userprovider.userdata.firstname,
                                              "profile":userprovider.userdata.profile,
                                              "userid":postby,
                                              "message":"Commented On your post",
                                               "by":userprovider.userdata.userid
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
      ) ,

          );
      }
    );
}
void deletecomment(BuildContext context, String commentid) {
    comments.doc(commentid).delete().onError((error, stackTrace) {
      showDialog(
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(message: "${error}"));
    });
  }



