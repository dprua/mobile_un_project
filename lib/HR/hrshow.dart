import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class HRShow extends StatefulWidget {

  @override
  _HRShowState createState() => _HRShowState();
}

class _HRShowState extends State<HRShow> {
  //String id = FirebaseAuth.instance.currentUser.uid;
  bool join = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Detail about Applicant "),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 600,
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
                ? Text("Push Join Button")
            //hmDetailInfoPage(doc:widget.doc,applyId:FirebaseAuth.instance.currentUser.uid)
                : Text("Push Join Button"),
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
          setState(() {
          });
        },
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
