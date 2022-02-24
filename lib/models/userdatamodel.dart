import 'package:cloud_firestore/cloud_firestore.dart';


class Users {
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
  final bool block;


  Users(
      {required this.userid,
      required this.firstname,
      required this.block,
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
  factory Users.fromDocument(DocumentSnapshot snapshot) {
    return Users(
        userid: snapshot['userid'],
        firstname: snapshot['firstname'],
        lastname: snapshot["lastname"],
        email: snapshot['email'],
        phonenumber: snapshot['phonenumber'],
        cityname: snapshot['cityname'],
        block: snapshot["block"],
        university: snapshot["university"],
        profilevis: snapshot["profilevis"],
        namevis: snapshot["namevis"],
        universityvis: snapshot["universityvis"],
        photovis: snapshot["photovis"],
        citynamevis: snapshot["citynamevis"],
        
        profile: snapshot['profile']);
  }
}
