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
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.brown[50],
                        child: Container(
                          child: Column(
                            children: [
                              document.get('photoURL') == ""
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 650,
                                  height: MediaQuery.of(context).size.height - 620,
                                  child: Image.network(
                                    "https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/post%20photo%2F%ED%9A%8C%EC%83%89%EC%B9%B4%EB%A9%94%EB%9D%BC.PNG?alt=media&token=313d9221-433d-42e5-92aa-d0c57252ab7c",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 650,
                                  height: MediaQuery.of(context).size.height - 620,
                                  child: Image.network(
                                    document.get('photoURL'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Title: ${document.get('Title')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Level: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Wrap(
                                            children: List.generate(document.get('Level'), (index) {
                                              return Text("🔥 ",);
                                            })
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20,),
                                    Expanded(
                                      child: Text(
                                        "Duty station: ${document.get('Duty station')}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15,),
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Division: ${document.get('Division')}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Branch: ${document.get('Branch')}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),
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
                                  SizedBox(width: 20,),
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
                            ],
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

