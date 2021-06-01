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
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('post')
                      .doc(widget.doc.id)
                      .collection('apply')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData == false)
                      return CircularProgressIndicator();
                    if (snapshot.hasError)
                      return Text("Error: ${snapshot.error}");
                    return ListView(
                      children: snapshot.data.docs
                          .map((data) => _buildListItem(context, data))
                          .toList(),
                    );
                  }),
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
            .collection('post')
            .doc(widget.doc.id)
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