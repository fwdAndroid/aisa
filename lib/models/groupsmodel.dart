import 'package:cloud_firestore/cloud_firestore.dart';

class GroupsModel {
  late String groupname;
  late String image;
  late String groupid;
  late String description;
  late String type;
  late List<dynamic> userids;
  GroupsModel(
      {required this.groupid,
      required this.groupname,
      required this.image,
      required this.type,
      required this.userids,
      required this.description});
  factory GroupsModel.fromquersnapshot(QuerySnapshot snapshot, int index) {
    Map<String, dynamic>? data =
        snapshot.docs[index].data() as Map<String, dynamic>?;
    return GroupsModel(
        groupid: data!["groupid"],
        image: data["image"],
        userids: data["members"],
        description: data["groupdescription"],
        type: data["type"],
        groupname: data["groupname"]);
  }
}
