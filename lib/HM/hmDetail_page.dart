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
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 600,
              child: ReorderableFirebaseList(//.where('postId',isEqualTo : widget.doc.id)
                collection: FirebaseFirestore.instance.collection('apply'),
                indexKey: 'rank',
                id: widget.doc.id,
                itemBuilder: (BuildContext context, int index, DocumentSnapshot doc) {
                  return ListTile(
                    leading: Icon(Icons.person),
                    key: Key(doc.id),
                    title: Text(doc.data()['name']),
                    subtitle: Text(doc.data()['Gender']),
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
                : Text(""),
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
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('apply')
            .doc(widget.applyId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData == false) return CircularProgressIndicator();
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          return Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Column(
              children: [
                Text(
                  "Name: ${snapshot.data['name']}",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Current Position Title: ${snapshot.data['curPostTitle']}",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Current Duty Station: ${snapshot.data['curDutyStat']}",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Current Position Level: ${snapshot.data['curPostLevel']}",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Gender: ${snapshot.data['Gender']}",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Nation: ${snapshot.data['Nation']}",
                  style: TextStyle(fontSize: 20.0),
                ),
                TextButton(
                  onPressed: () {
                    launch(snapshot.data['phpURL']);
                  },
                  child: Text(
                    "Resume: \n${snapshot.data['phpURL']}",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
typedef ReorderableWidgetBuilder = Widget Function(BuildContext context, int index, DocumentSnapshot doc);
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
  _ReorderableFirebaseListState createState() => _ReorderableFirebaseListState();
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
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
            stream: widget.collection.orderBy(widget.indexKey, descending: widget.descending).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                _docs = snapshot.data.docs;
                for(int i=0;i<_docs.length;i++){
                  if(_docs.elementAt(i).data()['postId'] != widget.id){
                    _docs.removeWhere((element) => element.data()['postId'] != widget.id);
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