import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserModel {
  final String userid;
  final String firstname;
  final String lastname;
  final String email;
  final String phonenumber;
  final String cityname;
  final String profile;
  final String university;
  final bool profilevis;
  final bool namevis;
  final bool photovis;
  final bool universityvis;
  final bool citynamevis;
  GetUserModel(
      {required this.userid,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.phonenumber,
      required this.cityname,
      required this.citynamevis,
      required this.photovis,
      required this.namevis,
      required this.universityvis,
      required this.profilevis,
      required this.university,
      required this.profile});
  factory GetUserModel.fromquersnapshot(QuerySnapshot snapshot, int index) {
    Map<String, dynamic>? snap =
        snapshot.docs[index].data() as Map<String, dynamic>?;
    return GetUserModel(
        userid: snap!['userid'],
        firstname: snap['firstname'],
        lastname: snap["lastname"],
        email: snap['email'],
        phonenumber: snap['phonenumber'],
        cityname: snap['cityname'],
        university: snap["university"],
        profilevis: snap["profilevis"],
        namevis: snap["namevis"],
        universityvis: snap["universityvis"],
        photovis: snap["photovis"],
        citynamevis: snap["citynamevis"],
        profile: snap['profile']);
  }
}
