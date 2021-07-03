import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';

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
  String ddtt = 'Human Rights Officer';
  String level = 'P-1';

  enrolluser(String gender, String title, String level) {
    return FirebaseFirestore.instance.collection('users').doc(cur_uid).set({
      'duty_station': _dutyController.text,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'gender': gender,
      'nationality': _nationalityController.text,
      'position_level': level,
      'position_title': title,
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
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                width: 600,
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
                width: 600,
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
                            hintText: 'Enter your Current Duty Station',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your Current Duty Station';
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 13,),
                            Icon(Icons.home_repair_service_outlined),
                            SizedBox(width: 13,),
                            Text(
                              "Current Position Title : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              child: DropdownButton<String>(
                                value: ddtt,
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
                                    ddtt = newValue;
                                  });
                                },
                                items: <String>['Human Rights Officer', 'Information Systems Officer','Programme Management Officer', 'Legal Officer']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 3,
                          height: 5,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 160,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 20,),
                                Text(
                                  "Level : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  child: DropdownButton<String>(
                                    value: level,
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
                                        level = newValue;
                                      });
                                    },
                                    items: <String>['P-1', 'P-2','P-3']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
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
                        await enrolluser(dropdownValue, ddtt,level);
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