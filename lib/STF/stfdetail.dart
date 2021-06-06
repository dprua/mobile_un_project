import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            backgroundColor: Color(0xFF01579B),
            centerTitle: true,
            title: Text("Detail"),
          ),
          body: Container(
            // padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[Expanded(
                child: ListView(
                  children: <Widget>[
                    (widget.doc['photoURL'] != "")
                        ? Image.network(
                      widget.doc['photoURL'],
                      fit: BoxFit.fitWidth,
                      height: MediaQuery.of(context).size.height/3,
                    )
                        : Container(),
                    Container(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconAndDetail(Icons.subtitles_rounded, "${widget.doc['Title']}"),
                          SizedBox(height: 10.0),
                          Text("\t\tWork Experience", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                          for(var i in widget.doc['work_exp'])
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Text("-   ${i.toString()}", style: TextStyle(fontSize: 17.0)),
                            ),
                          SizedBox(height:10.0),
                          Text("\t\tLanguages", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                          for(var i in widget.doc['lang_exp'])
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Text("-  ${i.toString()}",  style: TextStyle(fontSize: 17.0)),
                            ),
                        ],
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: (){
                            setState(() {
                              join = true;
                            });
                          },
                          child: Text("Join?")
                      ),
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
                      : Center(
                        child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/UN_emblem_blue.svg/512px-UN_emblem_blue.svg.png",
                        height: 300,
                        width: 300,
                    color: Colors.grey,
                  ),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail);
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(
          detail,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}