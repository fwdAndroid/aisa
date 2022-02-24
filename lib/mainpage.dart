import 'package:aisa/bussinesswork/bussineelogin.dart';
import 'package:aisa/studentswork/StudentAuth/studentlogin.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 80),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 200,
                        child: Text('ASIP',textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontSize: 48,fontStyle: FontStyle.italic),)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: MaterialButton(
                    height: 80,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.indigo,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentLogin()),
                      );
                    },
                    child: Text(
                      "Login As Students",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                //   child: MaterialButton(
                //     height: 80,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10.0)),
                //     color: Colors.indigo,
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => BussinssLogin()),
                //       );
                //     },
                //     child: Text(
                //       "Login As Business",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.only(top: 10),
                //   height: 80,
                //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                //   // ignore: deprecated_member_use
                //   child: RaisedButton(
                //     textColor: Colors.white,
                //     color: Colors.indigo,
                //     child: Text('Login As Business'),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => BussinssLogin()),
                //       );
                //     },
                //   ),
                // ),
              ],
            )));
  }
}
