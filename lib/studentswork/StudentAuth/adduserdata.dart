import 'dart:io';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Functions/functions.dart';
import 'package:aisa/UniversityRequest/universityrequest.dart';
import 'package:aisa/models/australianlocationlist.dart';
import 'package:aisa/models/universitymodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUserData extends StatefulWidget {
  @override
  _AddUserDataState createState() => _AddUserDataState();
}

class _AddUserDataState extends State<AddUserData> {
  final formkey = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  late String email;
  late String password;
  final auth = FirebaseAuth.instance;
  User? user;
  bool select=false;
  TextEditingController cityname = TextEditingController();
  TextEditingController phonenumber = TextEditingController(text: "+61");
  String university = "Australian Catholic University";
  // add universities
  File? selectedfile;
  bool currentstate = false;
  late String location = "Melbourne";
   late List<DropdownMenuItem<AustralianCities>> _dropdownMenuItems1;
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
    late AustralianCities _selectedItem2;
  late List<DropdownMenuItem<UniversityNameList>> _dropdownMenuItems;
  late UniversityNameList _selectedItem;
  List<UniversityNameList> _dropdownlist = [
    UniversityNameList(1, "Carnegie Mellon Universit","Adelaide"),
    UniversityNameList(2, "Bond University","Gold Coast–Tweed Heads"),
    UniversityNameList(3, "Australian Catholic University","Sydney"),
    UniversityNameList(4, "Australian Catholic University","Brisbane"),
    UniversityNameList(5, "Australian Catholic University","Canberra"),
    UniversityNameList(6, "Australian Catholic University","Ballarat"),
    UniversityNameList(7, "Australian Catholic University","Melbourne"),
     UniversityNameList(8, "Australian National University","Canberra"),
    UniversityNameList(9, "Central Queensland University","Rockhampton"),
    UniversityNameList(10, "Central Queensland University","Mackay"),
    UniversityNameList(11, "Central Queensland University","Brisbane"),
    UniversityNameList(12, "Central Queensland University","Sydney"),
    UniversityNameList(13, "Central Queensland University","Perth"),
    UniversityNameList(14, "Central Queensland University","Townsville"),
    UniversityNameList(15, "Central Queensland University","Melbourne"),
    UniversityNameList(16, "Central Queensland University","Adelaide"),
    UniversityNameList(17, "Central Queensland University","Bundaberg"),
    UniversityNameList(18, "Central Queensland University","Gladstone"),
      UniversityNameList(19, "Central Queensland University","Noosa"),
    
    UniversityNameList(20, "Charles Darwin University","Darwin"),
    UniversityNameList(21, "Charles Sturt University","Albury"),
     UniversityNameList(22, "Charles Sturt University","Bathurst"),
      UniversityNameList(23, "Charles Sturt University","Wagga Wagga"),
       UniversityNameList(24, "Charles Sturt University","Orange"),
        UniversityNameList(25, "Charles Sturt University","Port Macquarie"),
         UniversityNameList(26, "Charles Sturt University","Brisbane"),
          UniversityNameList(27, "Charles Sturt University","Sydney"),
           UniversityNameList(28, "Charles Sturt University","Melbourne"),
    UniversityNameList(29, "Curtin University","Perth"),
    UniversityNameList(30, "Deakin University","Melbourne"),
    UniversityNameList(31, "Deakin University","Geelong"),
    UniversityNameList(32, "Deakin University","Warrnambool"),
    UniversityNameList(33, "Edith Cowan University","Perth"),
    UniversityNameList(34, "Federation University Of Australia","Ballarat"),
    UniversityNameList(35, "Federation University Of Australia","Churchill"),
    UniversityNameList(36, "Federation University Of Australia","Berwick"),
    UniversityNameList(37, "Federation University Of Australia","Horsham"),
    UniversityNameList(38, "Flinders University","Adelaide"),
    UniversityNameList(39, "Griffith University","Brisbane"),
    UniversityNameList(40, "Griffith University","Gold Coast–Tweed Heads"),
    UniversityNameList(41, "Holmes Institute","Melbourne"),
      UniversityNameList(42, "Holmes Institute","Sydney"),
        UniversityNameList(43, "Holmes Institute","Brisbane"),
          UniversityNameList(44, "Holmes Institute","Gold Coast–Tweed Heads"),
            UniversityNameList(45, "Holmes Institute","Cairns"),
    UniversityNameList(46, "James Cook University","Cairns"),
    UniversityNameList(47, "James Cook University","Townsville"),
    UniversityNameList(48, "La Trobe University","Melbourne"),
    UniversityNameList(49, "La Trobe University","Bendigo"),
    UniversityNameList(50, "La Trobe University","Shepparton"),
    UniversityNameList(51, "La Trobe University","Wodongga"),
    UniversityNameList(52, "La Trobe University","Sydney"),
    UniversityNameList(53, "Macquarie University","Sydney"),
    UniversityNameList(54, "Monash University","Melbourne"),
    UniversityNameList(55, "Monash University","Selangor"),
    UniversityNameList(56, "Murdoch University","Perth"),
    UniversityNameList(57, "Queensland University of Technology","Brisbane"),
    UniversityNameList(58, "RMIT University","Melbourne"),
    UniversityNameList(59, "Southern Cross University","Coffs Harbour"),
    UniversityNameList(60, "Southern Cross University","Lismore"),
    UniversityNameList(61, "Southern Cross University","Tweed Heads"),
    UniversityNameList(62, "Southern Cross University","Gold Coast–Tweed Heads"),
    UniversityNameList(63, "Southern Cross University","Sydney"),
    UniversityNameList(64, "Southern Cross University","Melbourne"),
    UniversityNameList(65, "Swinburne University of Technology","Melbourne"),
    UniversityNameList(66, "Torrens University Australia","Adelaide"),
    UniversityNameList(67, "Torrens University Australia","Melbourne"),
    UniversityNameList(68, "Torrens University Australia","Sydney"),
    UniversityNameList(69, "Torrens University Australia","Brisbane"),
    UniversityNameList(70, "University of Adelaide","Adelaide"),
    UniversityNameList(71, "University of Canberra","Canberra"),
    UniversityNameList(72, "University of Divinity","Melbourne"),
    UniversityNameList(73, "University of Divinity","Adelaide"),
    UniversityNameList(74, "University of Divinity","Sydney"),
    UniversityNameList(75, "University of Melbourne","Melbourne"),
    UniversityNameList(76, "University of New England","Armidale"),
    UniversityNameList(77, "University of New England","Sydney"),
    UniversityNameList(78, "University of New South Wales","Canberra"),
    UniversityNameList(79, "University of New South Wales","Sydney"),
    UniversityNameList(80, "University of Newcastle","Newcastle"),
    UniversityNameList(81, "University of Newcastle","Post Macquarie"),
    UniversityNameList(82, "University of Newcastle","Sydney"),
    UniversityNameList(83, "University of Notre Dame Australia","Fremantle"),
    UniversityNameList(84, "University of Notre Dame Australia","Broome"),
    UniversityNameList(85, "University of Notre Dame Australia","Sydney"),
    UniversityNameList(86, "University of South Australia","Adelaide"),
    UniversityNameList(87, "University of Queensland","Brisbane"),
    

    UniversityNameList(88, "University of Southern Queensland","Ipswich"),
      UniversityNameList(89, "University of Southern Queensland","Springfield"),
        UniversityNameList(90, "University of Southern Queensland","Toowoomba"),
    UniversityNameList(91, "University of Sydney","Sydney"),
    UniversityNameList(92, "University of Tasmania","Hobart"),
     UniversityNameList(93, "University of Tasmania","Launceston"),
      UniversityNameList(94, "University of Tasmania","Burnie"),
       UniversityNameList(95, "University of Tasmania","Sydney"),
    UniversityNameList(96, "University of Technology Sydney","Sydney"),
    UniversityNameList(97, "University of the Sunshine Coast","Sunshine Coast"),
    UniversityNameList(39, "University of the Western Australia","Perth"),
    UniversityNameList(40, " University of Wollongong","Wollongong"),
      UniversityNameList(40, " University of Wollongong","Sydney"),
    UniversityNameList(41, " Victoria University","Melbourne"),
    UniversityNameList(41, " Victoria University","Sydney"),
  ];
  //  List<UniversityNameList> _dropdownItems = [
  //   UniversityNameList(1, "Carnegie Mellon Universit"),
  //   UniversityNameList(2, "Bond University"),
  //   UniversityNameList(3, "Australian Catholic University"),
  //   UniversityNameList(4, "Central Queensland University"),
  //   UniversityNameList(5, "Charles Darwin University"),
  //   UniversityNameList(6, "Charles Sturt University"),
  //   UniversityNameList(7, "Curtin University"),
  //   UniversityNameList(8, "Deakin University"),
  //   UniversityNameList(9, "Edith Cowan University"),
  //   UniversityNameList(10, "Federation University Of Australia"),
  //   UniversityNameList(11, "Flinders University"),
  //   UniversityNameList(12, "Griffith University"),
  //   UniversityNameList(13, "Holmes Institute"),
  //   UniversityNameList(14, "James Cook University"),
  //   UniversityNameList(15, "La Trobe University"),
  //   UniversityNameList(16, "Macquarie University"),
  //   UniversityNameList(17, "Monash University"),
  //   UniversityNameList(18, "Murdoch University"),
  //   UniversityNameList(19, "Queensland University of Technology"),
  //   UniversityNameList(20, "RMIT University"),
  //   UniversityNameList(21, "Southern Cross University"),
  //   UniversityNameList(22, "Swinburne University of Technology"),
  //   UniversityNameList(23, "Torrens University Australia"),
  //   UniversityNameList(24, "University of Adelaide"),
  //   UniversityNameList(25, "University of Canberra"),
  //   UniversityNameList(26, "University of Divinity"),
  //   UniversityNameList(27, "University of Melbourne"),
  //   UniversityNameList(28, "University of New England"),
  //   UniversityNameList(29, "University of New South Wales"),
  //   UniversityNameList(30, "University of Newcastle"),
  //   UniversityNameList(31, "University of Notre Dame Australia"),
  //   UniversityNameList(32, "University of South Australia"),
  //   UniversityNameList(33, "University of Queensland"),
  //   UniversityNameList(34, "University of Southern Queensland"),
  //   UniversityNameList(35, "University of Sydney"),
  //   UniversityNameList(36, "University of Tasmania"),
  //   UniversityNameList(37, "University of Technology Sydney"),
  //   UniversityNameList(38, "University of the Sunshine Coast"),
  //   UniversityNameList(39, "University of the Western Australia"),
  //   UniversityNameList(40, " University of Wollongong"),
  //   UniversityNameList(41, " Victoria University"),
  // ];
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
  List<DropdownMenuItem<UniversityNameList>> buildDropDownMenuItems2(
      List listItems) {
    List<DropdownMenuItem<UniversityNameList>> items = [];
    for (UniversityNameList listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    getuseremail();
     _dropdownMenuItems1 = buildDropDownMenuItems1(_dropdownItemsloc);
    // _dropdownMenuItems = buildDropDownMenuItems2(_dropdownItems);
    // _selectedItem = _dropdownMenuItems[0].value!;
    _selectedItem2 = _dropdownMenuItems1[0].value!;
  }

  getuseremail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? useremail = sharedPreferences.getString("email");
    String? userpassword = sharedPreferences.getString("password");
    if (useremail != null && userpassword != null) {
      setState(() {
        email = useremail;
        password = userpassword;
      });
    } else {
      user = auth.currentUser;
      setState(() {
        email = user!.email!;
      });
    }
  }

  Widget _showtitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: GestureDetector(
          onTap: () {
            selectImage(context);
          },
          child: selectedfile == null
              ? Center(
                  child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/plus.png')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: currentstate,
        child: ListView(
          children: [
            Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  _showtitle(context),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Choose Profile Image ',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //First Name
                  Padding(
                    //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please Fill Firstname';
                        }
                      },
                      controller: firstname,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name',
                          hintText: 'Enter Your First Name'),
                    ),
                  ),

                  //Last Name
                  Padding(
                    //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please Fill Lastname';
                        }
                      },
                      controller: lastname,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last Name',
                          hintText: 'Enter Your Last Name'),
                    ),
                  ),

                  //Email

                  //Password

                  //City
                 
                  
                  
                     Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                       child: SizedBox(
                         height: 40,
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
                    
                
           StreamBuilder<QuerySnapshot>(  
    stream: FirebaseFirestore.instance.collection('university').where("city",isEqualTo: location).snapshots(), builder: (context, snapshot) {
      if (!snapshot.hasData)
        return Center(
          child: CupertinoActivityIndicator(),
        );
QuerySnapshot? data=snapshot.data;


  

      return data!.size==0?Text("Univeristy Not Found"):Container(
        padding: EdgeInsets.only(bottom: 16.0),
        child:
            
             DropdownButton(
               
                onChanged: (valueSelectedByUser) {
               setState(() {
                 university=valueSelectedByUser.toString();
                 select=true;
               });
                },
                hint:select==false?Text("Select University"): Text(university),
               
                items: data.docs
                    .map((DocumentSnapshot document) {
                  return DropdownMenuItem<String>(
                    value: 
                        document['university'] ,
                       
                    child: Text(document['university']),
                  );
                }).toList(),
              ),
          
     
      );
    }),
                  // Padding(
                  //   //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  //   padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  //   child: TextFormField(
                  //     validator: (value) {
                  //       if (value!.isNotEmpty) {
                  //         return null;
                  //       } else {
                  //         return 'Please Fill cityname';
                  //       }
                  //     },
                  //     controller: cityname,
                  //     decoration: InputDecoration(
                  //         border: OutlineInputBorder(),
                  //         labelText: 'City Name',
                  //         hintText: 'Select Your City'),
                  //   ),
                  // ),
                  // Padding(
                  //   //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  //   padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  //   child: SizedBox(
                  //     height: 40,
                  //     child: DropdownButton<UniversityNameList>(
                  //       value: _selectedItem,
                  //       items: _dropdownMenuItems,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           university = value!.name;
                  //           _selectedItem = value;
                  //         });
                  //       },
                  //     ),
                  //   ),
                    // child: TextFormField(
                    //   validator: (value) {
                    //     if (value!.isNotEmpty) {
                    //       return null;
                    //     } else {
                    //       return 'Please Add University Name';
                    //     }
                    //   },
                    //   controller: university,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       labelText: 'University',
                    //       hintText: 'Select Your University'),
                    // ),
                  // ),
                  //Phone
                  Padding(
                    //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isNotEmpty && value.contains("+61")) {
                          return null;
                        } else {
                          return 'add your austrailia number withcode';
                        }
                      },
                      controller: phonenumber,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Phone Numner',
                          hintText: 'Number Must Start With 61'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 15, bottom: 10, left: 15, right: 15),
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(20)),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                      
                        if (formkey.currentState!.validate()) {
                          if (selectedfile != null) {
                            setState(() {
                              currentstate = true;
                            });
                            var provider = Provider.of<AuthFunction>(context,
                                listen: false);

                            provider.saveuserdata(
                              context,
                              selectedfile!,
                              email,
                              phonenumber.text.trim(),
                              firstname.text.trim(),
                              lastname.text.trim(),
                              location,
                              university,
                            );
                          } else {
                            setState(() {
                              currentstate = true;
                            });
                            var provider = Provider.of<AuthFunction>(context,
                                listen: false);

                            provider
                                .saveuserdata2(
                              context,
                              email,
                              phonenumber.text.trim(),
                              firstname.text.trim(),
                              lastname.text.trim(),
                              location,
                              university,
                            )
                                .then((value) {
                              setState(() {
                                currentstate = false;
                              });
                            });
                          }
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      child: Text("University Request"),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UniversityRequest()));
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
