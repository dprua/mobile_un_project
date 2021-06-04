import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'home_page.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  FirebaseProvider fp;
  var cur_uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _nationalityController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dutyController = TextEditingController();
  final _titleController = TextEditingController();
  String dropdownValue = 'MALE';

  //position level, gender,
  int level = 1;

  enrolluser(String gender, int level) {
    return FirebaseFirestore.instance.collection('users').doc(cur_uid).set({
      'duty_station': _dutyController.text,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'gender': gender,
      'nationality': _nationalityController.text,
      'position_level': level,
      'position_title': _titleController.text,
      'resume_url': ' ',
      'user_type': 2,
    });
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    print("HERRRRRRRRR:)");
    return Scaffold(
      appBar: AppBar(
        title: Text("Register In Page"),
        centerTitle: true,
        backgroundColor: Color(0xFF01579B),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back_rounded,
        //   ),
        //   onPressed: () async {
        //     Navigator.pop(context, true);
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          //margin: const EdgeInsets.symmetric(horizontal: 335),
          children: <Widget>[
            Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 335, vertical: 10),
                child: AspectRatio(
                  aspectRatio: 12 / 9,
                  child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/UN_emblem_blue.svg/512px-UN_emblem_blue.svg.png",
                      height: 100,
                      width: 175),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 335),
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your first name',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your first name to continue';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 335),
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your last name',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your last name to continue';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 335),
                      child: TextFormField(
                        controller: _dutyController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your duty station',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your duty station';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 335),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your position title',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your position title';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 335),
                      child: DropdownButton<int>(
                        value: level,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black12,
                        ),
                        onChanged: (int newValue) {
                          setState(() {
                            level = newValue;
                          });
                        },
                        items: <int>[1, 2, 3, 4, 5]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 335),
                      child: TextFormField(
                        controller: _nationalityController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your nationality',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your nationality';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 335),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black12,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['MALE', 'FEMALE']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          textColor: Colors.red,
                          child: Text('CANCEL'),
                          onPressed: () {
                            fp.signOut();
                          },
                        ),
                        FlatButton(
                          textColor: Color(0xFF1A237E),
                          child: Text('CONFIRM'),
                          onPressed: () async {
                            final FirebaseAuth fAuth = FirebaseAuth.instance;
                            await enrolluser(dropdownValue, level);
                            fp.setUser(fAuth.currentUser);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}