import 'package:flutter/material.dart';

class Searchess extends StatefulWidget {
  const Searchess({Key? key}) : super(key: key);

  @override
  _SearchessState createState() => _SearchessState();
}

class _SearchessState extends State<Searchess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          decoration: InputDecoration(
              hintText: ('Search City post'),
              prefixIcon: Icon(
                Icons.account_box,
              ),
              suffixIcon: Icon(Icons.clear)),
        ),
      ),
    );
  }
}
