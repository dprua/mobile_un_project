import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

var target;

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
        title: Text("Applicant Information"),
        centerTitle: true,
        backgroundColor: Color(0xFF01579B),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.7,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        height: 60,
                        width: 400,
                        padding: EdgeInsets.fromLTRB(120, 15, 20, 0),
                        decoration: BoxDecoration(
                          color: Color(0xFF64B5F6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      left: 110,
                      child: Text(
                        'Applicant List',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 650,
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
                      }
                  ),
                ),
              ],
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
                ? ViewDetail(applyId: target)
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
    return SizedBox(
      width: 100,
      child: Padding(
        key: ValueKey(data.data()['name']),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(
                        width: 1.0, color: Colors.grey))),
            child:
            Icon(Icons.person, color: Colors.grey, size: 40),
          ),
          title: Text(
            data.data()['name'],
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
          subtitle: Row(
            children: <Widget>[
              Icon(Icons.linear_scale, color: Colors.black),
              Text(data.data()['Gender'],
                  style: TextStyle(color: Colors.black))
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.black, size: 30.0),
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

  Widget _buildCoverImage(Size screenSize) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        height: screenSize.height / 2.6,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RWptHL?ver=f9a8&q=90&m=2&h=768&w=1024&b=%23FFFFFFFF&aim=true'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('apply')
          .doc(widget.applyId)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData == false) return CircularProgressIndicator();
        if (snapshot.hasError) return Text("Error: ${snapshot.error}");
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Stack(
                  children: <Widget>[
                    _buildCoverImage(screenSize),
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: screenSize.height / 4.0,
                            ),
                            Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: snapshot.data['Gender'] == 'MALE'
                                      ? NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/character%2Fman_char-removebg-preview.png?alt=media&token=986c55de-c46c-49a4-965b-4feb49360c3c')
                                      : NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/unproject-af159.appspot.com/o/character%2Fwoman_char-removebg-preview.png?alt=media&token=bdd9a2ab-91ea-437c-8f61-74eae8e1e5a9'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(90.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 10.0,
                                ),
                              ),
                            ),
                            Text(snapshot.data['name'],
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w700,
                                )),
                            Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'United Nations-Its Your World!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Spectral',
                                  fontWeight: FontWeight.w400,
                                  //try changing weight to w500 if not thin
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF799497),
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                            Container(
                              width: screenSize.width / 1.6,
                              height: 2.0,
                              color: Colors.black54,
                              margin: EdgeInsets.only(top: 4.0),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 0, 20, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Nation : ', style: TextStyle(
                          fontFamily: 'Spectral',
                          color: Color(0xFF303030),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w400,
                        )),
                        Text(snapshot.data.data()['Nation'],
                          style: TextStyle(
                            fontFamily: 'Spectral',
                            color: Color(0xFF303030),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('Current Position Title : ', style: TextStyle(
                          fontFamily: 'Spectral',
                          color: Color(0xFF303030),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w400,
                        )),
                        Text(snapshot.data.data()['curPostTitle'],
                          style: TextStyle(
                            fontFamily: 'Spectral',
                            color: Color(0xFF303030),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('Current Duty Station : ', style: TextStyle(
                          fontFamily: 'Spectral',
                          color: Color(0xFF303030),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w400,
                        )),
                        Text(snapshot.data.data()['curDutyStat'],
                          style: TextStyle(
                            fontFamily: 'Spectral',
                            color: Color(0xFF303030),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Certificates list : ', style: TextStyle(
                          fontFamily: 'Spectral',
                          color: Color(0xFF303030),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w400,
                        )),
                        Container(
                          width: 400,
                          child: Wrap(
                              direction: Axis.horizontal,
                              children: List.generate(snapshot.data.data()['certificates'].length, (index) {
                                return Text(snapshot.data.data()['certificates'][index]+', ',
                                    style: TextStyle(
                                      fontFamily: 'Spectral',
                                      color: Color(0xFF303030),
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w600,
                                    ));
                              })
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('Programing Skill Level : ', style: TextStyle(
                          fontFamily: 'Spectral',
                          color: Color(0xFF303030),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w400,
                        )),
                        Text(snapshot.data.data()['skillLev'].toString(),
                          style: TextStyle(
                            fontFamily: 'Spectral',
                            color: Color(0xFF303030),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
