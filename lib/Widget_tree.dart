import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signin_page.dart';
import 'firebase_provider.dart';
import 'register.dart';
import 'dart:io';
import 'home_page.dart';
import "waiting_page.dart";

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
    print("WHAT????");
    User user = Provider.of<User>(context);
    //var flag = Provider.of<Boolcheck>(context, listen:true);
    final firstNotifier = Provider.of<FirebaseProvider>(context, listen:true);
    CollectionReference ref = FirebaseFirestore.instance.collection('users');

    if (user == null) {
      print("WHAT????");
      //flag = 0;
      tt = true;
      return SignInPage();
    }
    else  {
      print("tt"+tt.toString());
      // final snapShot = FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      // snapShot.whenComplete(() => judge(user.uid));
      if (tt) {
        ref.doc(user.uid).get().then((doc){
          if (doc.exists) {
            print("이거이거");
            flag = 2;
            circle = true;
          }
          else {
            print("요거요거");
            flag = 1;
          }
          setState(() {
            tt = false;
          });
        });
      }
      print(user.uid);
      print(flag);
      if (flag == 1) {
        print("REGISTER!!!!!!!!!");
        tt = true;
        return RegisterForm();
      }
      else if (flag == 0) {
        print("TPPP!!!");
        return Waiting();
      }
      else {
        print("HOME!!!");
        return HomePage();
      }
    }

  }
}
