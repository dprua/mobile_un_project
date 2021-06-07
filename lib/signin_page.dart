import 'package:flutter/material.dart';
import 'firebase_provider.dart';
import 'signup_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SignInPageState pageState;

class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() {
    pageState = SignInPageState();
    return pageState;
  }
}

class SignInPageState extends State<SignInPage> {
  TextEditingController _mailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  bool doRemember = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void initState() {
    super.initState();
    getRememberInfo();
  }

  @override
  void dispose() {
    setRememberInfo();
    _mailCon.dispose();
    _pwCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: Column(
              children: <Widget>[
                //Header
                Container(
                  margin: const EdgeInsets.only(left: 0, right: 0, top: 30),
                  height: 150,
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: 600,
                  decoration: BoxDecoration(color: Colors.lightBlue),
                  child: Center(
                    child: Text(
                      "Sign In to Your Account",
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
          // Remember Me
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 335),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: doRemember,
                  onChanged: (newValue) {
                    setState(() {
                      doRemember = newValue;
                    });
                  },
                ),
                Text(
                    "Remember Me",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          // Sign In Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 335, vertical: 10),
            child: RaisedButton(
              color: Colors.indigo[300],
              child: Text(
                "SIGN IN",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode()); // 키보드 감춤
                _signIn();
              },
            ),
          ),
          SizedBox(height: 10,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Need an account?",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15)),
                FlatButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.deepOrange, fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _signIn() async {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-In...")
          ],
        ),
      ));
    bool result = await fp.signInWithEmail(_mailCon.text, _pwCon.text);
    _scaffoldKey.currentState.hideCurrentSnackBar();
    if (result == false) showLastFBMessage();
  }

  getRememberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool("doRemember") ?? false);
    });
    if (doRemember) {
      setState(() {
        _mailCon.text = (prefs.getString("userEmail") ?? "");
        _pwCon.text = (prefs.getString("userPasswd") ?? "");
      });
    }
  }

  setRememberInfo() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("doRemember", doRemember);
    if (doRemember) {
      prefs.setString("userEmail", _mailCon.text);
      prefs.setString("userPasswd", _pwCon.text);
    }
  }

  showLastFBMessage() {
    print("ADSGWEG");
    _scaffoldKey.currentState..hideCurrentSnackBar()..showSnackBar(SnackBar(
      backgroundColor: Colors.red[400],
      duration: Duration(seconds: 10),
      content: Text("Please check ID / PW"),
      action: SnackBarAction(
        label: "Done",
        textColor: Colors.white,
        onPressed: () {},
      ),
    ));
  }

}