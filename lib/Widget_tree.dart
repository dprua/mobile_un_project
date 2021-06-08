import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signin_page.dart';
import 'register.dart';
import 'home_page.dart';
import 'waiting_page.dart';

var flag = 0;
var circle = false;
var tt = true;
class WidgetTree extends StatefulWidget {

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    CollectionReference ref = FirebaseFirestore.instance.collection('users');

    if (user == null) {
      tt = true;
      return SignInPage();
    }
    else  {
      if (tt) {
        ref.doc(user.uid).get().then((doc){
          if (doc.exists) {
            flag = 2;
            circle = true;
          }
          else {
            flag = 1;
          }
          setState(() {
            tt = false;
          });
        });
      }
      if (flag == 1) {
        tt = true;
        return RegisterForm();
      }
      else if (flag == 0) {
        return Waiting();
      }
      else {
        return HomePage();
      }
    }

  }
}
