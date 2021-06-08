import 'package:flutter/material.dart';
import 'firebase_provider.dart';
import 'package:provider/provider.dart';

SignUpPageState pageState;

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() {
    pageState = SignUpPageState();
    return pageState;
  }
}

class SignUpPageState extends State<SignUpPage> {
  TextEditingController _mailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void dispose() {
    _mailCon.dispose();
    _pwCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (fp == null) {
      fp = Provider.of<FirebaseProvider>(context);
    }

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage("https://www.softwareone.com/-/media/global/social-media-and-blog/hero/publisher-advisory_get-ready-for-the-office-2010-end-of-support-header.jpg?rev=5496ff43323143be831b8a7922711cf2&sc_lang=en-fi&hash=A250C8730555358AEFE638574FCA0AF4"),
              fit: BoxFit.cover
            ),
          ),
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 150, 0, 30),
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
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: <Widget>[
                        //Header
                        Container(
                          height: 50,
                          width: 600,
                          decoration: BoxDecoration(color: Colors.lightBlue),
                          child: Center(
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        // Input Area
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
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: _mailCon,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              TextField(
                                controller: _pwCon,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ].map((c) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: c,
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  // Sign Up Button
                  Container(
                    width: 600,
                    margin: const EdgeInsets.symmetric(horizontal: 335, vertical: 10),
                    child: RaisedButton(

                      color: Colors.indigo[300],
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        FocusScope.of(context)
                            .requestFocus(new FocusNode()); // 키보드 감춤
                        _signUp();
                      },
                    ),
                  ),
                  Container(
                    width: 600,
                    margin: const EdgeInsets.symmetric(horizontal: 335, vertical: 10),
                    child: RaisedButton(

                      color: Colors.red[300],
                      child: Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void _signUp() async {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-Up...")
          ],
        ),
      ));
    bool result = await fp.signUpWithEmail(_mailCon.text, _pwCon.text);
    //_scaffoldKey.currentState.hideCurrentSnackBar();
    if (result) {
      Navigator.pop(context);
    } else {
      print("RESUTL FALSE");

      showLastFBMessage();
    }
  }

  showLastFBMessage() {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 10),
        content: Text(fp.getLastFBMessage()),
        action: SnackBarAction(
          label: "Done",
          textColor: Colors.white,
          onPressed: () {},
        ),
      ));
  }
}