import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Color(0xFF01579B),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('post')
                .doc(widget.applyId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 335, vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        snapshot.data['photoURL'] == ""
                            ? AspectRatio(
                          aspectRatio: 12 / 7,
                          child: Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/post%20photo%2F%ED%9A%8C%EC%83%89%EC%B9%B4%EB%A9%94%EB%9D%BC.PNG?alt=media&token=313d9221-433d-42e5-92aa-d0c57252ab7c",
                              height: 100,
                              width: 175),
                        )
                            : AspectRatio(
                          aspectRatio: 12 / 7,
                          child: Image.network(
                            snapshot.data['photoURL'],
                            height: 100,
                            width: 175,
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name: ${snapshot.data['Name']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 10,),
                              Text("Title: ${snapshot.data['Title']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 10,),
                              Text("Branch: ${snapshot.data['Branch']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 10,),
                              Text(
                                  "Duty Station: ${snapshot.data['Duty station']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 10,),
                              Text("Level: ${snapshot.data['Level']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 10,),
                              Text("writer ID: ${snapshot.data['writerId']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),

                        //Text(widget.applyId),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}