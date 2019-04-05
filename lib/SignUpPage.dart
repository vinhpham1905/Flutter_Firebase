import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _name ;
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();
  var _firebaseInstance = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _doSignUp(String email, String password,) async {
    await _firebaseInstance
        .createUserWithEmailAndPassword(email: email,password: password)
        .then((user) {
      if (user != null) {
        _formKey.currentState.reset();

        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Successfully registered"),
        ));
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
      ///push user data to firestore
      getUserDoc();
    }).then((_){
      Navigator.pop(context);
    });
  }
  Future<void> getUserDoc() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();
    DocumentReference ref = _firestore.collection('users').document(user.uid);
    return ref.setData({
      'name': _name,
      'email': _email,
      'photo':'',
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
                  return 'Enter your name';
                }
              },
              onSaved: (value) => this._name = value,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name'),
            ),
            TextFormField(
              autovalidate: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter your email';
                }
              },
              onSaved: (value) => this._email = value,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email'),
            ),
            TextFormField(
              autovalidate: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter your password';
                }
              },
              onSaved: (value) => this._password = value,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password'),
            ),
            RaisedButton(child:Text('Sign up'),color: Colors.blue,onPressed: (){
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _doSignUp(_email, _password,);
              }
            })

          ],
        ),
      )),
    );
  }
}
