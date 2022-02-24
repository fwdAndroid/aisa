import 'dart:async';


import 'package:aisa/Functions/postfunctions.dart';
import 'package:aisa/Provider/userprovider.dart';
import 'package:aisa/bussinesswork/BusinessProvider/businessprovider.dart';
import 'package:aisa/mainpage.dart';
import 'package:aisa/models/postmodel.dart';
import 'package:aisa/models/userdatamodel.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/chat.dart';
import 'package:aisa/studentswork/bottomstudent/bottompages/showbigpost.dart';
import 'package:aisa/studentswork/bottomstudent/comment/comments2.dart';

import 'package:aisa/studentswork/bottomstudent/notific/socailnotification.dart';
import 'package:aisa/studentswork/bottomstudent/studentbottompage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions/functions.dart';
import 'package:rxdart/rxdart.dart';

final userfirestore = FirebaseFirestore.instance.collection("user");
final commentlikes = FirebaseFirestore.instance.collection("commentlikes");
final Reference storageRef = FirebaseStorage.instance.ref();
final userpost = FirebaseFirestore.instance.collection("posts");
final comments = FirebaseFirestore.instance.collection("comments");
final likes = FirebaseFirestore.instance.collection("likes");
final saveMyposts = FirebaseFirestore.instance.collection("savepost");
final groups = FirebaseFirestore.instance.collection("groups");
final businessuser = FirebaseFirestore.instance.collection("businessuser");
final notification = FirebaseFirestore.instance.collection("notification");
final reportpost = FirebaseFirestore.instance.collection("reportpost");
final reportuser = FirebaseFirestore.instance.collection("reportuser");
final BehaviorSubject<RemoteMessage? > selectNotificationSubject =
    BehaviorSubject<RemoteMessage?>();
final universityrequest =
    FirebaseFirestore.instance.collection("UniversityRquest");

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('Handling a background message ${message.messageId}');
  print(message.data);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthFunction>(create: (_) => AuthFunction()),
        Provider<UserProvider>(create: (_) => UserProvider()),
        Provider<BusinessProvider>(create: (_) => BusinessProvider()),
        Provider<PostFunctions>(create: (_) => PostFunctions()),
      ],
      child: MaterialApp(
        title: 'Aisa',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.indigo,
        ),
        home: CheckAlreadyLogin(),
      ),
    );
  }
}


class CheckAlreadyLogin extends StatefulWidget {
  @override
  _CheckAlreadyLoginState createState() => _CheckAlreadyLoginState();
}

class _CheckAlreadyLoginState extends State<CheckAlreadyLogin> {
  late bool loading = true;
  late bool get;
Future notificationselected(RemoteMessage? payload)async{
 selectNotificationSubject.add(payload);
 selectNotificationSubject.done;
}
  @override
  void initState() {
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

  
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification:(String? data)async{
        onclicked(message);
      });

 
 
  
      if (notification != null && android != null) {
      
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
                
              ),
              
            ));
      }
    });

    getdata();

    super.initState();
  }
onclicked(RemoteMessage? message)async{
   
   if(message!.data["type"]=="likes"){
   await   userpost.doc(message.data["postid"]).get().then((value){
                                           PostModel postmodel=PostModel.fromdoc(value);
                                             Map<String, dynamic>? likesdata =
                          value.data();
                            DateTime date=postmodel.timestamp.toDate();
                             
                             Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowBigPost(
                                          posts: postmodel,
                                          likesdata: likesdata,
                                          date: date)));

                                         }).onError((error, stackTrace){
                                           print(error);
                                         });  
                                    }else if(message.data["type"]=="comment"){
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Comments2(
                                              postid:message.data["postid"] )),
                                    );
    }else{
      Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(


                    )));
    }

}
  getToken() async {
    String utoken = (await FirebaseMessaging.instance.getToken())!;
    FirebaseAuth user = FirebaseAuth.instance;
    userfirestore.doc(user.currentUser!.uid).update({"token": utoken});
    print(utoken);
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      print(initialMessage.data);
      if (initialMessage.data["type"] == "likes") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SocialNotifications()));
      } else if (initialMessage.data["type"] == "comment") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SocialNotifications()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
// groupid: initialMessage.data["groupid"],
// groupname: initialMessage.data["groupname"],
// members: initialMessage.data["members"],
// myid: user.currentUser!.uid,
// type: initialMessage.data["gtype"],

                    )));
      }
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.data["members"]);
      if (message.data["type"] == "likes") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SocialNotifications()));
      } else if (message.data["type"] == "comment") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SocialNotifications()));
      } else if (message.data["type"] == "chat") {
        // List<dynamic>members=List<dynamic>.from(message.data["members"].map((x) => x));
        // print(members);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Chat()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SocialNotifications()));
      }
    });
  }

  Future authuser(String email, String password) async {
    try {
      final User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      DocumentSnapshot doc = await userfirestore.doc(user!.uid).get();
      // ignore: unnecessary_null_comparison
      if (doc.exists) {
        setState(() {
          loading = false;
          get = true;
          getToken();
          var userprovider = Provider.of<UserProvider>(context, listen: false);
          userprovider.getdata(Users.fromDocument(doc));
        });
      } else {
        setState(() {
          get = false;
          loading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          get = false;
          loading = false;
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          get = false;
          loading = false;
        });
      } else {
        setState(() {
          get = false;
          loading = false;
        });
      }
    }
  }

  getdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? email = sharedPreferences.getString("email");
    String? password = sharedPreferences.getString("password");

    if (email != null && password != null) {
      authuser(email, password);
    } else {
      setState(() {
        get = false;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading == true ? MyHomePage() : states(),
    );
  }

  Widget states() {
    if (get == false) {
      return MainPage();
    } else {
      return StudentBottomPage(
        index: 0,
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
            color: Colors.white,
            child: Image.asset(
              "assets/images/aisa.png",
              fit: BoxFit.contain,
            )),
      ),
    );
  }
}

