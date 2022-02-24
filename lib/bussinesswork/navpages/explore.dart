import 'package:aisa/studentswork/explorequery.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Explore'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                height: 150,
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ExploreQuery(
                                  query: "News Feed",
                                )));
                  },
                  child: Text(
                    'News Feed',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: CircleBorder(side: BorderSide.none),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: 150,
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ExploreQuery(
                                  query: "Accomodation",
                                )));
                  },
                  child: Text(
                    'Accomodation',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: CircleBorder(side: BorderSide.none),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                height: 150,
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ExploreQuery(
                                  query: "Jobs",
                                )));
                  },
                  child: Text(
                    'Jobs',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: CircleBorder(side: BorderSide.none),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: 150,
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ExploreQuery(
                                  query: "Local Bussiness",
                                )));
                  },
                  child: Center(
                    child: Text(
                      'Local Bussiness',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  shape: CircleBorder(side: BorderSide.none),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                height: 150,
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ExploreQuery(
                                  query: "Car Share",
                                )));
                  },
                  child: Text(
                    'Car Share',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: CircleBorder(side: BorderSide.none),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: 150,
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ExploreQuery(
                                  query: "Local Communities",
                                )));
                  },
                  child: Center(
                    child: Text(
                      'Local Communities',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  shape: CircleBorder(side: BorderSide.none),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
