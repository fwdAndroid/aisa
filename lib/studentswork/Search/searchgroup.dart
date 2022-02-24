import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/main.dart';
import 'package:aisa/models/groupsmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchGroup extends StatefulWidget {
  SearchGroup({Key? key}) : super(key: key);

  @override
  _SearchGroupState createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  TextEditingController searchcontroller = TextEditingController();
  Stream<QuerySnapshot>? searchResults;
  handleSearch(String query) {
    Stream<QuerySnapshot> users = groups
        .where('location', isGreaterThanOrEqualTo: query.substring(0).toUpperCase())
        .where("type", isEqualTo: "group")
        .snapshots();
    setState(() {
      searchResults = users;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
        iconTheme: IconThemeData(
    color: Colors.black, //change your color here
  ),
      backgroundColor: Colors.white,
      title: TextFormField(
        decoration: InputDecoration(
            hintText: "search city posts.",
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchcontroller.clear();
              },
            )),
        onFieldSubmitted: handleSearch,
        controller: searchcontroller,
        onChanged: handleSearch,
      ),
    );
  }

  Container buildnoContent() {
    return Container(
      child: Center(
        child: ListView(
          children: <Widget>[
            Text(
              "Find Group by location",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 60.0),
            )
          ],
        ),
      ),
    );
  }

  buildSearchResults(String userid) {
    return StreamBuilder<QuerySnapshot>(
        stream: searchResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          QuerySnapshot? data = snapshot.data;
          return ListView.builder(
              itemCount: data!.docs.length,
              itemBuilder: (context, index) {
                GroupsModel model = GroupsModel.fromquersnapshot(data, index);
                // ignore: unused_local_variable

                return model.type == "group"
                    ? Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        width: 100,
                        child: Card(
                          color: Colors.indigo,
                          child: ListTile(
                              leading: model.image==""?Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(model.image)),
                                    shape: BoxShape.circle),
                              ):Container(child: CircleAvatar(child: Text(model.groupname[0]),),),
                              title: Text(
                                model.groupname,
                                style: TextStyle(color: Colors.white),
                              ),
                              // ignore: deprecated_member_use
                              trailing: RaisedButton(
                                onPressed: () {
                                  if (model.userids.contains(userid) == false) {
                                    userfirestore.doc(userid).update({
                                      "groups":
                                          FieldValue.arrayUnion([model.groupid])
                                    });
                                    groups.doc(model.groupid).update({
                                      "members":
                                          FieldValue.arrayUnion([userid]),
                                    });
                                  }
                                },
                                child: model.userids.contains(userid)
                                    ? Text("Joined")
                                    : Text('JOIN'),
                              )),
                        ),
                      )
                    : Text("");
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: buildSearchField(),
      body: searchResults == null
          ? buildnoContent()
          : buildSearchResults(userprovider.userdata.userid),
    );
  }
}
