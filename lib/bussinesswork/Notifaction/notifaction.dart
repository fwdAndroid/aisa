import 'package:flutter/material.dart';

class Notificationss extends StatefulWidget {
  const Notificationss({Key? key}) : super(key: key);

  @override
  _NotificationssState createState() => _NotificationssState();
}

class _NotificationssState extends State<Notificationss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('AISA'),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 30),
                child: Text(
                  'NOTIFACTIONS',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.yellow,
                  size: 40,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 2, left: 10, right: 10),
            height: 80,
            width: 100,
            child: Card(
              elevation: 10,
              color: Colors.white70,
              child: ListTile(
                leading: Text(
                  'Hassan Like Your Pages',
                ),
                trailing: Container(
                    margin: EdgeInsets.only(top: 25), child: Text('7:20pm')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
