import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String email;
  final String name;

  User.fromMap(Map<dynamic, dynamic> data)
      : uid = data['uid'],
        email = data['email'],
        name = data['name'];

  User.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String currentUID;
  void getCurrentUID()async{
    final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    currentUID = _user.uid;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUID();
  }
  @override
  Widget build(BuildContext context) {
    return
      currentUID!=null?
          StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance.collection('users').document(currentUID).snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator(),);
              return _buildBody(context,snapshot.data);
            },
          ):Center(child: CircularProgressIndicator(),);
  }
  Widget _buildBody(BuildContext context, DocumentSnapshot document){
    final _data = User.fromSnapshot(document);
    return Material(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
      Text('Your name is : ${_data.name}'),
      Text('Your email is : ${_data.email}'),


    ],),),);
  }
}

