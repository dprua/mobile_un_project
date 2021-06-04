import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:un_project/HM/hmPostInfo_page.dart";

var target;

class Approval extends StatefulWidget {
  final doc;

  Approval({Key key, @required this.doc}) : super(key: key);

  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  String dropdownValue = 'All';
  int levelNum = 0;

  Future<void> updateApproval(String id) {
    print(id);
    return FirebaseFirestore.instance
        .collection('post')
        .doc(id)
        .update({'approval': true});
  }

  deleteUser(String docId) async {
    return await FirebaseFirestore.instance
        .collection('post')
        .doc(docId)
        .delete()
        .then((value) => print("Doc Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  void showAlertDialog(BuildContext context, String uid) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reject'),
          content: Text("Are you sure you wanto to turn down this offer?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                deleteUser(uid);
                Navigator.pop(context, "Cancel");
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
            ),
            onPressed: () async{
              Navigator.pop(context,true);
            },
          ),
          centerTitle: true,
          title: Text("Approval page"),
          backgroundColor: Color(0xFF01579B),
          actions: <Widget>[]),
      body: Column(
        children: [
          DropdownButton<String>(
            // positions per level (DropdownButton)
            value: dropdownValue,
            onChanged: (String newValue) {
              //print(widget.user_state);
              setState(() {
                dropdownValue = newValue;
                var n;
                if (newValue == 'All') {
                  levelNum = 0;
                } else {
                  n = int.tryParse(newValue[6]);
                  levelNum = n;
                }
                // level 1, level 2, level 3,
                // Query collection 'post',   // have to change
              });
            },
            items: <String>[
              'All',
              'level 1',
              'level 2',
              'level 3',
              'level 4',
              'level 5',
              'level 6'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
              child: StreamBuilder(
                stream: (levelNum == 0)
                    ? FirebaseFirestore.instance
                    .collection('post')
                    .where('approval', isEqualTo: false)
                    .snapshots()
                    : FirebaseFirestore.instance
                    .collection('post')
                    .where('Level', isEqualTo: levelNum)
                    .where('approval', isEqualTo: false)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.count(
                    crossAxisCount: 3,
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width / 1.2,
                          // height: ,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                document.get('photoURL') == ""
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
                                    document.get('photoURL'),
                                    height: 100,
                                    width: 175,
                                  ),
                                ),
                                Text("Title: ${document.get('Title')}"),
                                Text("Level: ${document.get('Level')}"),
                                Text("Division: ${document.get('Division')}"),
                                Text("Branch: ${document.get('Branch')}"),
                                Text("Duty station: ${document.get('Duty station')}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: TextButton(
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(color: Color(0xFF1A237E)),
                                        ),
                                        onPressed: () async {
                                          print(document.id);
                                          await updateApproval(document.id);
                                          //update the users approval.
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          showAlertDialog(context,document.id);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    child: Text("more"),
                                    onPressed: () {
                                      target=document.id;
                                      print(target);
                                      print(FirebaseAuth.instance.currentUser.uid);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => hmPostInfo(doc: widget.doc,applyId: target),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              )),
        ],
      ),
    );
  }
}