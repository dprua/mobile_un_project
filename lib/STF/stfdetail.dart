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
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[Expanded(
                child: Column(
                  children: <Widget>[
                    Text("\n[${widget.doc['Title']}]", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10.0,),
                    Container(
                      decoration: BoxDecoration(
                        border:Border.all(),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0)
                        ),
                      ),
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Work Experience", style: TextStyle(fontSize: 20.0),),
                          for(var i in widget.doc['work_exp'])
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Text("   -   ${i.toString()}"),
                            ),
                          SizedBox(height:10.0),
                          Text("Languages", style: TextStyle(fontSize: 20.0),),
                          for(var i in widget.doc['lang_exp'])
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Text("  -  ${i.toString()}"),
                            ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          widget.doc['work_exp'].forEach((text){
                            print(text);
                            print(widget.doc['work_exp'].length);
                          });
                          setState(() {
                            join = true;
                          });
                        },
                        child: Text("Join?")
                    ),
                  ],
                ),
              ),
                const VerticalDivider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                  width: 20,
                ),
                Expanded(
                  child: (join)
                      ? ApplyPage(doc: widget.doc, applyId: FirebaseAuth.instance.currentUser.uid)
                      : Text("Push Join Button"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}