import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:un_project/STF/stfdetail.dart';

class HRWidget extends StatefulWidget{
  final user_state;
  HRWidget({@required this.user_state});
  @override
  HRState createState() => HRState();
}

class HRState extends State<HRWidget>{
  String dropdownValue = 'All';
  int levelNum = 0;

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        DropdownButton<String>(     // positions per level (DropdownButton)
          value: dropdownValue,
          onChanged: (String newValue){
            print(widget.user_state);
            setState((){
              dropdownValue = newValue;
              var n;
              if(newValue == 'All'){
                levelNum = 0;
              }else{
                n = int.tryParse(newValue[6]);
                levelNum = n;
              }
              // level 1, level 2, level 3,
              // Query collection 'post',   // have to change

            });
          },
          items: <String>['All','level 1', 'level 2', 'level 3', 'level 4', 'level 5', 'level 6']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Expanded(
            child: StreamBuilder(
              stream:(levelNum == 0)
                  ? FirebaseFirestore.instance
                  .collection('post')
                  .where('approval', isEqualTo: true)
                  .snapshots()
                  : FirebaseFirestore.instance
                  .collection('post')
                  .where('Level', isEqualTo: levelNum)
                  .where('approval', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.count(
                  crossAxisCount: 3,
                  children: snapshot.data.docs.map((document){
                    return Card(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width / 1.2,
                        // height: ,
                        child: Column(
                          children: [
                            Text("Title: ${document.get('Title')}"),
                            Text("Level: ${document.get('Level')}"),
                            Text("Division: ${document.get('Division')}"),
                            Text("Branch: ${document.get('Branch')}"),
                            Text("Duty station: ${document.get('Duty station')}"),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text("more"),
                                onPressed: (){
                                  // When tap the "more", go to Detail page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => StaffDetail(doc: document)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )
        ),
      ],
    );
  }
}
