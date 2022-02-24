import 'package:aisa/bussinesswork/BusinessAuth/businessfunction.dart';
import 'package:aisa/bussinesswork/bussineelogin.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BusinessRegistration extends StatefulWidget {
  const BusinessRegistration({Key? key}) : super(key: key);

  @override
  _BusinessRegistrationState createState() => _BusinessRegistrationState();
}

class _BusinessRegistrationState extends State<BusinessRegistration> {
  TextEditingController business = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController number = TextEditingController(text: "+61");
  TextEditingController password = TextEditingController();
  bool currentstate = false;
  final formkey = GlobalKey<FormState>();
  bool valid = false;
  bool view = true;
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
                        'Sign up for buisness users',
                        style: TextStyle(color: Colors.indigo, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      controller: business,
                      obscureText: false,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter business name';
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter buisness Name',
                          hintText: 'Enter buisness Name'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                    height: 60.0,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      controller: email,
                      obscureText: false,
                      validator: (value) {
                        if (value!.isNotEmpty && value.contains("@")) {
                          return null;
                        } else {
                          return 'Please enter only university domain email';
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter buisness Email',
                          hintText: 'Enter buisness Email'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                    height: 60.0,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      controller: address,
                      obscureText: false,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter business address';
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Address',
                          hintText: 'Enter Address'),
                    ),
                  ),
                  Container(
                  margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                  height: 60.0,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: number,
                      validator: (value) {
                          if (value!.isNotEmpty&&value.contains("+") ) {
                            return null;
                          } else {
                            return 'Please enter mobile number with country code';
                          }
                        },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Number',
                      hintText: 'Enter Number',
                    ),
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
                            return 'Please enter password';
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
                      labelText: 'Enter Password',
                      hintText: 'Enter Password',
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                  height: 50.0,
                
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: ElevatedButton(onPressed: (){
                     if(valid==true){
                       if(formkey.currentState!.validate()){
                  setState(() {
                     currentstate=true;
                  });
                     BusinessAuth().businesssignup(context, email.text.trim(), password.text.trim()).then((value){
                    if(value.uid!=null){
                      BusinessAuth().saveuserdata(context, email.text.trim(), number.text.trim(), business.text.trim(), address.text.trim(),).then((value){
                                     setState(() {
                        currentstate=false;
                        // Navigator.push(context, MaterialPageRoute(builder: (builder) => BussinssLogin()));
                      });
                      });
                    }else{
                      setState(() {
                        currentstate=false;
                      });
                    }
                   }).onError((error, stackTrace){
                       setState(() {
                                currentstate=false;
                              });
                   });
                     }
               
                
                     }   }, child: Text('Register'),))],
              ),
            ),
          ),
        ));
  }
}
