import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:un_project/STF/stfadd.dart';
import 'package:un_project/STF/stfdetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:un_project/STF/stfedit.dart';
import 'package:un_project/authentification.dart';

import '../profile.dart';

class STFWidget extends StatefulWidget {
  final user_state;

  STFWidget({@required this.user_state});

  @override
  STFState createState() => STFState();
}

class STFState extends State<STFWidget> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await Authentification().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Container(
              width: 200.0,
              child: Column(
                children: [
                  Stack(children: [
                    AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/UN_emblem_blue.svg/64px-UN_emblem_blue.svg.png",
                          height: 50,
                          width: 50),
                    ),
                    Positioned(
                      top: 85,
                      left: 45,
                      child: Text(
                        'UN HR Application',
                        style: TextStyle(
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          size: 40,
                          color: Color(0xFF01579B),
                        ),
                        title: Text(
                          "Profile",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StaffAdd()),
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.add_location_alt_outlined,
                            color: Color(0xFF01579B), size: 40),
                        title: Text(
                          "Add Position",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      signOut();
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        size: 40,
                        color: Color(0xFF01579B),
                      ),
                      title: Text(
                        "Log out",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )),
          const VerticalDivider(
            color: Colors.grey,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            width: 20,
          ),
          Expanded(child: STFViewWidget()),
        ],
      ),
    );
  }
}

class STFViewWidget extends StatefulWidget {
  @override
  _STFViewState createState() => _STFViewState();
}

class _STFViewState extends State<STFViewWidget> {
  String dropdownValue = 'All';
  int levelNum = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          // positions per level (DropdownButton)
          value: dropdownValue,
          onChanged: (String newValue) {
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
                  .where('approval', isEqualTo: true)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('post')
                  .where('Level', isEqualTo: levelNum)
                  .where('approval', isEqualTo: true)
                  .snapshots(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {

              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.count(
              crossAxisCount: 3,
              children: snapshot.data.docs.map((document) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        document.get('photoURL') == ""
                            ? Container(
                                width: MediaQuery.of(context).size.width - 650,
                                height: MediaQuery.of(context).size.height - 650,
                                child: Image.network(
                                    "https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/post%20photo%2F%ED%9A%8C%EC%83%89%EC%B9%B4%EB%A9%94%EB%9D%BC.PNG?alt=media&token=313d9221-433d-42e5-92aa-d0c57252ab7c",
                                    height: 100,
                                    width: 175),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width - 650,
                                height: MediaQuery.of(context).size.height - 650,
                                child: Image.network(
                                  document.get('photoURL'),
                                  height: 100,
                                  width: 175,
                                ),
                              ),
                        SizedBox(
                          height: 25,
                        ),
                        Text("Title: ${document.get('Title')}"),
                        Text("Level: ${document.get('Level')}"),
                        Text("Division: ${document.get('Division')}"),
                        Text("Branch: ${document.get('Branch')}"),
                        Text("Duty station: ${document.get('Duty station')}"),
                        (document.get('writerId') ==
                                FirebaseAuth.instance.currentUser.uid)
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.pink),
                                  child: Text(
                                    "edit",
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StaffEdit(doc: document),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: Text("apply"),
                                  onPressed: () {
                                    // When tap the "more", go to Detail page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StaffDetail(doc: document)),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
            },
          )
        ),
        ],
      );

  }
}
