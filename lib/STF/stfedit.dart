import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:un_project/STF/stfpage.dart';
import 'package:image_picker/image_picker.dart';

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

  File _postPhoto;
  final _picker = ImagePicker();
  String _filename = "";
  String _photoDefault = "https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/post%20photo%2F%ED%9A%8C%EC%83%89%EC%B9%B4%EB%A9%94%EB%9D%BC.PNG?alt=media&token=313d9221-433d-42e5-92aa-d0c57252ab7c";

  Future<void> _photoPicker() async{
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    _filename = "" ;
    setState(() {
      if(pickedFile != null){
        _postPhoto = File(pickedFile.path);
        _filename = path.basename(_postPhoto.path);
      }else{
        print('No file selected');
      }
    });
  }
  Future<String> _uploadImage() async{
    Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('post photo/'+ _filename);
    UploadTask uploadTask = storageReference.putFile(_postPhoto);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    print('File Uploaded');

    return imageUrl;
  }

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
        backgroundColor: Color(0xFF01579B),
        centerTitle: true,
        title: Text("Edit the position"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              FirebaseFirestore.instance.collection('post').doc(widget.doc.id).delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: ListView(
          children: [
            Container(
              child: Row(
                children: [
                  Text("Position photo ", style: TextStyle(fontSize: 17.0),),
                  TextButton(
                    child: Text("File", style: TextStyle(fontSize: 17.0),),
                    onPressed: () async{
                      _photoPicker();
                    },
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: (_filename != "")
                          ? Text("\t$_filename will be updated", style: TextStyle(color: Colors.blue))
                          : Text("\tDefault photo will be updated", style: TextStyle(color: Colors.brown)),
                    ),
                  ),
                ],
              ),
            ),
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

            Center(
              child: ElevatedButton(
                child: Text("Edit"),
                onPressed: (){
                  updatePosition();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context)=>StfPage()),(Route<dynamic> route) => false);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}