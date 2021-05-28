import 'package:flutter/material.dart';
import 'package:un_project/profile.dart';
import 'package:un_project/STF/stfwidget.dart';
import 'package:un_project/STF/stfadd.dart';


class StfPage extends StatelessWidget{
  var loginstate = "STF";
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
          title: Text("For Staff home page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StaffAdd()),
                );
              },
            ),
          ]
      ),
      // Default page is grid view of positions approved by HM
      body: SafeArea(
        child : STFWidget(user_state: loginstate),
      ),
    );
  }
}

class HMPage extends StatelessWidget{
  var loginstate = "STF";
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
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StaffAdd()),
                );
              },
            ),
          ]
      ),
      // Default page is grid view of positions approved by HM
      body: SafeArea(
        child : STFWidget(user_state: loginstate),
      ),
    );
  }
}
