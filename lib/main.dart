import 'package:flutter/material.dart';
import 'login.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}

class EventTile extends StatefulWidget {
  final int id;
  EventTile({this.id});
  @override
  createState() => EventTileState(this.id);
}

class EventTileState extends State<EventTile> {
  int id;
  bool f = false;
  EventTileState(int id) {
    this.id = id;
    if(enter[this.id] == false)
    {
      f = false;
    }
    if(enter[this.id] == true)
    {
      f = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return f == false
        ? Container(
            padding: EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 3.5, bottom: 3.5),
            decoration: BoxDecoration(
               boxShadow: [BoxShadow(
               color: Colors.grey,
            blurRadius: 2.0,
          ),],
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
            ),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 8.0, top: 2.0, bottom: 2.0),
                    child: Text(subject[this.id]),
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 8.0, top: 2.0, bottom: 2.0),
                    child: Text('Not Uploaded Yet'),
                  )
                ],
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 3.5, bottom: 3.5),
            decoration: BoxDecoration(
               boxShadow: [BoxShadow(
               color: Colors.grey,
            blurRadius: 1.0,
          ),],
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
            ),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 8.0, top: 2.0, bottom: 2.0),
                    child: Text(subject[this.id]),
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 8.0, top: 2.0, bottom: 2.0),
                    child: Text('Marks Obtained: ' + obtain[this.id]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 8.0, top: 2.0, bottom: 2.0),
                    child: Text('Total Marks: ' + total[this.id]),
                  )
                ],
              ),
            ),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.purple,
            title: Text('Internal Marks'),
            leading: Icon(Icons.dashboard),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                child: EventTile(id: 0),
              ),
              Container(
                child: EventTile(id: 1),
              ),
              Container(
                child: EventTile(id: 2),
              ),
              Container(
                child: EventTile(id: 3),
              ),
              Container(
                child: EventTile(id: 4),
              ),
              Container(
                child: EventTile(id: 5),
              ),
              Container(
                child: EventTile(id: 6),
              ),
              Container(
                child: EventTile(id: 7),
              ),
            ],
          )),
    );
  }
}