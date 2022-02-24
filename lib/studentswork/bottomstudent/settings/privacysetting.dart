import 'package:aisa/Functions/functions.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/studentswork/bottomstudent/notific/socailnotification.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PrivacySetting extends StatefulWidget {
  bool profilevis;
  bool namevis;
  bool photovis;
  bool universityvis;
  bool citynamevis;
  PrivacySetting({
    required this.citynamevis,
    required this.photovis,
    required this.namevis,
    required this.universityvis,
    required this.profilevis,
  });
  @override
  _PrivacySettingState createState() => _PrivacySettingState(
        photovis: photovis,
        profilevis: profilevis,
        citynamevis: citynamevis,
        namevis: namevis,
        universityvis: universityvis,
      );
}

class _PrivacySettingState extends State<PrivacySetting> {
  bool profilevis;
  bool namevis;
  bool photovis;
  bool universityvis;
  bool citynamevis;
  _PrivacySettingState({
    required this.citynamevis,
    required this.photovis,
    required this.namevis,
    required this.universityvis,
    required this.profilevis,
  });
  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.namevis;
      photo = widget.photovis;
      profile = widget.profilevis;
      university = widget.universityvis;
      cityname = widget.citynamevis;
    });
  }

  bool state = false;
  late bool profile;
  late bool name;
  late bool photo;
  late bool university;
  late bool cityname;
  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Privacy Setting'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: state,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Privacy Settings',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SwitchListTile(
                value: profilevis,
                onChanged: (val) {
                  if (val == false) {
                    setState(() {
                      profile = false;
                      profilevis = false;
                    });
                  } else {
                    setState(() {
                      profile = true;
                      profilevis = true;
                    });
                  }
                },
                title: Text('Profile is visible for everyone'),
              ),
              SwitchListTile(
                value: namevis,
                onChanged: (val) {
                  if (val == false) {
                    setState(() {
                      name = false;
                      namevis = false;
                    });
                  } else {
                    setState(() {
                      name = true;
                      namevis = true;
                    });
                  }
                },
                title: Text('Name'),
              ),
              SwitchListTile(
                value: photovis,
                onChanged: (val) {
                  if (val == false) {
                    setState(() {
                      photo = false;
                      photovis = false;
                    });
                  } else {
                    setState(() {
                      photo = true;
                      photovis = true;
                    });
                  }
                },
                title: Text('Photo'),
              ),
              SwitchListTile(
                value: universityvis,
                onChanged: (val) {
                  if (val == false) {
                    setState(() {
                      university = false;
                      universityvis = false;
                    });
                  } else {
                    setState(() {
                      university = true;
                      universityvis = true;
                    });
                  }
                },
                title: Text('University Name'),
              ),
              SwitchListTile(
                value: citynamevis,
                onChanged: (val) {
                  if (val == false) {
                    setState(() {
                      cityname = false;
                      citynamevis = false;
                    });
                  } else {
                    setState(() {
                      cityname = true;
                      citynamevis = true;
                    });
                  }
                },
                title: Text('City Name'),
              ),
              // ignore: deprecated_member_use
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ignore: deprecated_member_use
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10)),
                    // ignore: deprecated_member_use
                    child: OutlineButton(
                      color: Colors.pink,
                      onPressed: () {
                        setState(() {
                          state = true;
                        });
                        var provider =
                            Provider.of<AuthFunction>(context, listen: false);
                        provider
                            .updateprofile(
                                context,
                                userprovider.userdata.profile,
                                userprovider.userdata.email,
                                userprovider.userdata.phonenumber,
                                userprovider.userdata.firstname,
                                userprovider.userdata.lastname,
                                userprovider.userdata.cityname,
                                userprovider.userdata.userid,
                                userprovider.userdata.university,
                                profile,
                                name,
                                photo,
                                university,
                                cityname)
                            .then((value) {
                          setState(() {
                            state = false;
                          });
                        });
                      },
                      child: Text(
                        'Saved',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
