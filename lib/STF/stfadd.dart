import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffAdd extends StatefulWidget{
  @override
  StaffAddState createState() => StaffAddState();
}

class StaffAddState extends State<StaffAdd>{
  int levelId = 1;
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _divisionController = TextEditingController();
  final _branchController = TextEditingController();
  final _dutyController = TextEditingController();
  final _workControl = TextEditingController();
  final _langControl = TextEditingController();

  Future<DocumentReference> addPosition(String duty, String name, int posNum) {
    return FirebaseFirestore.instance.collection('post').add({
      'Branch': _branchController.text,
      'Division': _divisionController.text,
      'Duty station': duty,
      'Level': posNum,
      'Name': name,
      'Post': "", // have to change  // What it is ??????????
      'Title': _titleController.text,  // have to change
      'approval': false,  // don't change // Initialize false unconditionally
      'lang_exp': [_langControl.text], // have to change
      'work_exp': [_workControl.text], // have to change
      // 'userlist': [], // don't change // people who apply to this position, after apply, then update this field
      'writerId': FirebaseAuth.instance.currentUser.uid,
    }).then((value){
      return FirebaseFirestore.instance.collection('post').doc(value.id).collection('apply').add({});
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Add page"),
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
            TextField(
              controller: _workControl,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Work Description',
              ),
            ),
            TextField(
              controller: _langControl,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Language Description',
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
                Radio(value: 1, groupValue: levelId,
                    onChanged: (val) {setState(() {
                      levelId = 1;
                    });}),
                Text('level 1', style: new TextStyle(fontSize: 17.0)),
                Radio(value: 2, groupValue: levelId,
                    onChanged: (val) {setState(() {
                      levelId = 2;
                    });}),
                Text('level 2', style: new TextStyle(fontSize: 17.0)),
                Radio(value: 3, groupValue: levelId,
                    onChanged: (val) {setState(() {
                      levelId = 3;
                    });}),
                Text('level 3', style: new TextStyle(fontSize: 17.0)),
                Radio(value: 4, groupValue: levelId,
                    onChanged: (val) {setState(() {
                      levelId = 4;
                    });}),
                Text('level 4', style: new TextStyle(fontSize: 17.0)),
                Radio(value: 5, groupValue: levelId,
                    onChanged: (val) {setState(() {
                      levelId = 5;
                    });}),
                Text('level 5', style: new TextStyle(fontSize: 17.0)),
                Radio(value: 6, groupValue: levelId,
                    onChanged: (val) {setState(() {
                      levelId = 6;
                    });}),
                Text('level 6', style: new TextStyle(fontSize: 17.0)),
              ],
            ),
            ElevatedButton(
              child: Text("Post"),
              onPressed: () async{
                String duty;
                String name;
                int posNum;

                final r = FirebaseFirestore.instance.collection('users').snapshots();
                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) {
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