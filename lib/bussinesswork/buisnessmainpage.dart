import 'package:aisa/bussinesswork/navpages/Chat.dart';
import 'package:aisa/bussinesswork/navpages/explore.dart';
import 'package:aisa/bussinesswork/navpages/post.dart';
import 'package:aisa/bussinesswork/navpages/setting.dart';
import 'package:flutter/material.dart';

class BusinessMainPage extends StatefulWidget {
  const BusinessMainPage({Key? key}) : super(key: key);

  @override
  _BusinessMainPageState createState() => _BusinessMainPageState();
}

class _BusinessMainPageState extends State<BusinessMainPage> {
  //it is a index number
  int noshi = 0;
  final _subjec = [Post(),  Setting() ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _subjec[noshi],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        selectedItemColor: Colors.white,
        currentIndex: noshi,
        onTap: (int index) {
          setState(() {
            noshi = index;
          });
        },
        items: [
          new BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(Icons.home,color: Colors.white,),
            // ignore: deprecated_member_use
            title: Text('Post',style: TextStyle(color: Colors.white,)),
          ),
        
          new BottomNavigationBarItem(
              // ignore: deprecated_member_use
              icon: Icon(Icons.settings,color: Colors.white,),
              // ignore: deprecated_member_use
              title: Text('Setting',style: TextStyle(color: Colors.white,),)),
        
        ],
      ),
    );
  }
}
