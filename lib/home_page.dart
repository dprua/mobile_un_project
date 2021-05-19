import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'authentification.dart';
import 'add.dart';
import 'detail.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = 'ASC';
  var flag;


  Future<DocumentReference> addMessagePost(String name, int price, String image_name, String desc) {

    return FirebaseFirestore.instance.collection('post').add({
      'create_time': DateFormat("yy.MM.dd HH:mm:ss:SS").format(DateTime.now()).toString(),
      'desc': desc,
      'url':image_name,
      'heartsinfo':[],
      'modified_time': DateFormat("yy.MM.dd HH:mm:ss:SS").format(DateTime.now()).toString(),
      'name': name,
      'price': price,
      'uid': FirebaseAuth.instance.currentUser.uid,
    });
  }

  Future<void> downloadURLExample(image) async {
    String downloadURL = await FirebaseStorage.instance
        .ref(image)
        .getDownloadURL();

    // Within your widgets:
    // Image.network(downloadURL);
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    //Reference reference  storage.ref().child();


    /*
    addMessagePost('iphone', 600, 'image/iphone.png', 'This is IPhone.');
    addMessagePost('airpod', 220, 'image/airpod.png', 'This is airpod.');
    addMessagePost('applewatch', 450, 'image/applewatch.png', 'This is applewatch.');
    addMessagePost('imac', 1220, 'image/imac.png', 'This is IMac.');
    addMessagePost('ipad', 500, 'image/ipad.png', 'This is IPad.');
    addMessagePost('macbook', 980, 'image/macbook.png', 'This is MacBook.');

     */
    if(dropdownValue == "ASC"){
      flag = false;
    }
    else{
      flag = true;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.person,
            semanticLabel: 'profile',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        centerTitle: true,
        title: Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              semanticLabel: 'add',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
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
            items: <String>['ASC', 'DESC']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: Container(
              height: 600,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('post').orderBy('price', descending: flag).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData == false)
                    return CircularProgressIndicator();
                  if (snapshot.hasError)
                    return Text("Error: ${snapshot.error}");
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Loading...");
                    default:
                      return GridView.count(
                          crossAxisCount: 2,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            if (snapshot.hasData == false) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasData && !document.exists) {
                              return CircularProgressIndicator();
                            }
                            else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }
                            else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: <Widget>[
                                        AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Image.network(
                                              document['url'],
                                              fit: BoxFit.fitWidth,
                                            )
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 8.0, 0.0, 3.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                document["name"],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 0.0, 0.0, 0.0),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '\$' +
                                                  document["price"].toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .end,
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 30,
                                                child: TextButton(
                                                    child: Text(
                                                      'more', style: TextStyle(
                                                        fontSize: 12),),
                                                    onPressed: () {
                                                      print(document['price']);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailScreen(doc: document),
                                                        ),
                                                      );
                                                    }
                                                ),
                                              ),
                                            ]
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          ).toList()
                      );
                  }
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}


/*
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: signOut,
          child: Text("Log out"),
        ),
      ),
    );
  }

}
 */