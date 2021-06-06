import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../profile.dart';
import 'package:un_project/HM/approval_page.dart';
import 'package:un_project/HM/hmDetail_page.dart';
import 'package:un_project/authentification.dart';
import 'package:un_project/signin_page.dart';

// Home page for Staff
class hmHomePage extends StatefulWidget {
  // List<String> arr;
  // getApproval() async{
  //   Future<DocumentSnapshot> docSnapshot = FirebaseFirestore.instance
  //       .collection('post')
  //       .doc(FirebaseAuth.instance.currentUser.uid)
  //       .get();
  //   DocumentSnapshot docu= await docSnapshot;
  //   if(docu.get('approval')==false)
  //     arr+=FirebaseAuth.instance.currentUser.uid;
  // }

  @override
  _hmHomePageState createState() => _hmHomePageState();
}

class _hmHomePageState extends State<hmHomePage> {
  bool _isIncluding = false;

  Future<void> signOut() async {
    await Authentification().signOut();
  }

  gettype() async {
    Future<DocumentSnapshot> docSnapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    DocumentSnapshot docu = await docSnapshot;
    int a = await docu.get('user_type');
    return a;
  }



  _navigateAnd(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Approval(
              doc: FirebaseFirestore.instance.collection('post').snapshots())),
    );
    if (result) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF01579B),
          centerTitle: true,
          title: Text("For HM home page"),
          actions: <Widget>[

          ]),
      // Default page is grid view of positions approved by HM
      body: SafeArea(
        child: Center(
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
                      SizedBox(height: 20,),
                      FlatButton(
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
                            ),
                            title: Text(
                              "Profile",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                      SizedBox(height: 20,),
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Approval(
                                      doc: FirebaseFirestore.instance
                                          .collection('post')
                                          .snapshots())),
                            );
                            // _navigateAnd(context);
                          },
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('post')
                                  .where('approval', isEqualTo: false)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                else if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ListTile(
                                  leading: snapshot.data.docs.length == 0
                                      ? Icon(
                                          Icons.add_alert,
                                          color: Colors.yellow,
                                          size: 40,
                                        )
                                      : Icon(Icons.add_alert,
                                          color: Colors.red, size: 40),
                                  title: Text(
                                    "Approval",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                );
                              })),
                      SizedBox(height: 20,),
                      FlatButton(
                          onPressed: () {
                            signOut();
                          },
                          child: ListTile(
                                  leading:  Icon(Icons.logout, size: 40),
                                  title: Text(
                                    "Log out",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),

                    ],
                  )),
              const VerticalDivider(
                color: Colors.grey,
                thickness: 1,
                indent: 20,
                endIndent: 0,
                width: 20,
              ),
              FutureBuilder(
                  future: gettype(),
                  builder: (BuildContext context, AsyncSnapshot snapshot1) {
                    if (snapshot1.hasData == false) {
                      return CircularProgressIndicator();
                    } else if (snapshot1.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${snapshot1.error}',
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    } else {
                      var loginstate;
                      if (snapshot1.data.toString() == '0')
                        loginstate = 'HM';
                      else if (snapshot1.data.toString() == '1')
                        loginstate = 'HR';
                      else
                        loginstate = 'STF';

                      return Expanded(child: ViewWidget(user_state: loginstate));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewWidget extends StatefulWidget {
  final user_state;

  ViewWidget({@required this.user_state});

  @override
  ViewState createState() => ViewState();
}

class ViewState extends State<ViewWidget> {
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
            print(widget.user_state);
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
            builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
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
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width),
                          )
                          : Container(
                            width: MediaQuery.of(context).size.width - 650,
                            height: MediaQuery.of(context).size.height - 650,
                            child: Image.network(
                              document.get('photoURL'),
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
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
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text("more"),
                          onPressed: () {
                            // When tap the "more", go to Detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      hmDetailPage(doc: document)),
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
          ),
        ),
      ],
    );
  }
}
