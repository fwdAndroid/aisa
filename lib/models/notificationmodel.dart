import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  late String message;
  late String profile;
  late String name;
  late String by;
  late String id;
  late Timestamp timestamp;
  NotificationModel(
      {required this.profile,
      required this.message,
      required this.name,
      required this.by,
      required this.id,
      required this.timestamp});
  factory NotificationModel.fromquerysnapshot(
      QuerySnapshot snapshot, int index) {
    Map<String, dynamic>? data =
        snapshot.docs[index].data() as Map<String, dynamic>?;
    return NotificationModel(
        message: data!["message"],
        by: data["by"],
        timestamp: data["timestamp"],
        profile: data["profile"],
        id: data["id"],
        name: data['username']);
  }
}
