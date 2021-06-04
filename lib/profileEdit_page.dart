import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentification.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';

class ProfileEditPage extends StatefulWidget {
  final doc;

  ProfileEditPage({Key key, @required this.doc}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();

}
//final _sigInFormKey = GlobalKey<FormState>();
class _ProfileEditPageState extends State<ProfileEditPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _newNationCon = TextEditingController();

  TextEditingController _newDutyStatCon = TextEditingController();

  Future<void> signOut() async {
    await Authentification().signOut();
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit error!'),
          content: Text("you have to fill in the blanks!"),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateDoc(String docId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update({
      'nationality': _newNationCon.text,
      'duty_station': _newDutyStatCon.text,
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  getProfileImage() {
    if (_firebaseAuth.currentUser.photoURL != null) {
      return Image.network(_firebaseAuth.currentUser.photoURL,
          height: 300, width: 300);
    } else {
      return Image.network("https://handong.edu/site/handong/res/img/logo.png",
          height: 300, width: 300);
    }
  }

  getEmail() {
    if (_firebaseAuth.currentUser.isAnonymous != true) {
      return Text(_firebaseAuth.currentUser.email,
          style: TextStyle(fontSize: 20));
    } else {
      return Text(
        "Anonymous",
        style: TextStyle(fontSize: 20),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _newNationCon..text = widget.doc["nationality"];
    _newDutyStatCon..text = widget.doc["duty_station"];
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(4, 9, 35, 1),
                Color.fromRGBO(39, 105, 171, 1),
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check,
                  semanticLabel: 'save',
                ),
                onPressed: () async{
                  if (_newDutyStatCon.text.isNotEmpty &&
                      _newNationCon.text.isNotEmpty){
                    await updateDoc(_firebaseAuth.currentUser.uid);
                    print(_firebaseAuth.currentUser.uid);
                    Navigator.pop(context);
                  }
                  else{
                    showAlertDialog(context);
                  };
                },
              ),
            ],
            backgroundColor: Color(0xFF01579B),
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_firebaseAuth.currentUser.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData == false)
                  return CircularProgressIndicator();
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 200, vertical: 73),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'My\nEdit Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontFamily: 'Nisebuschgardens',
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Container(
                          height: height * 0.43,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double innerHeight = constraints.maxHeight;
                              double innerWidth = constraints.maxWidth;
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: innerHeight * 0.72,
                                      width: innerWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          // SizedBox(
                                          //   height: 40,
                                          //   width: 10,
                                          // ),
                                          Text(
                                            snapshot.data['first_name'],
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  39, 105, 171, 1),
                                              fontFamily: 'Nunito',
                                              fontSize: 37,
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 40,
                                          //   width: 500,
                                          // ),
                                          Text(
                                            snapshot.data['last_name'],
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  39, 105, 171, 1),
                                              fontFamily: 'Nunito',
                                              fontSize: 37,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        child: snapshot.data['gender'] == 'MALE'
                                            ? Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/character%2Fman%20char%20-%20%EB%B3%B5%EC%82%AC%EB%B3%B8.png?alt=media&token=8476c05f-cd65-4093-8468-f85cdd35df66',
                                          width: innerWidth * 0.45,
                                          fit: BoxFit.fitWidth,
                                        )
                                            : Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/character%2Fwoman%20char%20-%20%EB%B3%B5%EC%82%AC%EB%B3%B8.png?alt=media&token=07b26116-52f9-4a1c-9ffc-0835c862e994',
                                          width: innerWidth * 0.45,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: height * 0.5,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Specific information',
                                  style: TextStyle(
                                    color: Color.fromRGBO(39, 105, 171, 1),
                                    fontSize: 27,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                Divider(
                                  thickness: 2.5,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: height * 0.15,
                                    width: 800,
                                    padding:
                                    EdgeInsets.fromLTRB(250, 50, 250, 50),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: TextField(
                                      autofocus: true,
                                      controller: _newNationCon,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 27,
                                        color: Colors.black,
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: height * 0.15,
                                    width: 800,
                                    padding:
                                    EdgeInsets.fromLTRB(250, 50, 250, 50),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: TextField(
                                      autofocus: true,
                                      controller: _newDutyStatCon,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 27,
                                        color: Colors.black,
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}