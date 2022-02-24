import 'package:aisa/bussinesswork/BusinessAuth/businessfunction.dart';
import 'package:aisa/bussinesswork/buisnessmainpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BussinOtp extends StatefulWidget {
  String userid;
  String id;
  BussinOtp({ required this.id,required this.userid});

  @override
  _BussinOtpState createState() => _BussinOtpState();
}

class _BussinOtpState extends State<BussinOtp> {
  TextEditingController otp=TextEditingController();

   bool currentstate=false;

    final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: currentstate,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                Container(
                  height: 300,
                  width: 300,
                  child: Image.asset('assets/images/aisa.png'),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 1,
                  ),
                  child: Center(
                    child: Text(
                      'Please Enter the Otp',
                      style: TextStyle(color: Colors.indigo, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                  height: 60.0,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    obscureText: false,
                    controller: otp,
                    validator: (value){
                      if(value!.isNotEmpty&&value.length==6){
                        return null;
                      }else{
                        return "Enter Valid Otp";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your Otp Code',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 100, right: 100),
                  height: 50.0,
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.pink,
                    onPressed: () {
                 if(formkey.currentState!.validate()){
                   setState(() {
                     currentstate=true;
                   });
                     BusinessAuth().varifysignupotp(context, widget.id, otp.text.trim(), widget.userid).then((value){
                     setState(() {
                       currentstate=false;
                     });
                   });
                 }
                      
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
