import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:convert';
import 'main.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}
 List<String> subject= new List(8);
 List<String> total = new List(8);
 List<String> obtain = new List(8);
 List<bool> enter = new List(8);
 bool fetched;
class LoginState extends State<LoginPage> {
  final reg = TextEditingController();
  final pass = TextEditingController(); 
  bool _validateError = false;
  LoginState()
  {
    fetched = false;
  }


  @override
  void dispose() {
    reg.dispose();
    pass.dispose();
    super.dispose();
  }

    void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Incorrect Username/Password"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void validate()
  {
    fetched = false;
    fetchData();
    if(fetched == true)
    {
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
    }
    else
    {
      _showDialog();
    }
  }
  Future<void> fetchData() async {
    try {
      fetched = true;
      var dio =
          Dio(BaseOptions(contentType: ContentType.parse("application/json")));
      Map data = {"event_id": "0" , "reg":reg.text , "password":pass.text};
      Response resp = await dio.post(
          "http://209.97.168.217:4200/getdata",
          data: json.encode(data));
      Map received = await json.decode(resp.toString());
      if (!received.containsKey('Regno'))
        print("None");
      else {
        setState(() {
          fetched = true;
          fetched = true;
          for(int i=0;i<8;i++)
          {
            if(received['marks']['$i']['enter'] == "true")
            {
              enter[i] = true;
              subject[i] = received['marks']['$i']['subject'];
              total[i] = received['marks']['$i']['total'];
              obtain[i] = received['marks']['$i']['obtain'];
            }
            else
            {
              enter[i] = false;
              subject[i] = received['marks']['$i']['subject'];
            }
          }
        });
      }
    } catch (e) {
      print(e);
      print("None");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
        body: Center(
          child : Stack(
        // fit: StackFit.expand,
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
         Container(
           padding: EdgeInsets.only(top: 30
            ),
            child: FlareActor(
              "assets/earthlogin.flr",
              alignment: Alignment.center,
              fit: BoxFit .cover,
              animation: "Preview2",
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 400
            ),
            alignment: Alignment.center,
            width: 200,
            child: ListView(
              children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: TextField(
                      controller: reg,
                      decoration: InputDecoration(
                          errorText: _validateError
                              ? "Channel ID Incorrect"
                              : null,
                          border: InputBorder.none,
                          labelText: 'Registration Number',
                          prefixIcon: Icon(Icons.account_circle),
                          ),
                    ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: TextField(
                      controller: pass,
                      decoration: InputDecoration(
                          errorText: _validateError
                              ? "Channel ID Incorrect"
                              : null,
                          border: InputBorder.none,
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          ),
                    ),
          ),
           Container(
            child: RaisedButton(
                              
                              onPressed: () => validate(),
                              child: Text("Login"),
                              color: Colors.black,
                              textColor: Colors.white,
                   ),
          ),
              ]
            )
          ),
        ],
      )
      ),
      );
  }
}