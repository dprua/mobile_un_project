import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:un_project/STF/stfedit.dart';
import 'package:un_project/STF/stfapply.dart';

class StaffDetail extends StatefulWidget{
  final doc;
  StaffDetail({@required this.doc});
  @override
  StaffDetailState createState() => StaffDetailState();
}

class StaffDetailState extends State<StaffDetail>{
  bool join = false;
  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('post')
          .doc(widget.doc.id)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Detail"),
            actions:
            (widget.doc.get('writerId') == FirebaseAuth.instance.currentUser.uid)
                ? <Widget>[
              IconButton(
                icon: Icon(Icons.edit), // edit button
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StaffEdit(doc: widget.doc),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  FirebaseFirestore.instance.collection('post').doc(widget.doc.id).delete();
                  Navigator.pop(context);
                },
              ),
            ]
                : [],
          ),
          body: Container(
            child: Row(
              children: [
                // Left, See the description of that position
                /*Column(
                  children: [
                    Text("This is start of Detail of position"),
                    // have to change
                    // have to add

                    ElevatedButton(
                        onPressed: (){
                          join = true;
                        },
                        child: Text("Join?")
                    ),
                  ],
                ),*/
                // Right, if The Join? button clicked, boolean check true and show the apply on the right
                (join)
                    ? ApplyPage(docId: widget.doc.id)
                    : Text("Push Join Button"),
              ],
            ),
          ),
        );
      },
    );
  }
}