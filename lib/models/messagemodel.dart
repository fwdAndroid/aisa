import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late String message;
  late String userid;
  late String name;
  late Timestamp timestamp;
  late String type;
  late String image;
  late String profile;
  MessageModel(
      {required this.message,
      required this.timestamp,
      required this.userid,
      required this.name,
      required this.image,
      required this.profile,
      required this.type});
  factory MessageModel.fromquerysnapshot(QuerySnapshot snapshot, int index) {
    Map<String, dynamic>? data =
        snapshot.docs[index].data() as Map<String, dynamic>?;
    return MessageModel(
        message: data!["sms"],
        timestamp: data["timestamp"],
        image: data["image"],
        type: data["type"],
        profile: data["profile"],
        name: data['name'],
        userid: data["userid"]);
  }
}
