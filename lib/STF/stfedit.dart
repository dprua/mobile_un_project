import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffEdit extends StatefulWidget{
  final doc;
  StaffEdit({@required this.doc});
  @override
  _StaffEditState createState() => _StaffEditState();
}

class _StaffEditState extends State<StaffEdit>{
  TextEditingController _nameController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _divisionController = TextEditingController();
  TextEditingController _branchController = TextEditingController();
  TextEditingController _dutyController = TextEditingController();

  Future<void> updatePosition(){
    return FirebaseFirestore.instance.collection('post').doc(widget.doc.id)
        .update({
      'Title' : _titleController.text,
      // 'Name' : _nameController.text,
      'Division' : _divisionController.text,
      'Branch': _branchController.text,
      'Duty station' : _dutyController.text,
    });
  }

  @override
  Widget build(BuildContext context){
    _nameController..text=widget.doc['Name'];
    _titleController..text=widget.doc['Title'];
    _divisionController..text=widget.doc['Division'];
    _dutyController..text=widget.doc['Duty station'];
    _branchController..text=widget.doc['Branch'];

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
              onPressed: (){
                updatePosition();
              },
            )
          ],
        ),
      ),
    );
  }
}