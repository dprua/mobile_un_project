import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:un_project/HR/case_generate.dart';

class HRShow extends StatefulWidget {

  @override
  _HRShowState createState() => _HRShowState();
}

class _HRShowState extends State<HRShow> {
  //String id = FirebaseAuth.instance.currentUser.uid;
  bool join = false;
  var target = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Detail about Applicant "),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.featured_play_list_sharp),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Case_generate()),
              );
              print("Make case!");
            },
          ),
        ]
      ),
      body: Row(
        children: <Widget>[
          SizedBox(
            width: 250,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
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
          const VerticalDivider(
            color: Colors.grey,
            thickness: 1,
            indent: 20,
            endIndent: 0,
            width: 20,
          ),
          Expanded(
            child: (join)
                ? ViewDetail(applyId: target,)
            //hmDetailInfoPage(doc:widget.doc,applyId:FirebaseAuth.instance.currentUser.uid)
                : Text("Push Join Button"),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    return SizedBox(
      width: 100,
      child: Padding(
        key: ValueKey(data.data()['name']),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text(data.data()['name']),
          subtitle: Text(data.data()['Gender']),
          onTap: () {
            setState(() {
              join = true;
              target = data.id;
            });
          },
        ),
      ),
    );
  }
}

class ViewDetail extends StatefulWidget {
  final applyId;

  ViewDetail({@required this.applyId});

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
              ],
            ),
          );
        },
      ),
    );
  }
}

