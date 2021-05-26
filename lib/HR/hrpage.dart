import 'package:flutter/material.dart';
import 'package:un_project/profile.dart';
import 'package:un_project/HR/hrwidget.dart';

class HRPage extends StatelessWidget{
  var loginstate = "HR";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.person,
              semanticLabel: 'profile',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          centerTitle: true,
          title: Text("For HM home page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){

              },
            ),
          ]
      ),
      // Default page is grid view of positions approved by HM
      body: SafeArea(
        child : HRWidget(user_state: loginstate),
      ),
    );
  }
}