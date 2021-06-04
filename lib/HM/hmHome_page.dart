import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../profile.dart';
import 'package:un_project/HM/approval_page.dart';
import 'package:un_project/HM/hmDetail_page.dart';


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

  gettype() async {
    Future<DocumentSnapshot> docSnapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    DocumentSnapshot docu = await docSnapshot;
    int a = await docu.get('user_type');
    return a;
  }

  getbool() async {
    var a = false;
    QueryDocumentSnapshot doc;
    DocumentSnapshot i;
    await FirebaseFirestore.instance
        .collection('post')
        .get()
        .then((snapshot) => {
      for (i in snapshot.docs)
        {
          doc = i,
          if (doc.data()['approval'] == false)
            {
              print("KKKKKKK"),
              print(doc.data()['approval']),
              a = true,
              setState,
            }
        }
    });
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
          leading: IconButton(
            icon: Icon(
              Icons.person,
              semanticLabel: 'profile',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          centerTitle: true,
          title: Text("For HM home page"),
          actions: <Widget>[
            StreamBuilder(
              //future: getbool(),
                stream: FirebaseFirestore.instance.collection('post').where('approval', isEqualTo: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData == false) {
                    print("HEREbbbbb");
                    return IconButton(
                        icon: Icon(Icons.add_alert),
                        onPressed: () {
                          print(snapshot.data);
                        });
                  }
                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    //print(snapshot.data['approval']);
                    return IconButton(
                      icon: snapshot.data.docs.length == 0
                          ? Icon(Icons.add_alert, color: Colors.yellow)
                          : Icon(Icons.add_alert, color: Colors.red),
                      //icon:Icon(Icons.add_alert),

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
                    );
                  }
                }),
          ]),
      // Default page is grid view of positions approved by HM
      body: SafeArea(
        child: FutureBuilder(
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

                return ViewWidget(user_state: loginstate);
              }
            }),
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
                                              hmDetailPage(doc: document )),
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
    );
  }
}

class StaffAdd extends StatefulWidget {
  @override
  StaffAddState createState() => StaffAddState();
}

class StaffAddState extends State<StaffAdd> {
  int levelId = 1;
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _divisionController = TextEditingController();
  final _branchController = TextEditingController();
  final _dutyController = TextEditingController();

  Future<DocumentReference> addPosition(String duty, String name, int posNum) {
    return FirebaseFirestore.instance.collection('post').add({
      'Branch': _branchController.text,
      'Division': _divisionController.text,
      'Duty station': duty,
      'Level': posNum,
      'Name': name,
      'Post': "",
      // have to change  // What it is ??????????
      'Title': _titleController.text,
      // have to change
      'approval': false,
      // don't change // Initialize false unconditionally
      'lang_exp': [],
      // have to change
      'work_exp': [],
      // have to change
      'userlist': [],
      // don't change // people who apply to this position, after apply, then update this field
      'writerId': FirebaseAuth.instance.currentUser.uid,
    }).then((value) {
      return FirebaseFirestore.instance
          .collection('post')
          .doc(value.id)
          .collection('apply')
          .add({});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add page"),
        backgroundColor: Color(0xFF01579B),
      ),
      body: Container(
        padding: EdgeInsets.all(100.0),
        child: ListView(
          children: [
            /*TextField(
              controller: _nameController,  // have to change, if necessary
              decoration: InputDecoration(
                filled: false,
                labelText: 'Your Name',
              ),
            ),*/
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _divisionController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Division',
              ),
            ),
            TextField(
              controller: _branchController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Branch',
              ),
            ),
            /* TextField(
              controller: _dutyController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Duty Station',
              ),
            ),*/
            // Level
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                    value: 1,
                    groupValue: levelId,
                    onChanged: (val) {
                      setState(() {
                        levelId = 1;
                      });
                    }),
                Text('level 1', style: new TextStyle(fontSize: 17.0)),
                Radio(
                    value: 2,
                    groupValue: levelId,
                    onChanged: (val) {
                      setState(() {
                        levelId = 2;
                      });
                    }),
                Text('level 2', style: new TextStyle(fontSize: 17.0)),
                Radio(
                    value: 3,
                    groupValue: levelId,
                    onChanged: (val) {
                      setState(() {
                        levelId = 3;
                      });
                    }),
                Text('level 3', style: new TextStyle(fontSize: 17.0)),
                Radio(
                    value: 4,
                    groupValue: levelId,
                    onChanged: (val) {
                      setState(() {
                        levelId = 4;
                      });
                    }),
                Text('level 4', style: new TextStyle(fontSize: 17.0)),
                Radio(
                    value: 5,
                    groupValue: levelId,
                    onChanged: (val) {
                      setState(() {
                        levelId = 5;
                      });
                    }),
                Text('level 5', style: new TextStyle(fontSize: 17.0)),
                Radio(
                    value: 6,
                    groupValue: levelId,
                    onChanged: (val) {
                      setState(() {
                        levelId = 6;
                      });
                    }),
                Text('level 6', style: new TextStyle(fontSize: 17.0)),
              ],
            ),
            ElevatedButton(
              child: Text("Post"),
              onPressed: () async {
                String duty;
                String name;
                int posNum;

                final r =
                FirebaseFirestore.instance.collection('users').snapshots();
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .get()
                    .then((value) {
                  duty = value['duty_station'];
                  name = "${value['last_name']} ${value['first_name']}";
                  posNum = value['position_level'];
                });

                addPosition(duty, name, posNum);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StaffDetail extends StatefulWidget {
  final doc;

  StaffDetail({@required this.doc});

  @override
  StaffDetailState createState() => StaffDetailState();
}

class StaffDetailState extends State<StaffDetail> {
  bool join = false;
  bool _isIncluding = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('post')
          .doc(widget.doc.id)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Detail"),
            actions: (widget.doc.get('writerId') ==
                FirebaseAuth.instance.currentUser.uid)
                ? <Widget>[
              IconButton(
                icon: Icon(Icons.edit), // edit button
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaffEdit(doc: widget.doc),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('post')
                      .doc(widget.doc.id)
                      .delete();
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

class StaffEdit extends StatefulWidget {
  final doc;

  StaffEdit({@required this.doc});

  @override
  _StaffEditState createState() => _StaffEditState();
}

class _StaffEditState extends State<StaffEdit> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _divisionController = TextEditingController();
  TextEditingController _branchController = TextEditingController();
  TextEditingController _dutyController = TextEditingController();

  Future<void> updatePosition() {
    return FirebaseFirestore.instance
        .collection('post')
        .doc(widget.doc.id)
        .update({
      'Title': _titleController.text,
      // 'Name' : _nameController.text,
      'Division': _divisionController.text,
      'Branch': _branchController.text,
      'Duty station': _dutyController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    _nameController..text = widget.doc['Name'];
    _titleController..text = widget.doc['Title'];
    _divisionController..text = widget.doc['Division'];
    _dutyController..text = widget.doc['Duty station'];
    _branchController..text = widget.doc['Branch'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit the position"),
      ),
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _divisionController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Division',
              ),
            ),
            TextField(
              controller: _branchController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Branch',
              ),
            ),
            TextField(
              controller: _dutyController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Duty Station',
              ),
            ),
            TextButton(
              child: Text("Edit"),
              onPressed: () {
                updatePosition();
              },
            )
          ],
        ),
      ),
    );
  }
}

class ApplyPage extends StatefulWidget {
  final docId;

  ApplyPage({@required this.docId});

  @override
  ApplyState createState() => ApplyState();
}

class ApplyState extends State<ApplyPage> {
  // PHP.pdf
  // TextEditingController

  // Add or update userID and user info into collection('post').doc(docId).collection('apply')

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("Have to change here"),
      ],
    );
  }
}