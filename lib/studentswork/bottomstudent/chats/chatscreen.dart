import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/Chatmodels/message.dart';
import 'package:aisa/models/messagemodel.dart';
import 'package:aisa/studentswork/bottomstudent/chats/BigPicture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  late String groupid;
  late String groupname;
  late String type;
  late String myid;
  late List<dynamic> members;
  ChatScreen(
      {required this.groupid,
      required this.groupname,
      required this.type,
      required this.members,
      required this.myid});

  @override
  _ChatScreenState createState() => _ChatScreenState(members: members);
}

class _ChatScreenState extends State<ChatScreen> {
  final formkey = GlobalKey<FormState>();
  final filter = ProfanityFilter();
  TextEditingController send = TextEditingController();
  late List<dynamic> members;

  _ChatScreenState({required this.members});
  File? selectedfile;
  bool state = false;
  bool vis = false;
  @override
  void initState() {
    super.initState();

    setState(() {
      members.removeWhere((element) => element == widget.myid);
    });
  }

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
        vis = true;
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
        vis = true;
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

  _sendMessageArea(
    BuildContext context,
    String userid,
    String username,
    String profile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              selectImage(context);
            },
          ),
          Expanded(
            child: TextFormField(
              controller: send,
              validator: (value) {
                if (value!.isNotEmpty && filter.hasProfanity(value) == false) {
                  return null;
                } else if (filter.hasProfanity(value) == true) {
                  return "Vulgar Words are not allowed";
                } else {
                  return 'Please Add Some Text';
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          InkWell(
            highlightColor: Colors.pink,
            child: IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                if (selectedfile != null) {
                  setState(() {
                    state = true;
                    vis = false;
                  });
                  UploadTask uploadTask = storageRef
                      .child("${selectedfile}")
                      .putFile(selectedfile!);
                  TaskSnapshot storageSnap =
                      await uploadTask.whenComplete(() => null);
                  String downloadUrl = await storageSnap.ref.getDownloadURL();
                  if (downloadUrl != null) {
                    groups
                        .doc(widget.groupid)
                        .collection("messages")
                        .doc()
                        .set({
                      "userid": userid,
                      "sms": send.text.trim(),
                      "timestamp": DateTime.now(),
                      "type": "image",
                      "name": username,
                      "grouptype": widget.type,
                      "image": downloadUrl,
                      "sendto": widget.type == "group" ? members : members[0],
                      "profile": profile,
                      "members": widget.members,
                      "groupid": widget.groupid,
                      "groupname":
                          widget.type == "group" ? widget.groupname : username,
                    }).then((value) {
                      send.clear();
                      setState(() {
                        state = false;
                        selectedfile = null;
                      });
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) =>
                            LogoutOverlay(message: "Some Error Occur"));
                  }
                } else {
                  if (formkey.currentState!.validate()) {
                    groups
                        .doc(widget.groupid)
                        .collection("messages")
                        .doc()
                        .set({
                      "userid": userid,
                      "sms": send.text.trim(),
                      "timestamp": DateTime.now(),
                      "type": "text",
                      "image": "null",
                      "grouptype": widget.type,
                      "sendto": widget.type == "group" ? members : members[0],
                      "name": username,
                      "profile": profile,
                      "members": widget.members,
                      "groupid": widget.groupid,
                      "groupname":
                          widget.type == "group" ? widget.groupname : username,
                    }).then((value) {
                      send.clear();
                      setState(() {
                        selectedfile = null;
                      });
                    });
                    send.clear();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    // ignore: unused_local_variable
    int prevUserId = 0;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: widget.type == "group"
            ? Text(widget.groupname)
            : Text(widget.groupname.replaceAll("_", "").replaceAll(
                "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                "")),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ModalProgressHUD(
        inAsyncCall: state,
        child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    // print("object");
                    // Fluttertoast.showToast(
                    //     msg: "nced",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.CENTER,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.red,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0);
                  },
                  child: StreamBuilder<QuerySnapshot>(
                    stream: groups
                        .doc(widget.groupid)
                        .collection("messages")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot? data = snapshot.data;

                        return ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.all(20),
                          itemCount: data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            MessageModel messageModel =
                                MessageModel.fromquerysnapshot(data, index);
                            DateTime date = messageModel.timestamp.toDate();
                            String docid = data.docs[index].id;
                            return messageModel.type == "image"
                                ? GestureDetector(
                                    onLongPress: () {
                                      if (messageModel.userid ==
                                          userprovider.userdata.userid) {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Do You Want to Delete this message"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancel")),
                                                  TextButton(
                                                      onPressed: () {
                                                        FirebaseStorage.instance
                        .refFromURL(messageModel.image).
                        delete();
                                                        groups
                                                            .doc(widget.groupid)
                                                            .collection(
                                                                "messages")
                                                            .doc(docid)
                                                            .update({
                                                          "sms": "",
                                                          "image":"null"

                                                        }).then((value) {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: Text("Delete"))
                                                ],
                                              );
                                            });
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: messageModel.userid ==
                                              userprovider.userdata.userid
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: messageModel.image == "null" &&
                                              messageModel.message == ""
                                          ? [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        messageModel.userid ==
                                                                userprovider
                                                                    .userdata
                                                                    .userid
                                                            ? Colors.grey[300]
                                                            : Colors.pink,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(12),
                                                      topRight:
                                                          Radius.circular(12),
                                                      bottomLeft: messageModel
                                                                  .userid ==
                                                              userprovider
                                                                  .userdata
                                                                  .userid
                                                          ? Radius.circular(0)
                                                          : Radius.circular(12),
                                                      bottomRight: messageModel
                                                                  .userid ==
                                                              userprovider
                                                                  .userdata
                                                                  .userid
                                                          ? Radius.circular(0)
                                                          : Radius.circular(12),
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 16,
                                                  ),
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 8,
                                                  ),
                                                  child: messageModel.userid ==
                                                          userprovider
                                                              .userdata.userid
                                                      ? Text(
                                                          "you deleted this message")
                                                      : Text(
                                                          "${messageModel.name} deleted this message"))
                                            ]
                                          : [
                                              messageModel.profile == ""
                                                  ? Container(
                                                      child: CircleAvatar(
                                                          child: Text(
                                                      messageModel.name[0],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )))
                                                  : Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    messageModel
                                                                        .profile,
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                    ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: messageModel.userid ==
                                                          userprovider
                                                              .userdata.userid
                                                      ? Colors.grey[300]
                                                      : Colors.pink,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    topRight:
                                                        Radius.circular(12),
                                                    bottomLeft: messageModel
                                                                .userid ==
                                                            userprovider
                                                                .userdata.userid
                                                        ? Radius.circular(0)
                                                        : Radius.circular(12),
                                                    bottomRight: messageModel
                                                                .userid ==
                                                            userprovider
                                                                .userdata.userid
                                                        ? Radius.circular(0)
                                                        : Radius.circular(12),
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 16,
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 4,
                                                  horizontal: 8,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    widget.type == "group"
                                                        ? Text(
                                                            messageModel.name,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ))
                                                        : Text(""),
                                                    Text(
                                                      messageModel.message,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Center(
                                                        child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      height: 250,
                                                      child: GestureDetector(
                                                        onTap:(){
                                                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                     BigPictureChat(link: messageModel.image)));
                                                        },
                                                        child: Image.network(
                                                          messageModel.image,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    )),
                                                    // Row(children: [
                                                    //   messageModel.profile==""?Container(

                                                    //     child:CircleAvatar(child:Text(messageModel.name[0],style: TextStyle(color: Colors.white),))):Container(
                                                    // width: 40,
                                                    // height: 40,
                                                    // decoration: BoxDecoration(
                                                    //     shape: BoxShape.circle,
                                                    //     image: DecorationImage(
                                                    //         image: NetworkImage(
                                                    //           messageModel.profile,
                                                    //         ),
                                                    //         fit: BoxFit.cover)),),
                                                    //         Padding(
                                                    //     padding: const EdgeInsets.only(
                                                    //         left: 8.0, bottom: 10),
                                                    //     child: Text(messageModel.name,
                                                    //         style: TextStyle(
                                                    //           fontSize: 18,
                                                    //           fontWeight: FontWeight.bold,
                                                    //         ))),
                                                    // ],),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Text(timeago
                                                            .format(date))),
                                                  ],
                                                ),
                                              ),
                                            ],
                                    ),
                                  )

                                // Row(
                                //   // mainAxisAlignment: messageModel.userid==userprovider.userdata.userid?MainAxisAlignment.end:MainAxisAlignment.start,
                                //   children: [
                                //     Column(
                                //         children: [
                                //           ListTile(
                                //             leading:messageModel.profile==""?Container(

                                //               child:CircleAvatar(child:Text(messageModel.name[0],style: TextStyle(color: Colors.white),))): Container(
                                //               width: 40,
                                //               height: 40,
                                //               decoration: BoxDecoration(
                                //                   shape: BoxShape.circle,
                                //                   image: DecorationImage(
                                //                       image: NetworkImage(
                                //                         messageModel.profile,
                                //                       ),
                                //                       fit: BoxFit.cover)),
                                //             ),
                                //             title:
                                //             // Row(
                                //             //   children: [
                                //                 Padding(
                                //                   padding: const EdgeInsets.only(
                                //                       left: 8.0, bottom: 10),
                                //                   child: Text(messageModel.name,
                                //                       style: TextStyle(
                                //                         fontSize: 18,
                                //                         fontWeight: FontWeight.bold,
                                //                       )),
                                //                 ),
                                //                 // Padding(
                                //                 //   padding: const EdgeInsets.only(
                                //                 //       left: 8.0, bottom: 10),
                                //                 //   child: Text(timeago.format(date)),
                                //                 // )
                                //             //   ],
                                //             // ),
                                //             subtitle: Text(
                                //               messageModel.message,
                                //               style: TextStyle(
                                //                   color: Colors.black,
                                //                   fontSize: 16,
                                //                   fontWeight: FontWeight.bold),
                                //             ),
                                //           ),
                                //           Center(
                                //             child: Container(
                                //               width:
                                //                   MediaQuery.of(context).size.width * 0.9,
                                //               height: 250,
                                //               child: Image.network(
                                //                 messageModel.image,
                                //                 fit: BoxFit.fill,
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //   ],
                                // )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onLongPress: () {
                                        if (messageModel.userid ==
                                            userprovider.userdata.userid) {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Do You Want to Delete this message"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel")),
                                                    TextButton(
                                                        onPressed: () {
                                                          groups
                                                              .doc(widget
                                                                  .groupid)
                                                              .collection(
                                                                  "messages")
                                                              .doc(docid)
                                                              .update({
                                                            "sms": ""
                                                          }).then((value) {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: Text("Delete"))
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            messageModel.userid ==
                                                    userprovider.userdata.userid
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: messageModel.image ==
                                                    "null" &&
                                                messageModel.message == ""
                                            ? [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          messageModel.userid ==
                                                                  userprovider
                                                                      .userdata
                                                                      .userid
                                                              ? Colors.grey[300]
                                                              : Colors.pink,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(12),
                                                        bottomLeft: messageModel
                                                                    .userid ==
                                                                userprovider
                                                                    .userdata
                                                                    .userid
                                                            ? Radius.circular(0)
                                                            : Radius.circular(
                                                                12),
                                                        bottomRight: messageModel
                                                                    .userid ==
                                                                userprovider
                                                                    .userdata
                                                                    .userid
                                                            ? Radius.circular(0)
                                                            : Radius.circular(
                                                                12),
                                                      ),
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16,
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8,
                                                    ),
                                                    child: messageModel
                                                                .userid ==
                                                            userprovider
                                                                .userdata.userid
                                                        ? Text(
                                                            "you deleted this message")
                                                        : Text(
                                                            "${messageModel.name} deleted this message"))
                                              ]
                                            : [
                                                messageModel.profile == ""
                                                    ? Container(
                                                        child: CircleAvatar(
                                                            child: Text(
                                                        messageModel.name[0],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )))
                                                    : Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                  messageModel
                                                                      .profile,
                                                                ),
                                                                fit: BoxFit.cover)),
                                                      ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        messageModel.userid ==
                                                                userprovider
                                                                    .userdata
                                                                    .userid
                                                            ? Colors.grey[300]
                                                            : Colors.pink,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(12),
                                                      topRight:
                                                          Radius.circular(12),
                                                      bottomLeft: messageModel
                                                                  .userid ==
                                                              userprovider
                                                                  .userdata
                                                                  .userid
                                                          ? Radius.circular(0)
                                                          : Radius.circular(12),
                                                      bottomRight: messageModel
                                                                  .userid ==
                                                              userprovider
                                                                  .userdata
                                                                  .userid
                                                          ? Radius.circular(0)
                                                          : Radius.circular(12),
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 16,
                                                  ),
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 8,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      widget.type == "group"
                                                          ? Text(
                                                              messageModel.name,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ))
                                                          : Text(""),
                                                      // Row(children: [
                                                      //   messageModel.profile==""?Container(

                                                      //     child:CircleAvatar(child:Text(messageModel.name[0],style: TextStyle(color: Colors.white),))):Container(
                                                      // width: 40,
                                                      // height: 40,
                                                      // decoration: BoxDecoration(
                                                      //     shape: BoxShape.circle,
                                                      //     image: DecorationImage(
                                                      //         image: NetworkImage(
                                                      //           messageModel.profile,
                                                      //         ),
                                                      //         fit: BoxFit.cover)),),
                                                      //         Padding(
                                                      //     padding: const EdgeInsets.only(
                                                      //         left: 8.0, bottom: 10),
                                                      //     child: Text(messageModel.name,
                                                      //         style: TextStyle(
                                                      //           fontSize: 18,
                                                      //           fontWeight: FontWeight.bold,
                                                      //         ))),
                                                      // ],),

                                                      Text(
                                                        messageModel.message,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                          timeago.format(date)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                      ),
                                    ),
                                  );
                            // : ListTile(
                            // leading: messageModel.profile==""?Container(

                            //       child:CircleAvatar(child:Text(messageModel.name[0],style: TextStyle(color: Colors.white),))):Container(
                            //   width: 40,
                            //   height: 40,
                            //   decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       image: DecorationImage(
                            //           image: NetworkImage(
                            //             messageModel.profile,
                            //           ),
                            //           fit: BoxFit.cover)),
                            //     ),
                            //     title:
                            //     //  Row(
                            //
                            //         ),//   children: [
                            //         Padding(
                            //           padding: const EdgeInsets.only(
                            //               left: 8.0, bottom: 10),
                            //           child: Text(messageModel.name,
                            //               style: TextStyle(
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.bold,
                            //               )),
                            //         // Padding(
                            //         //   padding: const EdgeInsets.only(
                            //         //       left: 8.0, bottom: 10),
                            //         //   child: Text(timeago.format(date)),
                            //         // )
                            //     //   ],
                            //     // ),
                            //     subtitle: Text(
                            //       messageModel.message,
                            //       style: TextStyle(
                            //           color: Colors.black,
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   );
                            //   Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Row(
                            //         children: [
                            //           Container(
                            //             width: 40,
                            //             height: 40,
                            //             decoration: BoxDecoration(
                            //                 shape: BoxShape.circle,
                            //                 image: DecorationImage(
                            //                     image: NetworkImage(
                            //                       messageModel.profile,
                            //                     ),
                            //                     fit: BoxFit.cover)),
                            //           ),
                            //           Padding(
                            //             padding: const EdgeInsets.only(
                            //                 left: 8.0, bottom: 10),
                            //             child: Text(messageModel.name,
                            //                 style: TextStyle(
                            //                   fontSize: 18,
                            //                   fontWeight: FontWeight.bold,
                            //                 )),
                            //           ),
                            //         ],
                            //       ),
                            //       Row(
                            //         children: [
                            //           Container(
                            //             margin: EdgeInsets.only(
                            //                 left: 20, right: 20, top: 10),
                            //             child: Card(
                            //               shape: RoundedRectangleBorder(
                            //                   borderRadius:
                            //                       BorderRadius.circular(10)),
                            //               color: Colors.indigo,
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Center(
                            //                   child: Padding(
                            //                     padding: const EdgeInsets.all(10),
                            //                     child: Text(
                            //                       messageModel.message,
                            //                       style: TextStyle(
                            //                           color: Colors.white,
                            //                           fontSize: 14),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            // );
                            //         : Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Row(
                            //                 children: [
                            //                   Container(
                            //                     width: 40,
                            //                     height: 40,
                            //                     decoration: BoxDecoration(
                            //                         shape: BoxShape.circle,
                            //                         image: DecorationImage(
                            //                             image: NetworkImage(
                            //                               messageModel.profile,
                            //                             ),
                            //                             fit: BoxFit.cover)),
                            //                   ),
                            //                   Padding(
                            //                     padding: const EdgeInsets.only(
                            //                         left: 8.0, bottom: 10),
                            //                     child: Text(messageModel.name,
                            //                         style: TextStyle(
                            //                           fontSize: 18,
                            //                           fontWeight: FontWeight.bold,
                            //                         )),
                            //                   ),
                            //                 ],
                            //               ),
                            //               Row(
                            //                 children: [
                            //                   SizedBox(
                            //                     width: 200,
                            //                     child: Container(
                            //                       margin: EdgeInsets.only(
                            //                           left: 20, right: 20, top: 10),
                            //                       child: Card(
                            //                         shape: RoundedRectangleBorder(
                            //                             borderRadius:
                            //                                 BorderRadius.circular(
                            //                                     10)),
                            //                         color: Colors.indigo,
                            //                         child: Padding(
                            //                           padding:
                            //                               const EdgeInsets.all(8.0),
                            //                           child: Center(
                            //                             child: Padding(
                            //                               padding:
                            //                                   const EdgeInsets.all(
                            //                                       10),
                            //                               child: Text(
                            //                                 messageModel.message,
                            //                                 style: TextStyle(
                            //                                     color: Colors.white,
                            //                                     fontSize: 14),
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           )
                            //   ],
                            // );
                            // final Message message = messages[index];
                            // final bool isMe = message.sender.id == currentUser.id;
                            // final bool isSameUser = prevUserId == message.sender.id;
                            // prevUserId = message.sender.id;
                            //   // return _chatBubble(message, isMe, isSameUser);
                          },
                        );
                      } else {
                        return Center(
                          child: Text("Add Message"),
                        );
                      }
                    },
                  ),
                ),
              ),
              Visibility(
                  visible: vis,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 160,
                      child: selectedfile != null
                          ? Stack(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 160,
                                    child: Image.file(
                                      selectedfile!,
                                      fit: BoxFit.cover,
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedfile = null;
                                        vis = false;
                                      });
                                    },
                                    child: Icon(Icons.cancel)),
                              ],
                            )
                          : Text(""))),
              _sendMessageArea(
                context,
                userprovider.userdata.userid,
                userprovider.userdata.firstname,
                userprovider.userdata.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
