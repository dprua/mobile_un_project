import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class Authentification {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          return userCredential.user;
        }
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  getProfileImage() {
    print(_firebaseAuth.currentUser.uid);
    print(_firebaseAuth.currentUser.photoURL);
    print(_firebaseAuth.currentUser.email);
    if(_firebaseAuth.currentUser.photoURL != "") {
      return Image.network(_firebaseAuth.currentUser.photoURL, height: 100, width: 100);
    } else {
      return Image.network("https://handong.edu/site/handong/res/img/logo.png", height: 100, width: 100);
    }
  }
  getEmail() {
    if(_firebaseAuth.currentUser.email != "") {
      return Text(_firebaseAuth.currentUser.photoURL);
    } else {
      return Text("Anonymous");
    }
  }

  Future<void> signInWithAnonymous() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
