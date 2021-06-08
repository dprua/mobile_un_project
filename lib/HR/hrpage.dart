import 'package:flutter/material.dart';
import 'package:un_project/HR/hrwidget.dart';

class HRPage extends StatelessWidget{
  var loginstate = "HR";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF01579B),
          centerTitle: true,
          title: Text("UNITED NATIONS"),
      ),
      body: SafeArea(
        child : HRWidget(user_state: loginstate),
      ),
    );
  }
}