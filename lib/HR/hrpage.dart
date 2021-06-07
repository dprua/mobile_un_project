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
          backgroundColor: Color(0xFF01579B),
          centerTitle: true,
          title: Text("UNITED NATIONS"),
          actions: <Widget>[

          ]),
      // Default page is grid view of positions approved by HM
      body: SafeArea(
        child : HRWidget(user_state: loginstate),
      ),
    );
  }
}