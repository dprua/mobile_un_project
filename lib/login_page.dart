import 'package:flutter/material.dart';

import 'authentification.dart';

class LoginPage extends StatelessWidget {
  Future<void> signInWithGoogle() async {
    await Authentification().signInWithGoogle();
  }
  Future<void> signInWithAnonymous() async {
    await Authentification().signInWithAnonymous();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.network('https://seeklogo.com/images/F/firebase-logo-402F407EE0-seeklogo.com.png',scale: 3,),
                SizedBox(height: 16.0),
              ],
            ),
            SizedBox(height: 80.0),
            RaisedButton(
              onPressed: signInWithGoogle,
              child: Text("Login With Google"),
            ),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: signInWithAnonymous,
              child: Text("Login With Anonymous"),
            ),
          ],
          ),
        ),

      );
  }
}
