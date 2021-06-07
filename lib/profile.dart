import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentification.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'profileEdit_page.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await Authentification().signOut();
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
                          'My Profile',
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
                                    top: 110,
                                    right: 20,
                                    child: IconButton(
                                      //padding: EdgeInsets.all(8.0),
                                      icon: Icon(
                                        Icons.person,
                                        color: Colors.grey[700],
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileEditPage(doc:snapshot.data)),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom:-40,
                                    child: Center(
                                      child: Container(
                                        height:500,
                                        child: snapshot.data['gender'] == 'MALE'
                                            ? Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/character%2Fman_char-removebg-preview.png?alt=media&token=986c55de-c46c-49a4-965b-4feb49360c3c',
                                          width: innerWidth * 0.35,
                                          fit: BoxFit.fitWidth,
                                        )
                                            : Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/character%2Fwoman_char-removebg-preview.png?alt=media&token=bdd9a2ab-91ea-437c-8f61-74eae8e1e5a9',
                                          width: innerWidth * 0.33,

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
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Nationality : [${snapshot.data['nationality']}]',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: height * 0.15,
                                  width: 800,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Duty Station : [${snapshot.data['duty_station']}]',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ),
                                ),
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

/*
 Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                semanticLabel: 'logout',
              ),
              onPressed: () {
                signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(80.0,0,80.0,0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        snapshot.data['gender']=='MALE'
                            ?AspectRatio(
                          aspectRatio: 12 / 9,
                          child: Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/character%2Fman%20char%20-%20%EB%B3%B5%EC%82%AC%EB%B3%B8.png?alt=media&token=8476c05f-cd65-4093-8468-f85cdd35df66",
                              height: 50,
                              width: 175),
                        )
                        :AspectRatio(
                          aspectRatio: 12 / 9,
                          child: Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/character%2Fwoman%20char%20-%20%EB%B3%B5%EC%82%AC%EB%B3%B8.png?alt=media&token=07b26116-52f9-4a1c-9ffc-0835c862e994",
                              height: 50,
                              width: 175),
                        ),
                        //SizedBox(height: 50,),
                        Text(
                          _firebaseAuth.currentUser.uid,
                          //snapshot.data['gender'],
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 25,),
                        const Divider(
                          height: 1.0,
                          color: Colors.black,
                        ),
                        SizedBox(height: 25,),
                        getEmail(),
                      ],
                    ),
                  );
                }
              ),
            )
        )
    );*/
/*
  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Provider.of(context).auth.getProfileImage(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "UID: ${FirebaseAuth.instance.currentUser.uid}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        const Divider(
          height: 1.0,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Email: ${authData.email ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

   */
}