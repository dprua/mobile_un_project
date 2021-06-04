import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'approval_page.dart';
import 'package:url_launcher/url_launcher.dart';

var target;

class hmDetailPage extends StatefulWidget {
  final doc;

  const hmDetailPage({
    Key key,
    @required this.doc,
  }) : super(key: key);

  @override
  _hmDetailPageState createState() => _hmDetailPageState();
}

class _hmDetailPageState extends State<hmDetailPage> {
  //String id = FirebaseAuth.instance.currentUser.uid;
  bool join = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Detail about Applicant "),
        centerTitle: true,
        backgroundColor: Color(0xFF01579B),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 600,
              child: ReorderableFirebaseList(
                //.where('postId',isEqualTo : widget.doc.id)
                collection: FirebaseFirestore.instance.collection('apply'),
                indexKey: 'rank',
                id: widget.doc.id,
                itemBuilder:
                    (BuildContext context, int index, DocumentSnapshot doc) {
                  return ListTile(
                    key: Key(doc.id),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.grey))),
                      child: Icon(Icons.person, color: Colors.grey,size:40),
                    ),
                    title: Text(
                      doc.data()['name'],
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.linear_scale, color: Colors.black),
                        Text(doc.data()['Gender'],
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right,
                        color: Colors.black, size: 30.0),
                    onTap: (){
                      print('aaaa');
                      setState(() {
                        print('bbbb');
                        join = true;
                        target = doc.id;
                        print(target);
                      });
                    },
                  );
                },
              ),
            ),
          ),
          const VerticalDivider(
            color: Colors.grey,
            thickness: 1,
            indent: 20,
            endIndent: 0,
            width: 20,
          ),
          Expanded(
            child: (join)
                ? ViewDetail(doc: widget.doc, applyId: target)
                //hmDetailInfoPage(doc:widget.doc,applyId:FirebaseAuth.instance.currentUser.uid)
                : AspectRatio(
              aspectRatio: 4 / 2,
              child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/UN_emblem_blue.svg/512px-UN_emblem_blue.svg.png",
                  height: 50,
                  width: 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    return Padding(
      key: ValueKey(data.data()['name']),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(data.data()['name']),
        subtitle: Text(data.data()['Gender']),
        onTap: () {
          print('aaaa');
          setState(() {
            print('bbbb');
            join = true;
            target = data.id;
            print(target);
          });
        },
      ),
    );
  }
}

class ViewDetail extends StatefulWidget {
  final doc;
  final applyId;

  ViewDetail({@required this.doc, @required this.applyId});

  @override
  _ViewDetailState createState() => _ViewDetailState();
}

class _ViewDetailState extends State<ViewDetail> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('apply')
            .doc(widget.applyId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData == false) return CircularProgressIndicator();
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          return Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Applicant details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      Container(height: 24,width: 24)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0,0 ,50),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 70,
                        child: ClipOval(child: Icon(Icons.person, size:100,color: Colors.white,),),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xFF01579B), Color.fromRGBO(0, 41, 60, 1)]
                      )
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Name: ${snapshot.data['name']}", style: TextStyle(color: Colors.white70,fontSize: 20),),
                            ),
                          ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Current Position Title: ${snapshot.data['curPostTitle']}", style: TextStyle(color: Colors.white70,fontSize: 20)),
                            ),
                          ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Gender: ${snapshot.data['Gender']}", style: TextStyle(color: Colors.white70,fontSize: 20)),
                            ),
                          ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Nation: ${snapshot.data['Nation']}", style: TextStyle(color: Colors.white70,fontSize: 20),),
                            ),
                          ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Current Position Level: ${snapshot.data['curPostLevel']}", style: TextStyle(color: Colors.white70,fontSize: 20),),
                            ),
                          ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  launch(snapshot.data['phpURL']);
                                },
                                child: Text(
                                  "Resume:   if you want read Resume, click here",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                      color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70),),
                        ),
                      ),

                    ],
                  ),
                ))
              ],
            ),
          );
        },
      );

  }
}

typedef ReorderableWidgetBuilder = Widget Function(
    BuildContext context, int index, DocumentSnapshot doc);

class ReorderableFirebaseList extends StatefulWidget {
  const ReorderableFirebaseList({
    Key key,
    @required this.collection,
    @required this.indexKey,
    @required this.itemBuilder,
    @required this.id,
    this.descending = false,
  }) : super(key: key);

  final CollectionReference collection;
  final String indexKey;
  final bool descending;
  final ReorderableWidgetBuilder itemBuilder;
  final String id;

  @override
  _ReorderableFirebaseListState createState() =>
      _ReorderableFirebaseListState();
}

class _ReorderableFirebaseListState extends State<ReorderableFirebaseList> {
  List<DocumentSnapshot> _docs;
  Future _saving;
  List<DocumentSnapshot> temp;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _saving,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
            stream: widget.collection
                .orderBy(widget.indexKey, descending: widget.descending)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                _docs = snapshot.data.docs;
                for (int i = 0; i < _docs.length; i++) {
                  if (_docs.elementAt(i).data()['postId'] != widget.id) {
                    _docs.removeWhere(
                        (element) => element.data()['postId'] != widget.id);
                  }
                }
                return ReorderableListView(
                  onReorder: _onReorder,
                  children: List.generate(_docs.length, (int index) {
                    return widget.itemBuilder(context, index, _docs[index]);
                  }),
                );
              } else {
                return const Center(
                  child: Text("hI"),
                );
              }
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    _docs.insert(newIndex, _docs.removeAt(oldIndex));
    final futures = <Future>[];
    for (int rank = 0; rank < _docs.length; rank++) {
      futures.add(_docs[rank].reference.update({widget.indexKey: rank}));
    }
    setState(() {
      _saving = Future.wait(futures);
    });
  }
}
