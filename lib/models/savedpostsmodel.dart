import 'package:cloud_firestore/cloud_firestore.dart';

class SavedPostModel {
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
  final String university;
   final String type;
  final String savedby;
  final Timestamp timestamp;
  SavedPostModel(
      {required this.category,
      required this.firstname,
      required this.university,
      required this.description,
      required this.postimage,
      required this.profile,
      required this.savedby,
      required this.title,
      required this.location,
      required this.likes,
      required this.postid,
      required this.type,
      required this.timestamp,
      required this.userid});
  factory SavedPostModel.fromquerysnapshot(QuerySnapshot snapshot, int index) {
    Map<String, dynamic>? data =
        snapshot.docs[index].data() as Map<String, dynamic>?;
    return SavedPostModel(
        category: data!["category"],
        firstname: data["username"],
        description: data["description"],
        postimage: data["postimage"],
        location: data["location"],
        profile: data["userimage"],
        title: data["title"],
        likes: data["likes"],
        university: data["university"],
        savedby: data["savedby"],
        timestamp: data["timestamp"],
           type: data['type'],
        postid: data["postid"],
        userid: data["userid"], );
  }
}
