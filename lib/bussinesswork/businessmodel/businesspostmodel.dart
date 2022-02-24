import 'package:cloud_firestore/cloud_firestore.dart';

class BusinesspostModel{
  final String postimage;
  final String title;
  final String description;
  final String category;
  final String userid;
  final String businessphone;
  
  final String firstname;
  final String postid;
  final String location;
  final int likes;
  final String type;
  final Timestamp timestamp;
  final String price;

  final String posttype;
  final bool approved;
 BusinesspostModel(
      {required this.category,
      required this.firstname,
      required this.price,
      required this.businessphone,
      required this.description,
      required this.postimage,
   
      required this.title,
      required this.type,
      required this.location,
      required this.likes,
    
      required this.postid,
      required this.posttype,
      required this.approved,
      required this.timestamp,
      required this.userid});
  factory BusinesspostModel.fromquerysnapshot(QuerySnapshot snapshot, int index) {
    Map<String, dynamic>? data =
        snapshot.docs[index].data() as Map<String, dynamic>?;
    return BusinesspostModel(
        category: data!["category"],
        firstname: data["businessname"],
        description: data["description"],
        postimage: data["postimage"],
        location: data["location"],
      price: data["price"],
      businessphone: data["phone"],
        title: data["title"],
        likes: data["likes"],
        type: data["type"],

        approved: data["approved"],
        posttype: data['posttype'],
      
        timestamp: data["timestamp"],
        postid: data["postid"],
        userid: data["userid"]);
  }
}