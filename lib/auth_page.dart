import 'package:flutter/material.dart';
import 'firebase_provider.dart';
import 'signedin_page.dart';
import 'signin_page.dart';
import 'package:provider/provider.dart';

AuthPageState pageState;

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    pageState = AuthPageState();
    return pageState;
  }
}

class AuthPageState extends State<AuthPage> {
  FirebaseProvider fp;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    if (fp.getUser() != null && fp.getUser().emailVerified == true) {
      return SignedInPage();
    } else {
      return SignInPage();
    }
  }
}