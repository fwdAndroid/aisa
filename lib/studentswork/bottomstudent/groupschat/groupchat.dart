import 'dart:io';
import 'dart:math';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/Functions/chatfunctions.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/models/australianlocationlist.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class GroupChatCreate extends StatefulWidget {
  const GroupChatCreate({Key? key}) : super(key: key);

  @override
  _GroupChatCreateState createState() => _GroupChatCreateState();
}

class _GroupChatCreateState extends State<GroupChatCreate> {
  late List<DropdownMenuItem<AustralianCities>> _dropdownMenuItems1;

  late AustralianCities _selectedItem2;
  late String randomid;
  late String location = "Melbourne";
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  bool state = false;
  final formkey = GlobalKey<FormState>();

  List<AustralianCities> _dropdownItemsloc = [
    AustralianCities(1, "Melbourne"),
    AustralianCities(2, "Sydney"),
    AustralianCities(3, "Brisbane"),
    AustralianCities(4, "Perth"),
    AustralianCities(5, "Adelaide"),
    AustralianCities(6, "Gold Coast–Tweed Heads"),
    AustralianCities(7, "Newcastle–Maitland "),
    AustralianCities(8, "Canberra–Queanbeyan "),
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
    AustralianCities(20, "Albury–Wodonga"),
  ];
  File? selectedfile;

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

  Widget _showtitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
          onTap: () {
            selectImage(context);
          },
          child: selectedfile == null
              ? Center(
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/plus.png')),
                          shape: BoxShape.circle)),
                )
              : Center(
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(selectedfile!)),
                          shape: BoxShape.circle)),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: state,
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.all(10),
              child: ListView(
                children: [
                  Container(
                      width: 200,
                      height: 200,
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 20, bottom: 10),
                      child: _showtitle(context)),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Group',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please Add Group Name';
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Group Name',
                              hintText: 'Please Enter Your Group Name',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text(
                          'Group Description',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Please Add Group Description';
                            }
                          },
                          controller: description,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Group Description',
                            hintText: 'Please Enter Your Group Description',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Text(
                          'Select Location',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
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
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    height: 50,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Colors.pink,
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          if (selectedfile != null) {
                            setState(() {
                              state = true;
                            });
                            ChatFunction()
                                .creategroup(
                                    context,
                                    userprovider.userdata.userid,
                                    randomid,
                                    selectedfile!,
                                    name.text.trim(),
                                    description.text.trim(),
                                    location,
                                    "group")
                                .then((value) {
                              setState(() {
                                state = false;
                              });
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) => LogoutOverlay(
                                    message: "Please Add Group Picture"));
                          }
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Chat()),
                        // );
                      },
                      child: Text(
                        'Group Create',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    generateRandomString();
    _dropdownMenuItems1 = buildDropDownMenuItems2(_dropdownItemsloc);
    _selectedItem2 = _dropdownMenuItems1[0].value!;
  }

  List<DropdownMenuItem<AustralianCities>> buildDropDownMenuItems2(
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

  void generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    setState(() {
      randomid =
          List.generate(70, (index) => _chars[r.nextInt(_chars.length)]).join();
      print(randomid);
    });
  }
}
