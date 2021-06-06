import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StaffAdd extends StatefulWidget{
  @override
  StaffAddState createState() => StaffAddState();
}

class StaffAddState extends State<StaffAdd>{
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _divisionController = TextEditingController();
  final _branchController = TextEditingController();
  final _workControl = TextEditingController();
  final _langControl = TextEditingController();

  File _postPhoto;
  final _picker = ImagePicker();
  String _filename = "";
  String _photoDefault = "https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/post%20photo%2F%ED%9A%8C%EC%83%89%EC%B9%B4%EB%A9%94%EB%9D%BC.PNG?alt=media&token=313d9221-433d-42e5-92aa-d0c57252ab7c";

  Future<DocumentReference> addPosition(String duty, String name, int posNum, String photo) {
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
      'photoURL': (photo != "") ? photo : _photoDefault,
    });
  }

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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF01579B),
          centerTitle: true,
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
            Container(
              child: Row(
                children: [
                  Text("Position photo ", ),
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
            SizedBox(height:10.0),
            Center(
              child: ElevatedButton(
                child: Text("Post"),
                onPressed: () async{
                  String duty;
                  String name;
                  int posNum;

                  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) {
                    duty = value['duty_station'];
                    name = "${value['last_name']} ${value['first_name']}";
                    posNum = value['position_level'];
                  });
                  String url = "";
                  if(_filename != ""){
                    url = await _uploadImage();
                  }

                  addPosition(duty, name, posNum, url);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}