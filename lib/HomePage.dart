import 'package:flutter/material.dart';
import 'package:flutter_firebase/Login_Page.dart';
import 'package:flutter_firebase/SignUpPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Firebase'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(color: Colors.blue,
                child: Text('Sign In'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }),
            RaisedButton(color: Colors.blue,
                child: Text('Sign Up'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                })
          ],
        ),
      ),
    );
  }
}
