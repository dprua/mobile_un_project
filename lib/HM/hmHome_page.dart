import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../profile.dart';
import 'package:un_project/HM/approval_page.dart';
import 'package:un_project/authentification.dart';
import 'package:un_project/HM/hmdetail.dart';


class hmHomePage extends StatefulWidget {

  @override
  _hmHomePageState createState() => _hmHomePageState();
}

class _hmHomePageState extends State<hmHomePage> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF01579B),
          centerTitle: true,
          title: Text("UNITED NATIONS"),
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
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome!\nHM_admin!!",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
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
                              color: Color(0xFF01579B),
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
                                  leading:  Icon(Icons.logout, size: 40, color: Color(0xFF01579B),),
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
                endIndent: 15,
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
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
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
                                height: MediaQuery.of(context).size.height - 640,
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
                                height: MediaQuery.of(context).size.height - 640,
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
                            SizedBox(width: 15,),
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
                        SizedBox(height: 10,),
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
                        SizedBox(height: 10,),
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
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: Text("Detail"),
                              onPressed: () {
                                // When tap the "more", go to Detail page
                                //version 1
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           hmDetailPage(doc: document)),
                                // );
                                //version2
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          hmdetailPage(doc: document)),
                                );
                              },
                            ),
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
          ),
        ),
      ],
    );
  }
}

