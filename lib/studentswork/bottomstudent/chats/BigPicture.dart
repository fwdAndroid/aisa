import 'package:flutter/material.dart';

class BigPictureChat extends StatefulWidget {
  String link;
  BigPictureChat({required this.link});

  @override
  _BigPictureChatState createState() => _BigPictureChatState();
}

class _BigPictureChatState extends State<BigPictureChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.cancel),onPressed: (){
          Navigator.pop(context);
        },),
        backgroundColor: Colors.transparent,
      elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height,
         decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.link),
         fit: BoxFit.fill
         )),
      ),
    );
  }
}