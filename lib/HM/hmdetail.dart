import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

var target;

class hmdetailPage extends StatefulWidget {
  final doc;

  const hmdetailPage({
    Key key,
    @required this.doc,
  }) : super(key: key);
  @override
  _hmdetailPageState createState() => _hmdetailPageState();
}

class _hmdetailPageState extends State<hmdetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Posting Information and Applicant Status"),
        centerTitle: true,
        backgroundColor: Color(0xFF01579B),
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            child: ListView(
              children: <Widget>[
                (widget.doc['photoURL'] != "")
                    ? Image.network(
                  widget.doc['photoURL'],
                  fit: BoxFit.fitWidth,
                  height: MediaQuery.of(context).size.height-492,
                )
                    : Container(),
                Container(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconAndDetail(Icons.subtitles_rounded, "${widget.doc['Title']}"),
                      SizedBox(height: 10.0),
                      Text("\t\tWork Experience", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      for(var i in widget.doc['work_exp'])
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text("📌   ${i.toString()}", style: TextStyle(fontSize: 17.0)),
                        ),
                      SizedBox(height:10.0),
                      Text("\t\tLanguages", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      for(var i in widget.doc['lang_exp'])
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text("📌  ${i.toString()}",  style: TextStyle(fontSize: 17.0)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            color: Colors.grey,
            thickness: 1,
            indent: 20,
            endIndent: 15,
            width: 20,
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width-650,
              child: ViewDetail(applyId: widget.doc)
          ),
        ],
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
  List<DocumentSnapshot> _docs;
  DocumentSnapshot target_docu;
  bool flag = true;

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

  Widget cetrificatebuilder(BuildContext context, var cer_list) {
    return Wrap(
        direction: Axis.vertical,
        children: List.generate(cer_list.length, (index) {
          return Text(cer_list[index] + ', ',
              style: TextStyle(
                fontFamily: 'Spectral',
                color: Color(0xFF303030),
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
              ));
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('apply')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData == false) return CircularProgressIndicator();
        if (snapshot.hasError) return Text("Error: ${snapshot.error}");
        if (snapshot.hasData) {
          _docs = snapshot.data.docs;
          for (int i = 0; i < _docs.length; i++) {
            if (_docs.elementAt(i).data()['postId'] != widget.applyId.id) {
              _docs.removeWhere((element) =>
              element.data()['postId'] != widget.applyId.id);
            }
          }
          return (flag) ?
          Column(
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
                    left: 130,
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
              Container(
                height: 650,
                child: ReorderableFirebaseList(
                  //.where('postId',isEqualTo : widget.doc.id)
                  collection: FirebaseFirestore.instance.collection('apply'),
                  indexKey: 'rank',
                  id: widget.applyId.id,
                  itemBuilder: (BuildContext context, int index,
                      DocumentSnapshot doc) {
                    return ListTile(
                      key: Key(doc.id),
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
                      onTap: () {
                        setState(() {
                          flag = false;
                          target_docu = doc;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Stack(
                    children: <Widget>[
                      _buildCoverImage(screenSize),
                      SingleChildScrollView(
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
                                  image: target_docu['Gender'] == 'MALE'
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
                            Text(target_docu['name'],
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w700,
                                )),
                            Container(
                              color: Theme
                                  .of(context)
                                  .scaffoldBackgroundColor,
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
                          ],
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
                          Text(target_docu['Nation'],
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
                          Text(target_docu['curPostTitle'],
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
                          Text(target_docu['curDutyStat'],
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
                                children: List.generate(
                                    target_docu['certificates'].length, (
                                    index) {
                                  return Text(
                                      target_docu['certificates'][index] + ', ',
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
                          Text(target_docu['skillLev'].toString(),
                            style: TextStyle(
                              fontFamily: 'Spectral',
                              color: Color(0xFF303030),
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                            ),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Resume : ",
                            style: TextStyle(
                              fontFamily: 'Spectral',
                              color: Color(0xFF303030),
                              fontSize: 23.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                launch(target_docu['phpURL']);
                              },
                              child: Text(
                                'Click 📜 ',
                                style: TextStyle(fontSize: 20,color: Color(0xFF303030),),
                              )
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  flag = true;
                                  print(flag);
                                });
                              },
                              child: Text("Back")
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
                  child: Text("Loding...",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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



class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail);
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(
          detail,
          style: TextStyle(fontSize: 37.0, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}