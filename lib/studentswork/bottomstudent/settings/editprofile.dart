import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Functions/functions.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/australianlocationlist.dart';
import 'package:aisa/models/australianuniversites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  String cityname;
  String university;
  EditProfile({required this.university, required this.cityname});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late AustralianCities _selectedItem2;
  late AustralianUniversities selectedItem3;
  late String location = "Melbourne";
  late List<DropdownMenuItem<AustralianCities>> _dropdownMenuItems1;
  String university = "Australian Catholic University";
  bool select = false;

  List<AustralianCities> _dropdownItemsloc = [
    AustralianCities(1, "Melbourne"),
    AustralianCities(2, "Sydney"),
    AustralianCities(3, "Brisbane"),
    AustralianCities(4, "Perth"),
    AustralianCities(5, "Adelaide"),
    AustralianCities(6, "Gold Coast–Tweed Heads"),
    AustralianCities(7, "Newcastle"),
    AustralianCities(8, "Canberra "),
    AustralianCities(9, "Sunshine Coast"),
    AustralianCities(10, "Central Coast"),
    AustralianCities(11, "Wollongong"),
    AustralianCities(12, "Geelong"),
    AustralianCities(13, "Hobart"),
    AustralianCities(14, "Townsville"),
    AustralianCities(15, "Cairns"),
    AustralianCities(16, "Toowoomba"),
    AustralianCities(17, "Darwin"),
    AustralianCities(18, "Ballarat"),
    AustralianCities(19, "Bendigo"),
    AustralianCities(20, "Albury"),
  ];

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems1 = buildDropDownMenuItems1(_dropdownItemsloc);
    setState(() {
      location = widget.cityname;
      university = widget.university;
    });
    // _dropdownMenuItems = buildDropDownMenuItems2(_dropdownItems);
    // _selectedItem = _dropdownMenuItems[0].value!;

    _selectedItem2 = _dropdownMenuItems1
        .where((element) => element.value!.name == widget.cityname)
        .first
        .value!;
  }

  final formkey = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController cityname = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  File? selectedfile;
  bool currentstate = false;

  //iMAGE PICKERS
  Widget _showtitle(BuildContext context, String profile, String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: GestureDetector(
          onTap: () {
            selectImage(context);
          },
          child: selectedfile == null
              ? Center(
                  child: profile == ""
                      ? CircleAvatar(
                          child: Text(name[0]),
                        )
                      : Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(profile)),
                              shape: BoxShape.circle)),
                )
              : Center(
                  child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(selectedfile!)),
                          shape: BoxShape.circle)),
                )),
    );
  }
  // for Image widget

  void handleGallery() async {
    await Permission.photos.request();

    var permission = await Permission.photos.status;
    if (permission.isGranted) {
      // final picker = ImagePicker();
      final pickedfile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      File file = File(pickedfile!.path);
      setState(() {
        Navigator.pop(context);
        this.selectedfile = file;
      });
    } else {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () => Navigator.pop(context),
      );
      return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              title: Text("Permissons"),
              content: Text("Please grant the access permission."),
              actions: [
                okButton,
              ],
            ),
          );
        },
      );
    }

    // final picker = ImagePicker();
    // PickedFile pickedfile = await picker.getImage(source: ImageSource.gallery);
    // file = File(pickedfile.path);
  }

  void handleCamera() async {
    Navigator.pop(context);
    await Permission.photos.request();

    var permission = await Permission.photos.status;
    if (permission.isGranted) {
      // final picker = ImagePicker();
      final pickedfile =
          await ImagePicker().getImage(source: ImageSource.camera);
      var file = File(pickedfile!.path);
      // File file = await ImagePicker.platform
      //     .pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 970)
      //     .then((value) => null);
      setState(() {
        Navigator.pop(context);
        this.selectedfile = file;
      });
    } else {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () => Navigator.pop(context),
      );
      return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              title: Text("Permissons"),
              content: Text("Please grant the access permission."),
              actions: [
                okButton,
              ],
            ),
          );
        },
      );
    }
  }

  selectImage(parentcontext) {
    return showDialog(
        context: parentcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text("create post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Select From Gallery"),
                onPressed: () => handleGallery(),
              ),
              SimpleDialogOption(
                child: Text("Select From Camera"),
                onPressed: () => handleCamera(),
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: currentstate,
          child: ListView(
            children: [
              Form(
                key: formkey,
                child: Column(
                  children: [
                    _showtitle(context, userprovider.userdata.profile,
                        userprovider.userdata.firstname),
                    Text(
                      'Chose Profile Image ',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //First Name
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: TextFormField(
                        controller: firstname,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: userprovider.userdata.firstname,
                            hintText: 'Update Your First Name'),
                      ),
                    ),
                    //Last Name
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: TextFormField(
                        controller: lastname,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: userprovider.userdata.lastname,
                            hintText: 'Update Your Last Name'),
                      ),
                    ),
                    //Email

                    //City
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        'Select City',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.pink,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: DropdownButton<AustralianCities>(
                              value: _selectedItem2,
                              items: _dropdownMenuItems1,
                              onChanged: (value) {
                                setState(() {
                                  location = value!.name;
                                  _selectedItem2 = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        'Select University',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    //University
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.pink,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('university')
                                .where("city", isEqualTo: location)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              QuerySnapshot? data = snapshot.data;

                              return data!.size == 0
                                  ? Text("Univeristy Not Found")
                                  : Container(
                                      padding: EdgeInsets.only(bottom: 16.0),
                                      child: DropdownButton(
                                        onChanged: (valueSelectedByUser) {
                                          setState(() {
                                            university =
                                                valueSelectedByUser.toString();
                                            select = true;
                                          });
                                        },
                                        hint: select == false
                                            ? Text(university)
                                            : Text(university),
                                        items: data.docs
                                            .map((DocumentSnapshot document) {
                                          return DropdownMenuItem<String>(
                                            value: document['university'],
                                            child: Text(document['university']),
                                          );
                                        }).toList(),
                                      ),
                                    );
                            }),
                      ),
                    ),
                    // Padding(
                    //   //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                    //   padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                    //   child: TextFormField(
                    //     controller: university,
                    //     decoration: InputDecoration(
                    //         border: OutlineInputBorder(),
                    //         labelText: userprovider.userdata.university,
                    //         hintText: 'Update  Your University'),
                    //   ),
                    // ),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(10)),
                        // ignore: deprecated_member_use
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            var provider = Provider.of<AuthFunction>(context,
                                listen: false);
                            if (selectedfile != null) {
                              setState(() {
                                currentstate = true;
                              });
                              provider
                                  .updatephoto(
                                      context,
                                      selectedfile!,
                                      userprovider.userdata.userid,
                                      userprovider.userdata.profile)
                                  .then((value) {
                                if (provider.error != true &&
                                    // ignore: unnecessary_null_comparison
                                    provider.profileurl != null) {
                                  provider
                                      .updateprofile(
                                          context,
                                          provider.profileurl,
                                          userprovider.userdata.email,
                                          phonenumber.text != ""
                                              ? phonenumber.text.trim()
                                              : userprovider
                                                  .userdata.phonenumber,
                                          firstname.text != ""
                                              ? firstname.text.trim()
                                              : userprovider.userdata.firstname,
                                          lastname.text != ""
                                              ? lastname.text.trim()
                                              : userprovider.userdata.lastname,
                                          cityname.text != ""
                                              ? cityname.text.trim()
                                              : userprovider.userdata.cityname,
                                          userprovider.userdata.userid,
                                          university !=
                                                  userprovider
                                                      .userdata.university
                                              ? location
                                              : userprovider
                                                  .userdata.university,
                                          userprovider.userdata.profilevis,
                                          userprovider.userdata.namevis,
                                          userprovider.userdata.photovis,
                                          userprovider.userdata.universityvis,
                                          userprovider.userdata.citynamevis)
                                      .then((value) {
                                    setState(() {
                                      currentstate = false;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    currentstate = false;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (_) => LogoutOverlay(
                                          message: "Profile is not Updated"));
                                }
                              });
                            } else {
                              provider
                                  .updateprofile(
                                      context,
                                      userprovider.userdata.profile,
                                      userprovider.userdata.email,
                                      phonenumber.text != ""
                                          ? phonenumber.text.trim()
                                          : userprovider.userdata.phonenumber,
                                      firstname.text != ""
                                          ? firstname.text.trim()
                                          : userprovider.userdata.firstname,
                                      lastname.text != ""
                                          ? lastname.text.trim()
                                          : userprovider.userdata.lastname,
                                      location != userprovider.userdata.cityname
                                          ? location
                                          : userprovider.userdata.cityname,
                                      userprovider.userdata.userid,
                                      university !=
                                              userprovider.userdata.university
                                          ? university
                                          : userprovider.userdata.university,
                                      userprovider.userdata.profilevis,
                                      userprovider.userdata.namevis,
                                      userprovider.userdata.photovis,
                                      userprovider.userdata.universityvis,
                                      userprovider.userdata.citynamevis)
                                  .then((value) {
                                currentstate = false;
                              });
                            }
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  List<DropdownMenuItem<AustralianCities>> buildDropDownMenuItems1(
      List listItems) {
    List<DropdownMenuItem<AustralianCities>> items = [];
    for (AustralianCities listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }
}
