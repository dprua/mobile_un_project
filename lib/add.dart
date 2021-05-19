import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newPriceCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();
  PickedFile _imageFile;
  File _image;
  String url = "";

  dynamic _pickImageError;

  final ImagePicker _picker = ImagePicker();

  Future<DocumentReference> createDoc(String name, int price, String desc, String url) {

    return FirebaseFirestore.instance.collection('post').add({
      'create_time': FieldValue.serverTimestamp(),
      'desc': desc,
      'url':url,
      'heartsinfo':[],
      'modified_time': FieldValue.serverTimestamp(),
      'name': name,
      'price': price,
      'uid': FirebaseAuth.instance.currentUser.uid,
    });
  }

  Future<String> uploadFile(File _image) async {
    String fileName = _image.path.split('/').last;
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('image/'+ fileName);
    UploadTask uploadTask = storageReference.putFile(_image);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    print('File Uploaded');

    return imageUrl;
  }

  void _uploadImageToStorage(ImageSource source) async {
    File image = File(await ImagePicker().getImage(source: source).then((pickedFile) => pickedFile.path));

    if (image == null) return;
    setState(() {
      _image = image;
      print(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,

      appBar: AppBar(
        leadingWidth: 70,
        leading: TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text('Add'),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            onPressed: () async {
              if (_newDescCon.text.isNotEmpty &&
                  _newNameCon.text.isNotEmpty &&
                  _newPriceCon.text.isNotEmpty&&
                  _image != null) {
                url = await uploadFile(_image);
                createDoc(_newNameCon.text, int.parse(_newPriceCon.text), _newDescCon.text, url);
              }
              else{
                print("Add Faild");
              }
              _newNameCon.clear();
              _newDescCon.clear();
              _newPriceCon.clear();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 150,
                height: 300,
                child: (_image != null) ? Image.file(_image) : Image.network(
                  "https://handong.edu/site/handong/res/img/logo.png",
                  fit: BoxFit.fitWidth,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.photo_camera),
                      onPressed: () {
                        _uploadImageToStorage(ImageSource.gallery);
                      },
                    ),

                  ),
                ],
              ),
              Container(
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(labelText: "Product Name"),
                      controller: _newNameCon,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Price"),
                      controller: _newPriceCon,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Description"),
                      controller: _newDescCon,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}