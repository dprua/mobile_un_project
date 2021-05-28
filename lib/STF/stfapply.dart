import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:un_project/STF/stfpage.dart';
import 'package:file_picker/file_picker.dart';

class ApplyPage extends StatefulWidget{
  final doc;
  final applyId;
  ApplyPage({@required this.doc, @required this.applyId});
  @override
  ApplyState createState() => ApplyState();
}

class ApplyState extends State<ApplyPage>{
  // PHP file
  File php;
  String filename = "";
  // TextEditingController
  TextEditingController _idControl = TextEditingController(); // ID? // email?
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _nationControl = TextEditingController();
  TextEditingController _curtitleControl = TextEditingController();
  TextEditingController _curdutyControl = TextEditingController();
  TextEditingController _curlevelControl = TextEditingController();

  Future<void> phpPicker() async{
    final result = await FilePicker.platform.pickFiles();
    setState(() {
      if(result != null){
        php = File(result.files.single.path);
        filename = result.files.first.name;
      }else{
        print('No file selected');
      }
    });

  }
  _uploadPHP() async{
    Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('resume/'+ filename);
    UploadTask uploadTask = storageReference.putFile(php);
    var phpUrl = await (await uploadTask).ref.getDownloadURL();
    return phpUrl;
  }

  _updatePHPtoUsers(String url){
    return FirebaseFirestore.instance
        .collection('users').doc(widget.applyId).update({
      'resume_url' : url,
    });
  }

  applyAdd(String url) async {
    // have to change
    Future<DocumentSnapshot> userDocSnap = FirebaseFirestore.instance
        .collection('users').doc(widget.applyId).get();
    DocumentSnapshot userDoc = await userDocSnap;

    return FirebaseFirestore.instance.collection('post').doc(widget.doc.id)
        .collection('apply').doc(widget.applyId)
        .set({
      'phpURL': url, // have to change, update
      'name': _nameControl.text, // I don't know...
      'Gender': userDoc['gender'], // user info
      'Nation': _nationControl.text, // user info, can change
      'curPostTitle': _curtitleControl.text, // user info, can change?
      'curPostLevel': int.tryParse(_curlevelControl.text), // user info, can change?
      'curDutyStat': _curdutyControl.text, // user info, can change?
    });
  }
  showAlertDialog(BuildContext context, String postTitle) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apply'),
          content: Text(
              "Are you sure you want to apply on the position [${postTitle}] ?"),
          actions: <Widget>[

            ElevatedButton(
              child: Text('Okay'),
              onPressed: () async{
                String url = await _uploadPHP();   // Storage upload
                _updatePHPtoUsers(url);
                applyAdd(url);

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context)=>StfPage()),(Route<dynamic> route) => false);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Add or update userID and user info into collection('post').doc(docId).collection('apply')
  @override
  Widget build(BuildContext context){

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.applyId)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          _idControl..text = widget.applyId;
          _curtitleControl..text = snapshot.data['position_title'];
          _curdutyControl..text = snapshot.data['duty_station'];
          _curlevelControl..text = "${snapshot.data['position_level']}";
          return Container(
            padding: EdgeInsets.all(30.0),
            child: ListView(
              children: [

                Container(
                  child: Row(
                    children: [
                      Text("Upload your PHP"),
                      TextButton(
                        child: Text("File"),
                        onPressed: () async{
                          phpPicker();
                        },
                      ),
                      (filename != "")
                          ? Text(filename)
                          : Text("No file selected"),
                    ],
                  ),
                ),

                TextField(
                  controller: _idControl,
                  decoration: InputDecoration(
                    filled: false,
                    labelText: 'ID#',
                  ),
                ),
                TextField(
                  controller: _nameControl,
                  decoration: InputDecoration(
                    filled: false,
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: _nationControl,
                  decoration: InputDecoration(
                    filled: false,
                    labelText: 'Nation',
                  ),
                ),
                TextField(
                  controller: _curtitleControl,
                  decoration: InputDecoration(
                    filled: false,
                    labelText: 'Current Position',
                  ),
                ),
                TextFormField(
                  controller: _curlevelControl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: false,
                    labelText: 'Current Position Level',
                  ),
                ),
                TextField(
                  controller: _curdutyControl,
                  decoration: InputDecoration(
                    filled: false,
                    labelText: 'Current Duty Station',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        _nationControl.clear();
                        _nameControl.clear();
                        _curtitleControl.clear();
                        _curdutyControl.clear();
                        _curlevelControl.clear();
                      },
                    ),
                    ElevatedButton(
                      child: Text("Apply"),
                      onPressed: () async{
                        showAlertDialog(context, widget.doc.get('Title'));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}
