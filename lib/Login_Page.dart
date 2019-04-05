import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/User.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _signIn(BuildContext context, String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      if (user != null) {
      } else {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(
            "Something went wrong, Try Again.",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    }).catchError((e) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
          e.message,
          style: TextStyle(color: Colors.red),
        ),
      ));
    }).whenComplete(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UserDetails()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  autovalidate: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Email';
                    }
                  },
                  onSaved: (value) => this._email = value,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                TextFormField(
                  autovalidate: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Password';
                    }
                  },
                  onSaved: (value) => this._password = value,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                RaisedButton(
                  color: Colors.blue,
                    child: Text('Login'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _signIn(context, _email, _password);
                      }
                    })
              ],
            ),
          )),
    );
  }
}
