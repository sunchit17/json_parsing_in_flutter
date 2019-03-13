import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'JSON Parsing Example',
    home: new MyHomePage(),
  ));
}

// Stateful widget
class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

// State Class of the Stateful Widget
class _MyHomePageState extends State<MyHomePage> {

  // API Calling and JSON Response Parsing
  Future<List<User>> _getUsers() async {
    var data = await http
        .get('http://www.json-generator.com/api/json/get/cfwZmvEBbC?indent=2');

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user =
          User(u['index'], u['about'], u['name'], u['email'], u['picture']);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'User Information',
          style:
              new TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    strokeWidth: 10.0,
                    value: 50.0,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data[index].picture,
                      ),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(snapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: Text(
          user.name,
          style: new TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.w700),
        ),
      ),
      body: new Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.picture, scale: 40.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Center(
                child: Text(
              'ABOUT:',
              style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
            )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                    child: Text(
                  user.about,
                  style: new TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ))),
          ],
        ),
      ),
    );
  }
}

// JSON Data Fields Class and Constructor
class User {
  final int index;
  final String about;
  final String name;
  final String email;
  final String picture;

  User(this.index, this.about, this.name, this.email, this.picture);
}
