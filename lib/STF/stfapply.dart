import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _nationControl = TextEditingController();
  TextEditingController _curTitleControl = TextEditingController();
  TextEditingController _curDutyControl = TextEditingController();
  TextEditingController _curLevelControl = TextEditingController();
  TextEditingController _certControl = TextEditingController();

  bool level;
  bool catego;

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

  Future<DocumentReference> applyAdd(String url)  async{
    Future<DocumentSnapshot> userDocSnap = FirebaseFirestore.instance
        .collection('users').doc(widget.applyId).get();
    DocumentSnapshot userDoc = await userDocSnap;
    final getDocApply = await FirebaseFirestore.instance.collection('apply').where('postId', isEqualTo: widget.doc.id).get();
    final size = getDocApply.docs.length;
    final certificates = _certControl.text;

    return FirebaseFirestore.instance
        .collection('apply').add({
      'Gender': userDoc['gender'], // user info
      'Nation': _nationControl.text, // user info, can change
      'curDutyStat': _curDutyControl.text, // user info, can change?
      'curPostLevel': _curLevelControl.text, // user info, can change?
      'curPostTitle': _curTitleControl.text, // user info, can change?
      'name': _nameControl.text, // I don't know...
      'phpURL': url, // have to change, update
      'postId': widget.doc.id,
      'rank': size,
      'applyId': widget.applyId,
      'certificates': certificates.split(','),
      'certCount': certificates.split(',').length,
      'skillLev': skillLev,
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
                Navigator.pop(context);
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

  int skillLev = 1;
  final snackBarLike = SnackBar(
    content: Text('You have to upload PHP file!'),
  );


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
          _nameControl..text = snapshot.data['first_name'] +' '+ snapshot.data['last_name'];
          _nationControl..text = snapshot.data['nationality'];
          _curTitleControl..text = snapshot.data['position_title'];
          _curDutyControl..text = snapshot.data['duty_station'];
          _curLevelControl..text = "${snapshot.data['position_level']}";
          level = snapshot.data['position_level'] == widget.doc.get('Level');
          catego = snapshot.data['position_title'] == widget.doc.get('Title');
          return Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new NetworkImage("https://www.advanced-workplace.com/wp-content/uploads/2015/04/Transition-Planning.jpg"),
                  fit: BoxFit.cover
              ),
            ),
            padding: EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      child: Text(
                        "Apply Form",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 37,
                        ),
                      )
                  ),
                  SizedBox(height: 50,),
                  Container(
                    child: Opacity(
                      opacity: 0.93,
                      child: Container(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                          height: 570,
                          child: ListView(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Upload your PHP",style: TextStyle(fontWeight: FontWeight.bold),),
                                    TextButton(
                                      child: Text("File",style: TextStyle(fontWeight: FontWeight.bold)),
                                      onPressed: () async{
                                        phpPicker();
                                      },
                                    ),
                                    (filename != "")
                                        ? Text(filename,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo))
                                        : Text("No file selected",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                                  ],
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
                                controller: _curTitleControl,
                                decoration: InputDecoration(
                                  filled: false,
                                  labelText: 'Current Position',
                                ),
                              ),
                              TextFormField(
                                controller: _curLevelControl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: false,
                                  labelText: 'Current Position Level',
                                ),
                              ),
                              TextField(
                                controller: _curDutyControl,
                                decoration: InputDecoration(
                                  filled: false,
                                  labelText: 'Current Duty Station',
                                ),
                              ),
                              SizedBox(height:10.0),
                              // programming skill level
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Programming Skill", style: TextStyle(fontSize: 15.0 ,/*fontWeight: FontWeight.bold*/),),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Radio(value: 1, groupValue: skillLev,
                                            onChanged: (val) {setState(() {
                                              skillLev = 1;
                                            });}),
                                        Text('level 1', style: new TextStyle(fontSize: 15.0)),
                                        Radio(value: 2, groupValue: skillLev,
                                            onChanged: (val) {setState(() {
                                              skillLev = 2;
                                            });}),
                                        Text('level 2', style: new TextStyle(fontSize: 15.0)),
                                        Radio(value: 3, groupValue: skillLev,
                                            onChanged: (val) {setState(() {
                                              skillLev = 3;
                                            });}),
                                        Text('level 3', style: new TextStyle(fontSize: 15.0)),
                                        Radio(value: 4, groupValue: skillLev,
                                            onChanged: (val) {setState(() {
                                              skillLev = 4;
                                            });}),
                                        Text('level 4', style: TextStyle(fontSize: 15.0)),
                                        Radio(value: 5, groupValue: skillLev,
                                            onChanged: (val) {setState(() {
                                              skillLev = 5;
                                            });}),
                                        Text('level 5', style: TextStyle(fontSize: 15.0)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Your Certificates
                              TextField(
                                controller: _certControl,
                                decoration: InputDecoration(
                                  filled: false,
                                  labelText: 'Your Certificates',
                                ),
                              ),
                              Text("Please separate with ' , '", style: TextStyle(color: Colors.redAccent)),
                              (level && catego)?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: Text("Cancel",style: TextStyle(color: Colors.redAccent),),
                                    onPressed: () {
                                      _nationControl.clear();
                                      _nameControl.clear();
                                      _curTitleControl.clear();
                                      _curDutyControl.clear();
                                      _curLevelControl.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Apply"),
                                    onPressed: () async{
                                      if(filename == "")
                                        ScaffoldMessenger.of(context).showSnackBar(snackBarLike);
                                      else{
                                        await showAlertDialog(context, widget.doc.get('Title'));
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              )
                              :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: Text("You can ONLY APPLY fit your LEVEL and Position Category. Click to Exit.",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
                                    onPressed: () {
                                      _nationControl.clear();
                                      _nameControl.clear();
                                      _curTitleControl.clear();
                                      _curDutyControl.clear();
                                      _curLevelControl.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}

