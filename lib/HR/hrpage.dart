import 'package:flutter/material.dart';
import 'package:un_project/profile.dart';
import 'package:un_project/HR/hrwidget.dart';
import 'package:un_project/HR/hrshow.dart';

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
          title: Text("For HR home page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HRShow()),
                );
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