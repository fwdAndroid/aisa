import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postimage;
  final String title;
  final String description;
  final String category;
  final String userid;
  final String profile;
  final String firstname;
  final String postid;
  final String location;
  final int likes;
  final String type;
  final Timestamp timestamp;
  final String useruni;
  final String posttype;
  final bool approved;
  PostModel(
      {required this.category,
      required this.firstname,
      required this.description,
      required this.postimage,
      required this.profile,
      required this.title,
      required this.type,
      required this.location,
      required this.likes,
      required this.useruni,
      required this.postid,
      required this.posttype,
      required this.approved,
      required this.timestamp,
      required this.userid});
  factory PostModel.fromquerysnapshot(QuerySnapshot snapshot, int index) {
    Map<String, dynamic>? data =
        snapshot.docs[index].data() as Map<String, dynamic>?;
    return PostModel(
        category: data!["category"],
        firstname: data["username"],
        description: data["description"],
        postimage: data["postimage"],
        location: data["location"],
        profile: data["userimage"],
        title: data["title"],
        likes: data["likes"],
        type: data["type"],

        approved: data["approved"],
        posttype: data['posttype'],
        useruni: data['university'],
        timestamp: data["timestamp"],
        postid: data["postid"],
        userid: data["userid"]);
  }
   factory PostModel.fromdoc(DocumentSnapshot data) {
   
    return PostModel(
        category: data["category"],
        firstname: data["username"],
        description: data["description"],
        postimage: data["postimage"],
        location: data["location"],
        profile: data["userimage"],
        title: data["title"],
        likes: data["likes"],
        type: data["type"],

        approved: data["approved"],
        posttype: data['posttype'],
        useruni: data['university'],
        timestamp: data["timestamp"],
        postid: data["postid"],
        userid: data["userid"]);
  }


}
