import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  final doc;
  //final Set<Product> saved;

  // In the constructor, require a Todo.
  EditScreen({Key key, @required this.doc}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _saved = <String>{};
  File _image;
  var new_url;
  final picker = ImagePicker();
  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newPriceCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection('post');

  Future<void> updateDoc(String docId) async {
    return ref
        .doc(docId)
        .update({
          'name': _newNameCon.text,
          'price': int.parse(_newPriceCon.text),
          'desc' : _newDescCon.text,
          'modified_time': await FieldValue.serverTimestamp(),
          'url' :  (_image != null) ? new_url : widget.doc['url'],
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  getGalleryImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  // void _uploadImageToStorage(ImageSource source) async {
  //   File image = File(await ImagePicker().getImage(source: source).then((pickedFile) => pickedFile.path));
  //
  //   if (image == null) return;
  //   setState(() {
  //     _image = image;
  //     print(_image);
  //   });
  // }

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

  @override
  Widget build(BuildContext context) {

    var price = widget.doc['price'];
    List len = widget.doc['heartsinfo'];
    var le = len.length;

    _newNameCon..text = widget.doc["name"];
    _newPriceCon..text = '$price';
    _newDescCon..text = widget.doc["desc"];
    timeDilation = 1.0; // 1.0 means normal animation speed.

    // Use the Todo to create the UI.
    return Scaffold(
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
          title: Text('Edit'),
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
                    _newPriceCon.text.isNotEmpty) {
                  if(_image != null){
                    new_url = await uploadFile(_image);
                    print(new_url);
                  }
                  await updateDoc(widget.doc.id);
                }
                else{
                  print("Edit Faild");
                }
                _newNameCon.clear();
                _newDescCon.clear();
                _newPriceCon.clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (_image != null) ? Image.file(_image) : Image.network(
                widget.doc["url"],
                width: 600,
                height: 240,
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      getGalleryImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(60.0,30.0,60.0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      autofocus: true,
                      controller: _newNameCon,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                      child:
                      TextField(
                        controller: _newPriceCon,
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.blue
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _newDescCon,
                      style: TextStyle(
                          color: Colors.blue
                      ),
                    ),
                    /*
                    SizedBox(
                      height: 120,
                    ),
                    Row(
                      children: [
                        Text(
                          "creator : ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          widget.doc["uid"],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          widget.doc["create_time"],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          " Created",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          widget.doc["modified_time"],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          " Modified",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                     */
                  ],
                ),
              ),

            ],
          ),
        )

    );

  }
}