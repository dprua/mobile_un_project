import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:un_project/STF/stfpage.dart';

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
  TextEditingController _workController = TextEditingController();
  TextEditingController _langController = TextEditingController();


  Future<void> updatePosition(){
    return FirebaseFirestore.instance.collection('post').doc(widget.doc.id)
        .update({
      'Name' : _nameController.text,
      'Title' : _titleController.text,
      'Division' : _divisionController.text,
      'Branch': _branchController.text,
      'Duty station' : _dutyController.text,
      'work_exp': _workController.text.split('\n'),
      'lang_exp': _langController.text.split('\n'),
    });
  }

  @override
  Widget build(BuildContext context){
    _nameController..text=widget.doc['Name'];
    _titleController..text=widget.doc['Title'];
    _divisionController..text=widget.doc['Division'];
    _dutyController..text=widget.doc['Duty station'];
    _branchController..text=widget.doc['Branch'];
    _workController..text = widget.doc['work_exp'].join('\n');
    _langController..text = widget.doc['lang_exp'].join('\n');

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
            TextField(
              maxLines: null,
              controller: _workController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Work Description',
              ),
            ),
            TextField(
              maxLines: null,
              controller: _langController,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Languages Description',
              ),
            ),
            TextButton(
              child: Text("Edit"),
              onPressed: (){
                updatePosition();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context)=>StfPage()),(Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}