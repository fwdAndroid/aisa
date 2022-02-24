
import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/groupsmodel.dart';
import 'package:aisa/models/savedpostsmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareSaveChat extends StatefulWidget {
   SavedPostModel posts;
 ShareSaveChat({ required this.posts});

  @override
  _ShareSaveChatState createState() => _ShareSaveChatState();
}

class _ShareSaveChatState extends State<ShareSaveChat> {
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Share'),
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
                  GroupsModel model =
                      GroupsModel.fromquersnapshot(userdata, index);

                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ChatScreen(
                      //               groupid: model.groupid,
                      //               groupname: model.groupname,
                      //               type:model.type
                      //             )));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: model.type=="group"?NetworkImage(model.image):NetworkImage(model.image.replaceAll("_", "").replaceAll(userprovider.userdata.profile, "")),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      trailing: TextButton(onPressed: (){
if(widget.posts.type=="image"){
  groups.doc(model.groupid).collection("messages").doc().set({
    "userid": userprovider.userdata.userid,
                    "sms": widget.posts.description,
                    "timestamp": DateTime.now(),
                    "type": "image",
                    "name": "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                    "image": widget.posts.postimage,
                    "profile": userprovider.userdata.profile
  }).then((value){
    showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "Post Shared"));
  }).onError((error, stackTrace){
    showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "${error}"));
  });
}else{
    groups.doc(model.groupid).collection("messages").doc().set({
    "userid": userprovider.userdata.userid,
                    "sms": widget.posts.description,
                    "timestamp": DateTime.now(),
                    "type": "text",
                    "name": "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                    "image":"null",
                    "profile": userprovider.userdata.profile
  }).then((value){
    showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "Post Shared"));
  }).onError((error, stackTrace){
    showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "${error}"));

});}

                      }, child: Text("Share")),
                      title:model.type=="group"? Text(model.groupname):Text(model.groupname.replaceAll("_","").replaceAll(userprovider.userdata.firstname, "")),
                      subtitle: Text(model.description),
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

class ShareInChat2 extends StatefulWidget {
   SavedPostModel posts;
  ShareInChat2({ required this.posts});

  @override
  _ShareInChat2State createState() => _ShareInChat2State();
}

class _ShareInChat2State extends State<ShareInChat2> {
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Share'),
      
          
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
                  GroupsModel model =
                      GroupsModel.fromquersnapshot(userdata, index);

                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ChatScreen(
                      //               groupid: model.groupid,
                      //               groupname: model.groupname,
                      //               type:model.type
                      //             )));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: model.type=="group"?NetworkImage(model.image):NetworkImage(model.image.replaceAll("_", "").replaceAll(userprovider.userdata.profile, "")),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      trailing: TextButton(onPressed: (){
if(widget.posts.type=="image"){
  groups.doc(model.groupid).collection("messages").doc().set({
    "userid": userprovider.userdata.userid,
                    "sms": widget.posts.description,
                    "timestamp": DateTime.now(),
                    "type": "image",
                    "name": "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                    "image": widget.posts.postimage,
                    "profile": userprovider.userdata.profile
  }).then((value){
    showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "Post Shared"));
  }).onError((error, stackTrace){
    showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "${error}"));
  });
}else{
    groups.doc(model.groupid).collection("messages").doc().set({
    "userid": userprovider.userdata.userid,
                    "sms": widget.posts.description,
                    "timestamp": DateTime.now(),
                    "type": "text",
                    "name": "${userprovider.userdata.firstname} ${userprovider.userdata.lastname}",
                    "image":"null",
                    "profile": userprovider.userdata.profile
  }).then((value){
    showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "Post Shared"));
  }).onError((error, stackTrace){
    showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "${error}"));

});}

                      }, child: Text("Share")),
                      title:model.type=="group"? Text(model.groupname):Text(model.groupname.replaceAll("_","").replaceAll(userprovider.userdata.firstname, "")),
                      subtitle: Text(model.description),
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