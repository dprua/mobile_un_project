import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentification.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await Authentification().signOut();
  }

  getProfileImage() {
    if(_firebaseAuth.currentUser.photoURL != null) {
      return Image.network(_firebaseAuth.currentUser.photoURL, height: 300, width: 300);
    } else {
      return Image.network("https://handong.edu/site/handong/res/img/logo.png", height: 300, width: 300);
    }
  }
  getEmail() {
    if(_firebaseAuth.currentUser.isAnonymous != true) {
      return Text(_firebaseAuth.currentUser.email,style: TextStyle(fontSize: 20));
    } else {
      return Text("Anonymous",style: TextStyle(fontSize: 20),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                semanticLabel: 'logout',
              ),
              onPressed: () {
                signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(80.0,0,80.0,0),
              child: Column(
                children: [
                  getProfileImage(),
                  SizedBox(height: 50,),
                  Text(
                    _firebaseAuth.currentUser.uid,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25,),
                  const Divider(
                      height: 1.0,
                      color: Colors.black,
                  ),
                  SizedBox(height: 25,),
                  getEmail(),
                ],
              ),
            )
        )
    );
  }
  /*
  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Provider.of(context).auth.getProfileImage(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "UID: ${FirebaseAuth.instance.currentUser.uid}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        const Divider(
          height: 1.0,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Email: ${authData.email ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

   */
}


