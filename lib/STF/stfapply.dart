import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApplyPage extends StatefulWidget{
  final docId;
  ApplyPage({@required this.docId});
  @override
  ApplyState createState() => ApplyState();
}

class ApplyState extends State<ApplyPage>{
  // PHP.pdf
  // TextEditingController

  // Add or update userID and user info into collection('post').doc(docId).collection('apply')

  @override
  Widget build(BuildContext context){
    return ListView(
      children: [
        Text("Have to change here"),
      ],
    );
  }
}