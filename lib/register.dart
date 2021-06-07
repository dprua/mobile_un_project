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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width:  MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new NetworkImage("https://www.softwareone.com/-/media/global/social-media-and-blog/hero/publisher-advisory_get-ready-for-the-office-2010-end-of-support-header.jpg?rev=5496ff43323143be831b8a7922711cf2&sc_lang=en-fi&hash=A250C8730555358AEFE638574FCA0AF4"),
                fit: BoxFit.cover
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 0, right: 0, top: 30),
                height: 250,
                width: MediaQuery.of(context).size.width-560,
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                spreadRadius: 5,
                                blurRadius: 160,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/UN_emblem_blue.svg/512px-UN_emblem_blue.svg.png",
                              height: 100,
                              width: 175
                          ),
                        ),
                        Text(
                          "HR Relocation System",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.white,
                                  offset: Offset(5.0,5.0),
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width-560,
                decoration: BoxDecoration(color: Colors.lightBlue),
                child: Center(
                  child: Text(
                    "Enter your Personal Information",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width-560,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 5,
                      blurRadius: 160,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.drive_file_rename_outline),
                            hintText: 'Enter your First name',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your First name to continue';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.drive_file_rename_outline),
                            hintText: 'Enter your Last name',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your Last name to continue';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _dutyController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.home_work_outlined),
                            hintText: 'Enter your Duty Station',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your Duty Station';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.subtitles_sharp),
                            hintText: 'Enter your Position Title',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your Position Title';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _nationalityController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.assignment_ind_rounded),
                            hintText: 'Enter your Nationality',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your nationality';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            SizedBox(width: 230,),
                            Row(
                              children: [
                                Text(
                                  "Gender : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
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
                                        child: Text(value,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "Level : ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  DropdownButton<int>(
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
                                    items: <int>[1, 2, 3, 4, 5, 6]
                                        .map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    textColor: Colors.red,
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                    onPressed: () {
                      fp.signOut();
                    },
                  ),
                  FlatButton(
                    textColor: Color(0xFF1A237E),
                    child: Text(
                      'CONFIRM',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        final FirebaseAuth fAuth = FirebaseAuth.instance;
                        await enrolluser(dropdownValue, level);
                        fp.setUser(fAuth.currentUser);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}