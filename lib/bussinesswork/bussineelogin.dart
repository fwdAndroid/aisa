import 'package:aisa/bussinesswork/BusinessAuth/businessfunction.dart';
import 'package:aisa/bussinesswork/buisnessmainpage.dart';
import 'package:aisa/bussinesswork/businessregistration.dart';
import 'package:aisa/bussinesswork/forgotpassword/forgotpasswordbu.dart';
import 'package:aisa/studentswork/forgotpassword/forgot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BussinssLogin extends StatefulWidget {
  const BussinssLogin({Key? key}) : super(key: key);

  @override
  _BussinssLoginState createState() => _BussinssLoginState();
}

class _BussinssLoginState extends State<BussinssLogin> {
    TextEditingController password=TextEditingController();
     TextEditingController email=TextEditingController();
       bool currentstate=false;
       bool view=true;
    final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: currentstate,
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: ListView(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/aisa.png'),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 1,
                  ),
                  child: Center(
                    child: Text(
                      'Log in For Business Users! ',
                      style: TextStyle(color: Colors.indigo, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                  height: 60.0,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: email,
                      validator: (value) {
                          if (value!.isNotEmpty&&value.contains("@") ) {
                            return null;
                          } else {
                            return 'Please enter valid email';
                          }
                        },
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter Your Email'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                  height: 60.0,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: password,
                    obscureText: view,
                      validator: (value) {
                          if (value!.isNotEmpty ) {
                            return null;
                          } else {
                            return 'Please enter passworc';
                          }
                        },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                         suffixIcon:GestureDetector(
                          onTap: (){
                            setState(() {
                              view=!view;
                            });
                          },
                          child:view? Icon(Icons.visibility):Icon(Icons.visibility_off)),
                        labelText: 'Password',
                        hintText: 'Enter Your Password'),
                  ),
                ),
                Container(
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    child: Text(
                      'Forget Password ?',
                      style: TextStyle(color: Colors.indigo),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                  height: 50,
                  width: 400,
                  
                
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    
                    color: Colors.pink,
                    
                    onPressed: ()  {
                       if(formkey.currentState!.validate()){
                               setState(() {
                                 currentstate=true;
                               });
                               BusinessAuth().businesslogin(context, email.text.trim(), password.text.trim()).then((value){
                                 setState(() {
                                   currentstate=false;
                                 });
                               });
                             }
                    },
                    child:  Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusinessRegistration()),
                              );
                            },
                            child: Text('No account?' ' Sign up'))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
