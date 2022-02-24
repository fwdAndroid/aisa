import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/groupsmodel.dart';
import 'package:aisa/studentswork/Search/searchgroup.dart';
import 'package:aisa/studentswork/bottomstudent/chats/chatscreen.dart';
import 'package:aisa/studentswork/bottomstudent/groupschat/groupchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    String id;
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchGroup()));
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupChatCreate()),
              );
            },
            icon: Icon(Icons.group_add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: groups
            .where("members", arrayContains: userprovider.userdata.userid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot? userdata = snapshot.data;
            return ListView.builder(
                itemCount: userdata!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic>? user2 =
                      userdata.docs[index].data() as Map<String, dynamic>;
                  GroupsModel model =
                      GroupsModel.fromquersnapshot(userdata, index);
                  String pic = model.image
                      .replaceAll(" ", "")
                      .replaceAll(userprovider.userdata.profile, "");
                  List<dynamic> id = model.userids;
                  id.removeWhere(
                      (element) => element == userprovider.userdata.userid);

                  return GestureDetector(
                    onLongPress: () {
                      if (model.type == "user") {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("Do You Want to Delete this Chat"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        groups
                                            .doc(model.groupid)
                                            .delete()
                                            .then((value) {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text("Delete"))
                                ],
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("Do You Want to Leave This Group"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        groups.doc(model.groupid).update(
                                            {"members": id}).then((value) {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text("Delete"))
                                ],
                              );
                            });
                      }
                    },
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    groupid: model.groupid,
                                    groupname: model.groupname,
                                    type: model.type,
                                    members: model.userids,
                                    myid: userprovider.userdata.userid,
                                  )));
                    },
                    child: ListTile(
                      leading: model.type == "group"
                          ? CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(model.image),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: userfirestore.doc(id[0]).snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return snapshot.data!["profile"] == ""
                                          ? Center(
                                              child: Text(
                                                  model.groupname
                                                      .replaceAll("_", "")
                                                      .replaceAll(
                                                          "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                                                          "")[0],
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(snapshot
                                                        .data!["profile"]),
                                                    fit: BoxFit.cover),
                                              ),
                                            );
                                    } else {
                                      return Center(
                                        child: Text(
                                            model.groupname
                                                .replaceAll("_", "")
                                                .replaceAll(
                                                    "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                                                    "")[0],
                                            style:
                                                TextStyle(color: Colors.white)),
                                      );
                                    }
                                  })),
                      title: model.type == "group"
                          ? Text(model.groupname)
                          : Text(model.groupname.replaceAll("_", "").replaceAll(
                              "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                              "")),
                      subtitle: model.type == "group"
                          ? Text(model.description)
                          : Row(
                              children: [
                                Expanded(
                                    child: Text(user2["${model.groupid}_uni"])),
                                // Expanded(
                                //     child:
                                //         Text(user2["${model.groupid}_city"])),
                              ],
                            ),
                    ),
                  );
                });
            // return Text("data");
          } else {
            return Text("");
          }
        },
      ),
      // body: ListView.builder(
      //   itemCount: chats.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     final Message chat = chats[index];
      //     return GestureDetector(
      //       onTap: () => Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (_) => ChatScreen(
      //             user: chat.sender,
      //           ),
      //         ),
      //       ),
      //       child: Container(
      //         padding: EdgeInsets.symmetric(
      //           horizontal: 20,
      //           vertical: 15,
      //         ),
      //         child: Row(
      //           children: <Widget>[
      //             Container(
      //               padding: EdgeInsets.all(2),
      //               decoration: chat.unread
      //                   ? BoxDecoration(
      //                       borderRadius: BorderRadius.all(Radius.circular(40)),
      //                       border: Border.all(
      //                         width: 2,
      //                         color: Theme.of(context).primaryColor,
      //                       ),
      //                       // shape: BoxShape.circle,
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color: Colors.grey.withOpacity(0.5),
      //                           spreadRadius: 2,
      //                           blurRadius: 5,
      //                         ),
      //                       ],
      //                     )
      //                   : BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color: Colors.grey.withOpacity(0.5),
      //                           spreadRadius: 2,
      //                           blurRadius: 5,
      //                         ),
      //                       ],
      //                     ),
      //               child: CircleAvatar(
      //                 radius: 35,
      //                 backgroundImage: AssetImage(chat.sender.imageUrl),
      //               ),
      //             ),
      //             Container(
      //               width: MediaQuery.of(context).size.width * 0.65,
      //               padding: EdgeInsets.only(
      //                 left: 20,
      //               ),
      //               child: Column(
      //                 children: <Widget>[
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: <Widget>[
      //                       Row(
      //                         children: <Widget>[
      //                           Text(
      //                             chat.sender.name,
      //                             style: TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.bold,
      //                             ),
      //                           ),
      //                           chat.sender.isOnline
      //                               ? Container(
      //                                   margin: const EdgeInsets.only(left: 5),
      //                                   width: 7,
      //                                   height: 7,
      //                                   decoration: BoxDecoration(
      //                                     shape: BoxShape.circle,
      //                                     color: Theme.of(context).primaryColor,
      //                                   ),
      //                                 )
      //                               : Container(
      //                                   child: null,
      //                                 ),
      //                         ],
      //                       ),
      //                       Text(
      //                         chat.time,
      //                         style: TextStyle(
      //                           fontSize: 11,
      //                           fontWeight: FontWeight.w300,
      //                           color: Colors.black54,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(
      //                     height: 10,
      //                   ),
      //                   Container(
      //                     alignment: Alignment.topLeft,
      //                     child: Text(
      //                       chat.text,
      //                       style: TextStyle(
      //                         fontSize: 13,
      //                         color: Colors.black54,
      //                       ),
      //                       overflow: TextOverflow.ellipsis,
      //                       maxLines: 2,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
