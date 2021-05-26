import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:un_project/STF/stfpage.dart';
import 'package:un_project/HR/hrpage.dart';


// Home page for Staff
class HomePage extends StatelessWidget{

  gettype() async {
    Future<DocumentSnapshot> docSnapshot = FirebaseFirestore.instance
        .collection('users').doc(FirebaseAuth.instance.currentUser.uid).get();
    DocumentSnapshot docu = await docSnapshot;
    int a = await docu.get('user_type');
    return a;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      // Default page is grid view of positions approved by HM
      body: SafeArea(
        child: FutureBuilder(
          future: gettype(),
          builder: (BuildContext context, AsyncSnapshot snapshot1) {
            if (snapshot1.hasData == false) {
              return CircularProgressIndicator();
            }
            else if (snapshot1.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot1.error}',
                  style: TextStyle(
                      fontSize: 15),
                ),
              );
            }
            else {
              var loginstate;
              if (snapshot1.data.toString() == '0') {
                loginstate = 'HM';
                return HMPage();
              }
              else if (snapshot1.data.toString() == '1') {
                loginstate = 'HR';
                return HRPage();
              }
              else {
                loginstate = 'STF';
                return StfPage();
              }
            }
          }
        ),
      ),
    );
  }
}







