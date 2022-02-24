import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeparateMessages extends StatefulWidget {
  const SeparateMessages({Key? key}) : super(key: key);

  @override
  _SeparateMessagesState createState() => _SeparateMessagesState();
}

class _SeparateMessagesState extends State<SeparateMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            width: 100,
            child: Card(
              child: ListTile(
                title: Text(
                  'User Name',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  'Hi How are you',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
