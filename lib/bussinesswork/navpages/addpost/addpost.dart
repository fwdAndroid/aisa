import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/bussinesswork/BusinessProvider/businessprovider.dart';
import 'package:aisa/bussinesswork/Businessaddpostfunction.dart/Businesspostfunction.dart';
import 'package:aisa/models/australianlocationlist.dart';
import 'package:aisa/models/categorylist.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController postTitle = TextEditingController();
  TextEditingController postDesc = TextEditingController();
  TextEditingController postPrice = TextEditingController();

  late String category = "News Feed";
  late String location = "Melbourne";
  final formkey = GlobalKey<FormState>();
  late List<DropdownMenuItem<CategoryListItem>> _dropdownMenuItems;
  late List<DropdownMenuItem<AustralianCities>> _dropdownMenuItems1;

  late CategoryListItem _selectedItem;
  late AustralianCities _selectedItem2;
  late String randomid;
  bool currentstate = false;
  generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    setState(() {
      randomid =
          List.generate(70, (index) => _chars[r.nextInt(_chars.length)]).join();
      print(randomid);
    });
  }

//Categories Selection
  List<CategoryListItem> _dropdownItems = [
    CategoryListItem(1, "News Feed"),
    CategoryListItem(2, "Accomodation"),
    CategoryListItem(3, "Jobs"),
    CategoryListItem(4, "Local Bussiness"),
    CategoryListItem(5, "Car Share"),
    CategoryListItem(5, "Local Communities"),
  ];

//Australian Location
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
                            fit: BoxFit.cover, image: FileImage(selectedfile!)),
                        shape: BoxShape.circle)),
              ),
      ),
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
    var userprovider = Provider.of<BusinessProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('AISA'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: currentstate,
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              //Enter Job Image
              Container(
                  width: 200,
                  height: 200,
                  margin:
                      EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
                  child: _showtitle(context)),
              SizedBox(
                height: 10,
              ),
              //Enter Job Title
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      'Job Title',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: postTitle,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please Add Job Title';
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: ' Job Title',
                            hintText: 'Enter  Job Title'),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Enter Job Description
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      'Job Description',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: postDesc,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please Fill Description';
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: ' Job Description',
                            hintText: 'Enter Job Description'),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: postPrice,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please Fill Description';
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: ' Job Price',
                            hintText: 'Enter Job Price'),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Select Post Category List
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      ' Job Post Category',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: DropdownButton<CategoryListItem>(
                        value: _selectedItem,
                        items: _dropdownMenuItems,
                        onChanged: (value) {
                          setState(() {
                            category = value!.name;
                            _selectedItem = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Select Post Location
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      'Select Location',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
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
              SizedBox(
                height: 6,
              ),
              //Upload Post
             Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 50,
              width:300,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.pink,
                  onPressed: () {
                    if (formkey.currentState!.validate() &&
                        selectedfile != null) {
                      if (selectedfile != null) {
                        setState(() {
                          currentstate = true;
                        });
                        BusinessPost().addpost( context,
                                selectedfile!,
                                postTitle.text.trim(),
                                postPrice.text.trim(),
                                postDesc.text.trim(),
                                category,
                                location,
                                userprovider.userdata.userid,
                                
                                userprovider.userdata.businessname,
                                randomid,
                                userprovider.userdata.phonenumber
                               ).then((value){
                                 setState(() {
                                   currentstate=false;
                                 });
                               });
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) =>
                                LogoutOverlay(message: "Add Picture First"));
                      }
                    }
                    // print(category);
                    // print(location);
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (_) => Post()));
                  },
                  child: Text(
                    'Upload',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<CategoryListItem>> buildDropDownMenuItems(
      List listItems) {
    List<DropdownMenuItem<CategoryListItem>> items = [];
    for (CategoryListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
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

  void initState() {
    super.initState();
    generateRandomString();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _dropdownMenuItems1 = buildDropDownMenuItems2(_dropdownItemsloc);
    _selectedItem = _dropdownMenuItems[0].value!;
    _selectedItem2 = _dropdownMenuItems1[0].value!;
  }
}
