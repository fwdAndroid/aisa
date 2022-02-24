import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userid;
  final String profile;
  final String firstname;
  final String postid;
  final String comment;
  final Timestamp timestamp;
  final int likes;
  final String image;
  final String type;
  CommentModel(
      {required this.firstname,
      required this.profile,
      required this.comment,
      required this.postid,
      required this.likes,
      required this.image,
      required this.type,
      required this.timestamp,
      required this.userid});
  factory CommentModel.fromquerysnapshot(QuerySnapshot snapshot, int index) {
    Map<String, dynamic>? data =
        snapshot.docs[index].data() as Map<String, dynamic>?;
    return CommentModel(
        firstname: data!["username"],
        profile: data["profile"],
        comment: data["comment"],
        timestamp: data["timestamp"],
        likes: data["likes"],
        type: data["type"],
        image: data["image"],
        postid: data["postid"],
        userid: data["userid"]);
  }
}
