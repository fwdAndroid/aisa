import 'package:aisa/studentswork/bottomstudent/bottompages/chat.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/explorer.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/post.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentBottomPage extends StatefulWidget {
  int index;
  StudentBottomPage({required this.index});
  @override
  _StudentBottomPageState createState() => _StudentBottomPageState();
}

class _StudentBottomPageState extends State<StudentBottomPage> {
  final _pageOptions = [Post(), Chat(), Explorer()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[widget.index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: widget.index,
        onTap: (int index) {
          setState(() {
            widget.index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,

            icon: Icon(Icons.post_add),
            // ignore: deprecated_member_use
            label: 'Post',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,

            icon: Icon(Icons.chat_sharp),
            // ignore: deprecated_member_use
            label: 'Chat',
          ),
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.indigo,
          //   icon: Icon(Icons.settings),
          //   // ignore: deprecated_member_use
          //   title: Text('Settings'),
          // ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,

            icon: Icon(Icons.search),
            // ignore: deprecated_member_use
            label: 'Explorer',
          ),
        ],
      ),
    );
  }
}
