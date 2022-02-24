import 'package:aisa/studentswork/Search/searchcity.dart';
import 'package:flutter/material.dart';

class SeparateGroup extends StatefulWidget {
  const SeparateGroup({Key? key}) : super(key: key);

  @override
  _SeparateGroupState createState() => _SeparateGroupState();
}

class _SeparateGroupState extends State<SeparateGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchCity()));
              },
            ),
          ],
          title: Text('Search Groups'),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              width: 100,
              child: Card(
                color: Colors.indigo,
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/plus.png')),
                        shape: BoxShape.circle),
                  ),
                  title: Text(
                    'Group Name',
                    style: TextStyle(color: Colors.white),
                  ),
                  // ignore: deprecated_member_use
                  trailing: RaisedButton(
                    color: Colors.indigo,
                    onPressed: () {},
                    child: Text('JOIN'),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
