import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class hmPostInfo extends StatefulWidget {
  final doc;
  final applyId;

  hmPostInfo({Key key, @required this.doc, @required this.applyId});

  @override
  _hmPostInfoState createState() => _hmPostInfoState();
}

class _hmPostInfoState extends State<hmPostInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail about Position "),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('post')
                .doc(widget.applyId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot){
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                child: Center(
                  child: Column(
                    children: [
                      Text(snapshot.data['Name']),
                      Text(snapshot.data['Branch'])
                      //Text(widget.applyId),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}