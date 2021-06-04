import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffAdd extends StatefulWidget{
  @override
  StaffAddState createState() => StaffAddState();
}

class StaffAddState extends State<StaffAdd>{
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
      'Title': _titleController.text,  // have to change
      'approval': false,  // don't change // Initialize false unconditionally
      'lang_exp': _langControl.text.split('\n'),
      'work_exp': _workControl.text.split('\n'),
      'writerId': FirebaseAuth.instance.currentUser.uid,
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
              maxLines: null,
              controller: _workControl,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Work Description',
              ),
            ),
            Text("Please separate description list with enter", style: TextStyle(color: Colors.redAccent)),
            TextField(
              maxLines: null,
              controller: _langControl,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Language Description',
              ),
            ),
            Text("Please separate description list with enter", style: TextStyle(color: Colors.redAccent)),
            SizedBox(height:10.0),
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