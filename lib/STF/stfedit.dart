import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
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
  String url = "";
  String _filename = "";
  bool flag = false;

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
    if(flag){
      return FirebaseFirestore.instance.collection('post').doc(widget.doc.id)
          .update({
        'Name' : _nameController.text,
        'Title' : _titleController.text,
        'Division' : _divisionController.text,
        'Branch': _branchController.text,
        'Duty station' : _dutyController.text,
        'work_exp': _workController.text.split('\n'),
        'lang_exp': _langController.text.split('\n'),
        'photoURL' : url,
      });
    }
    else{
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
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new NetworkImage("https://www.advanced-workplace.com/wp-content/uploads/2015/04/Transition-Planning.jpg"),
                fit: BoxFit.cover
            ),
          ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                  child: Text(
                    "Edit Form",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 37,
                    ),
                  )
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Container(
                  height: 700,
                  width: 800,
                  child: Opacity(
                    opacity: 0.93,
                    child: Container(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                        child: ListView(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Position photo ", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                                  TextButton(
                                    child: Text("File", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                                    onPressed: () async{
                                      _photoPicker();
                                      flag = true;
                                    },
                                  ),
                                  Container(
                                    child: (_filename != "")
                                        ? Text("\t$_filename will be updated", style: TextStyle(color: Colors.indigo,fontSize: 17.0,fontWeight: FontWeight.bold))
                                        : Text("\tDefault photo will be updated", style: TextStyle(color: Colors.brown,fontSize: 17.0,fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              controller: _nameController,
                              style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: false,
                                labelText: 'Name',
                                labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextField(
                              controller: _titleController,
                              style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: false,
                                labelText: 'Title',
                                labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextField(
                              controller: _divisionController,
                              style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: false,
                                labelText: 'Division',
                                labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextField(
                              controller: _branchController,
                              style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: false,
                                labelText: 'Branch',
                                labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextField(
                              controller: _dutyController,
                              style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: false,
                                labelText: 'Duty Station',
                                labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)
                              ),
                            ),
                            TextField(
                              maxLines: null,
                              controller: _workController,
                              style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: false,
                                labelText: 'Work Description',
                                labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextField(
                              maxLines: null,
                              controller: _langController,
                              style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: false,
                                labelText: 'Languages Description',
                                labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: ElevatedButton(
                                    child: Text("Edit"),
                                    onPressed: () async {
                                      if(flag)
                                        url = await _uploadImage();
                                      await updatePosition();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(width: 150,),
                                Center(
                                  child: ElevatedButton(
                                    child: Text("Delete Position"),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.redAccent),
                                    ),
                                    onPressed: (){
                                      FirebaseFirestore.instance.collection('post').doc(widget.doc.id).delete();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}