import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:firebase_auth/firebase_auth.dart';
import 'edit.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  final doc;
  var t = 0;
  //final Set<Product> saved;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.doc}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {
  final _saved = <String>{};
  var cur_uid = FirebaseAuth.instance.currentUser.uid;
  bool isPostLiked;
  var length;

  CollectionReference ref = FirebaseFirestore.instance.collection('post');

  deleteUser(String docId) async {
    return await ref
        .doc(docId)
        .delete()
        .then((value) => print("Doc Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  getlength() async {
    Future<DocumentSnapshot> docSnapshot = FirebaseFirestore.instance
        .collection('post').doc(widget.doc.id).get();
    DocumentSnapshot docu = await docSnapshot;
    List a = await docu.get('heartsinfo');
    return a.length;
  }

   gettime(Timestamp time) async {
    print("gettime");
    Timestamp write = time;
    DateTime wirte_time = await write.toDate();
    var format_time = DateFormat("yy.MM.dd HH:mm:ss:SS").format(wirte_time).toString();
    return format_time;
  }

  getString(int price){
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0; // 1.0 means normal animation speed.
    // var price = widget.doc['price'];
    List l = widget.doc["heartsinfo"];
    print("this");
    length = l.length + widget.t;
    print(widget.doc["modified_time"]);
    // Use the Todo to create the UI.
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore
            .instance.collection('post').doc(
            widget.doc.id).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          print("WHAT THE!!");
          if (snapshot.hasError)
            return Text("Error: ${snapshot.error}");
          if (snapshot.hasData == false )
            return CircularProgressIndicator();
          if (snapshot.hasData && !snapshot.data.exists) {
            return CircularProgressIndicator();
          }
          //try{
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasData == false) {
                  return CircularProgressIndicator();
                }
                else if (snapshot.hasData && !snapshot.data.exists) {
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
                  return Scaffold(
                      appBar: AppBar(
                        centerTitle: true,
                        title: Text("Detail"),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.create,
                              semanticLabel: 'add',
                            ),
                            onPressed: () {
                              if (snapshot.data['uid'] == cur_uid) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder:
                                      (context) =>
                                      EditScreen(doc: snapshot.data),
                                ));
                              }
                              else
                                return print("Editing Denied");
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              semanticLabel: 'add',
                            ),
                            onPressed: () async {
                              if (snapshot.data['uid'] == cur_uid) {
                                await deleteUser(widget.doc.id);
                                Navigator.pop(context);
                              }
                              else
                                return print("Deleting Denied");
                            },
                          ),
                        ],

                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              snapshot.data['url'],
                              width: 600,
                              height: 240,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  60.0, 60.0, 60.0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.thumb_up, size: 30,
                                              color: Colors.red,),
                                            onPressed: () async {
                                              Future<DocumentSnapshot> docSnapshot = FirebaseFirestore
                                                  .instance.collection('post')
                                                  .doc(
                                                  widget.doc.id)
                                                  .get();
                                              DocumentSnapshot docu = await docSnapshot;
                                              //print(docu.toString());
                                              var a = await docu.get('heartsinfo');
                                              //print(a);
                                              if (a.contains(cur_uid)) {
                                                isPostLiked = true;
                                              } else {
                                                isPostLiked = false;
                                              }
                                              if (isPostLiked) {
                                                //너 이미 좋아요 눌렀어 스낵바
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'You can only do it once !!'),
                                                  ),
                                                );
                                                print(
                                                    "You can only do it once !!");
                                              }
                                              else {
                                                print("I LIKE IT!");
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('I LIKE IT!'),
                                                  ),
                                                );
                                                //I LIKE IT! 스낵배
                                                await ref.doc(widget.doc.id).update({
                                                  'heartsinfo': FieldValue
                                                      .arrayUnion([cur_uid])
                                                });
                                                //doc[heartsinfo]에 cur_uid append하고
                                                //숫자 바꿔줘야하니 그냥 length + 1 해버리자 이걸 setstate()
                                                //setState(() {});
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          FutureBuilder(
                                              future: getlength(),
                                              builder: (BuildContext context, AsyncSnapshot snapshot1) {
                                                if (snapshot1.hasData == false) {
                                                  return CircularProgressIndicator();
                                                }
                                                //error가 발생하게 될 경우 반환하게 되는 부분
                                                else if (snapshot1.hasError) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: Text(
                                                      'Error: ${snapshot1.error}',
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  );
                                                }
                                                else {
                                                  return Text(
                                                    //formatter.format(product.locate),
                                                    snapshot1.data.toString(),
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        color: Colors.red
                                                    ),
                                                  );
                                                }
                                              }
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 0.0,
                                        0.0, 0.0),
                                    child: Text(
                                      //formatter.format(product.locate),
                                      "\$ " + getString(snapshot.data["price"]),
                                      style: TextStyle(
                                          fontSize: 23,
                                          color: Colors.blue
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    height: 1.0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data['desc'],
                                    style: TextStyle(
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(
                                    height: 120,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "creator : ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data['uid'],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  FutureBuilder(
                                    future: gettime(snapshot.data["create_time"]),
                                    builder: (BuildContext context, AsyncSnapshot snapshot1) {
                                      if (snapshot.hasData == false) {
                                        return CircularProgressIndicator();
                                      }
                                      //error가 발생하게 될 경우 반환하게 되는 부분
                                      else if (snapshot1.hasError) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Error: ${snapshot1.error}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        );
                                      }
                                      else {
                                        return Row(
                                          children: [
                                            Text(
                                              snapshot1.data.toString(),
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
                                        );
                                      }
                                    }
                                  ),
                                  FutureBuilder(
                                      future: gettime(snapshot.data["modified_time"]),
                                      builder: (BuildContext context, AsyncSnapshot snapshot1) {
                                        if (snapshot.hasData == false) {
                                          return CircularProgressIndicator();
                                        }
                                        //error가 발생하게 될 경우 반환하게 되는 부분
                                        else if (snapshot1.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Error: ${snapshot1.error}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          );
                                        }
                                        else {
                                          return Row(
                                            children: [
                                              Text(
                                                snapshot1.data.toString(),
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
                                          );
                                        }
                                      }
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      )

                  );
                }
          }
          // }catch (e){
          //   print("Error : $e");
          // }
        }

    );
  }
}