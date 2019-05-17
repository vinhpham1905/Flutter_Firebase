import 'dart:async';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/User.dart';

class FBLogin {
  static final FacebookLogin facebookSignIn = new FacebookLogin();


  static void fbSignIn(BuildContext context) async{
    facebookSignIn
        .logInWithReadPermissions(['email', 'public_profile']).then((result) {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((signedInUser) {
            print('login fb Signed in as ${signedInUser.displayName}');
            print(result.accessToken.token);
          }).catchError((e) {
            print(e);
          }).whenComplete(() {
            pushUserDataToFireBase();
          }).whenComplete((){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>UserDetails()));
          });
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('Cancel');
          break;
        case FacebookLoginStatus.error:
          print(result.errorMessage);
          break;
      }
    }).catchError((e) {
      print(e);
    });
  }

  static Future<void> pushUserDataToFireBase() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();
    DocumentReference ref = _firestore.collection('users').document(user.uid);
    return ref.setData({
      'name': user.displayName,
      'email': user.email,
      'photo':user.photoUrl
    });
  }
}
