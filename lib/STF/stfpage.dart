import 'package:flutter/material.dart';
import 'package:un_project/STF/stfwidget.dart';

class StfPage extends StatelessWidget{
  var loginstate = "STF";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF01579B),
          centerTitle: true,
          title: Text("國際聯合"),
      ),
      // Default page is grid view of positions approved by HM
      body: SafeArea(
        child : STFWidget(user_state: loginstate),
      ),
    );
  }
}

