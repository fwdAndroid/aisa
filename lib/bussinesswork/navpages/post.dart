import 'package:aisa/bussinesswork/BusinessProvider/businessprovider.dart';
import 'package:aisa/bussinesswork/Notifaction/notifaction.dart';
import 'package:aisa/bussinesswork/businessmodel/businesspostmodel.dart';
import 'package:aisa/bussinesswork/navpages/addpost/addpost.dart';
import 'package:aisa/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  void initState() { 
    super.initState();
    
     getToken();
  }
  getToken() async {
   String utoken = (await FirebaseMessaging.instance.getToken())!;
   FirebaseAuth user=FirebaseAuth.instance;
   businessuser.doc(user.currentUser!.uid).update({
     "token":utoken
   });
    print(utoken);
  }
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<BusinessProvider>(context, listen: false);
    String userid = userprovider.userdata.userid;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
          title: Text('AISA'),
          actions: [
            
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notificationss()),
                );
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
        stream: userpost.where("userid",isEqualTo:userid).orderBy("timestamp", descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;
            return data!.size==0?Center(child: Text("No Posts"),): ListView.builder(
              itemCount:data.docs.length,
              itemBuilder: (context,index){
                BusinesspostModel businesspost=BusinesspostModel.fromquerysnapshot(data, index);
                 DateTime date=businesspost.timestamp.toDate();
return  Card(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              elevation: 10,
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
                      trailing: Column(
                        children: [
                             businesspost.approved==false? Text("Waiting For Approval",style: TextStyle(color: Colors.red),):Text("Posted",style: TextStyle(color: Colors.green),),
                          Text(timeago.format(date).toString()),
                        ],
                      ),
                      subtitle: Text(
                        businesspost.title,
                      ),
                    ),

                      Padding(
                                padding: const EdgeInsets.all(15.0),
                                child:  ReadMoreText(
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
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
            );
              });
          }else{
            return Center (child: CircularProgressIndicator(),);
          }
        
        }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          mini: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPost()),
            );

            // Respond to button press
          },
          child: Icon(Icons.add),
        ));
  }
}
