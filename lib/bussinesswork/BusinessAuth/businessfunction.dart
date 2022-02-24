import 'package:aisa/Cutom%20Dialog/customdialog.dart';
import 'package:aisa/bussinesswork/BusinessProvider/businessprovider.dart';
import 'package:aisa/bussinesswork/buisnessmainpage.dart';
import 'package:aisa/bussinesswork/buisnessotp.dart';
import 'package:aisa/bussinesswork/businessmodel/businessusermodel.dart';
import 'package:aisa/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessAuth{
  late String verificationIdFromGoogle;
Future businesssignup(
      BuildContext context, String email, String password) async {
    try {
      final User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
     
    return user;
     
     
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
       
        showDialog(
            context: context,
            builder: (_) => LogoutOverlay(message: "${e.code}"));
      } else if (e.code == 'email-already-in-use') {
       
        showDialog(
            context: context,
            builder: (_) => LogoutOverlay(message: "${e.code}"));
      }
    } catch (e) {
     
      showDialog(
          // ignore: unnecessary_brace_in_string_interps
          context: context,
          // ignore: unnecessary_brace_in_string_interps
          builder: (_) => LogoutOverlay(message: "${e}"));
    }
  }
  Future saveuserdata(
      BuildContext context,
  
      String email,
      String phonenumber,
      String businessname,
      String address,
     
   
      ) async {
 
final firebaseUser = FirebaseAuth.instance.currentUser;
  
     businessuser.doc(firebaseUser!.uid).set({
        "email": email,
        "userid": firebaseUser.uid,
        "phonenumber": phonenumber,
        "businessname":businessname,
        "address": address,
      
       "verify":false
      
      }).then((value) async {
       
     verifyPhoneNo(context, phonenumber, firebaseUser.uid);
      
      }).onError((error, stackTrace) {
        showDialog(
            context: context,
            // ignore: unnecessary_brace_in_string_interps
            builder: (_) => LogoutOverlay(message: "${error}"));
      });
    }
    
  Future<void> verifyPhoneNo(
      context, String number, String userid ) async {
    // await Firebase.initializeApp();
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationIdFromGoogle = verId;
    };

   PhoneCodeSent smsCodeSent = (String verId, [int? forceCodeResend]) async {
      this.verificationIdFromGoogle = verId;
      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BussinOtp(id:this.verificationIdFromGoogle,userid:userid)));
   };
    
      // setState(() {
      //   state = false;
      // });

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential phoneAuthCredential) {
      print('verified');
    };

    final PhoneVerificationFailed veriFailed =
        (FirebaseAuthException exception) {
             showDialog(
            context: context,
            // ignore: unnecessary_brace_in_string_interps
            builder: (_) => LogoutOverlay(message: "${ exception}"));
  
      print('${exception.message}');
    };
    print(number);

    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: number,
            codeAutoRetrievalTimeout: autoRetrieve,
            codeSent: smsCodeSent,
            timeout: const Duration(seconds: 50),
            verificationCompleted: verifiedSuccess,
            verificationFailed: veriFailed)
        .onError((error, stackTrace) {
      // setState(() {
      //   state = false;
      // });
      showDialog(
        context: context,
        builder: (_) => LogoutOverlay(
          message: "${error}",
        ),
      );
    });
 


  
}
Future varifysignupotp(
      BuildContext context, String id, String otp,String userid) async {
    print("enter sign in using code");
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: id,
      smsCode: otp,
    );
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signInWithCredential(credential).then((user) {
     businessuser.doc(userid).update({
         "verify":true
     }).then((value)async{
       DocumentSnapshot doc=await businessuser.doc(userid).get();
       if(doc!=null){
var userprovider=Provider.of<BusinessProvider>(context,listen: false);
userprovider.getdata(BusinessUserModel.fromDocument(doc));
 Navigator.push(context,MaterialPageRoute(builder: (context)=> BusinessMainPage()));
       }
       

      
     });
      /////////////////////////////////////
    }).catchError((e) {
      showDialog(
        context: context,
        builder: (_) => LogoutOverlay(
          message: "${e}",
        ),
      );
    });
  }
   Future businesslogin(
      BuildContext context, String email, String password) async {
    try {
      final User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
     
      

if (user!= null ) {

 
      DocumentSnapshot document = await businessuser.doc(user.uid).get();
      if(document.exists){
 var userprovider = Provider.of<BusinessProvider>(context, listen: false);
 BusinessUserModel userModel=BusinessUserModel.fromDocument(document);
 if(userModel.verify==false){
    verifyPhoneNo(context, userModel.phonenumber, userModel.userid);
 }else{
userprovider.getdata(userModel);
      Navigator.push(context,MaterialPageRoute(builder: (context)=> BusinessMainPage()));
 }
      
   
     
}else{
  showDialog(
            context: context,
            builder: (_) => LogoutOverlay(message: "some error"));
}
}

    
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
   
        showDialog(
            context: context,
            builder: (_) => LogoutOverlay(message: "${e.code}"));
      } else if (e.code == 'wrong-password') {
       
        showDialog(
            context: context,
            builder: (_) => LogoutOverlay(message: "${e.code}"));
      }
    }
  }

}