import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Case_generate extends StatelessWidget{

  QuerySnapshot post;
  var arr;
  List<List <String>> twoDList;
  List<List <String>> solution;
  var position_length;
  var fac_pos;
  List<String> init_arr;
  var a,b;
  int c = 0;
  int max;

  QuerySnapshot apply;
  var apply_length;
  var apply_arr;
  var apply_arr_name;
  var apply_arr_rank;
  Map<String, dynamic> info_num;
  Map<String, dynamic> info_name;
  Map<String, dynamic> info_rank;
  var temp;
  var num = 0;
  Map<int, Map> final_case = new Map();

  getinfo() async {
    post = await FirebaseFirestore.instance.collection('post').where('approval', isEqualTo: true).get();
    apply = await FirebaseFirestore.instance.collection('apply').get();
    position_length = post.docs.length; //포지션 수
    apply_length = apply.docs.length; //지원자 수
    fac_pos = await factorial(position_length); //포지션 펙토리얼 값
    arr = new List(2);
    init_arr = new List<String>(position_length); // 각 포지션의 이름이 적힌 리스
    arr[1] = position_length;
    arr[0] = fac_pos;
    for(int i =0;i<position_length;i++){
      init_arr[i] = post.docs.elementAt(i).data()["Title"];
    }
    apply_arr = new List(position_length); // 각 포지션 별로 지원한 사람
    make2darr();
    int count = 0;
    for(int i =0;i<position_length;i++){
      for(int j = 0; j<apply_length;j++){ // apply length는 포지션 중에서 가장 지원자가 많은 놈 기준으로 값이 정해짐
        if(apply.docs.elementAt(j).data()['postId'] == post.docs.elementAt(i).id){
          count++;
        }
      }
      apply_arr[i] = count;
      count = 0;
    }
    info_num = Map.fromIterables(init_arr, apply_arr);
    print("INFO NUM");
    print(info_num);

    max = 0;
    for(int i = 0 ; i<position_length;i++){
      if(apply_arr[i] > max)
        max = apply_arr[i];
    }


    apply_arr_name = List.generate(position_length, (i) => List<String>(max), growable: false);
    count = 0;
    for(int i =0;i<position_length;i++){
      for(int j = 0; j<apply_length;j++){
        if(apply.docs.elementAt(j).data()['postId'] == post.docs.elementAt(i).id){
          apply_arr_name[i][count] = apply.docs.elementAt(j).data()['name'];
          count++;
        }
      }
      count = 0;
    }

    info_name = Map.fromIterables(init_arr, apply_arr_name);
    print("INFO NAME");
    print(info_name);

    count = 0;
    apply_arr_rank = List.generate(position_length, (i) => List<int>(max), growable: false);
    for(int i =0;i<position_length;i++){
      for(int j = 0; j<apply_length;j++){
        if(apply.docs.elementAt(j).data()['postId'] == post.docs.elementAt(i).id){
          apply_arr_rank[i][count] = apply.docs.elementAt(j).data()['rank'];
          count++;
        }
      }
      count = 0;
    }
    info_rank = Map.fromIterables(init_arr, apply_arr_rank);
    var as = Map.from(info_rank);

    print("INFO RANK");
    print(info_rank);

    preparelist(init_arr, 0, position_length-1);
    print("PREPARE LIST");
    print(twoDList);

    final_case = makecase();
    print("SDGKDJQWGLDGWQD");
    print(final_case);
    return final_case;
  }

  make2darr() {
    twoDList = List.generate(arr[0], (i) => List(arr[1]), growable: false);
    solution = List.generate(arr[0], (i) => List(arr[1]), growable: false);
  }

  setlist(List<String> k){
    for(int i = 0 ; i < position_length; i++)
      twoDList[c][i] = k[i];
    c++;
  }

  preparelist(init_arr, int i, int n)  {
    int j;
    if (i == n){
      setlist(init_arr);
      return;
    }
    for(j=i;j<=n;j++){
      Swap(init_arr[i], init_arr[j],i,j);
      preparelist(init_arr, i+1, n);
      Swap(init_arr[i], init_arr[j],i,j);
    }
  }

  Swap(a,b,int i,int j){
    init_arr[i] = b;
    init_arr[j] = a;
  }
  int factorial(int n) {
    if (n < 0) throw ('Negative numbers are not allowed.');
    return n <= 1 ? 1 : n * factorial(n - 1);
  }

  makecase(){
    var list;
    List<dynamic> temp_rank;
    List<dynamic> temp_name;
    List<dynamic> temp_num;
    Map<String, dynamic> t_info_num;
    Map<String, dynamic> t_info_name;
    Map<String, dynamic> t_info_rank;
    var idx;
    var value_rank;
    var value_name;
    var value_num;
    var target;

    for(int i=0;i<fac_pos;i++){
      list = twoDList[i];
      t_info_num = json.decode(json.encode(info_num));
      t_info_name = json.decode(json.encode(info_name));
      t_info_rank = json.decode(json.encode(info_rank));

      //print("1");
      for(int j=0;j<position_length;j++){
        temp_rank = t_info_rank[list[j]];
        value_rank = 99;
        idx = 99;
        for(int a = 0; a < max; a++) {
          if (temp_rank[a] == null) {
            continue;
          }
          else if (temp_rank[a] < value_rank) {
            value_rank = temp_rank[a];
            idx = a;
          }
        }

        if(value_rank == 99){
          print("why?");
          continue;
        }

        temp_name = t_info_name[list[j]];
        value_name = temp_name[idx];
        solution[i][j] = value_name;
        target = value_name;
        for(int k=0;k<position_length;k++){
          for(int z=0;z<max;z++){
            if(t_info_name[list[k]][z] == target) {
              t_info_name[list[k]][z] = null;
              t_info_rank[list[k]][z] = null;
              //t_info_num[list[k]][z] += -1;
            }
          }
        }
      }
    }
    var init =  Map.fromIterables(twoDList[0], solution[0]);
    final_case[num] = new Map();
    final_case[num].addAll(init);
    num++;
    for(int i=0;i<fac_pos;i++){
      var b = Map.fromIterables(twoDList[i], solution[i]);
      var c = judge(b);
    }

    Map<int, Map> possible_case = new Map();
    for(int i = 0; i < final_case.length; i++){
      possible_case[i] = new Map();
      for(int j = 0 ; j < position_length; j++)
        possible_case[i].addAll({init.keys.elementAt(j):final_case[i][init.keys.elementAt(j)]});
    }
    return possible_case;
  }

  judge(var b){
    var flag = false;
    for(int i=0;i<num;i++){
       flag = mapEquals(final_case[i], b);
       if(flag == true)
         break;
    }
    if(flag == false){
      final_case[num] = new Map();
      final_case[num].addAll(b);
      num++;
      return true;
    }
    else{
      return false;
    }
  }

  List<DataRow> _getRows(){
    List<DataRow> dataRow = [];
    List colors = [Color(0xFFCFFFE5),Color(0xFFFAF1D6),  Color(0xFFFAD4AE),  Color(0xFFFADEE1), Color(0xFFD9F1F1), Color(0xFFB6E3E9)];
    Random random = new Random();
    int index = 0;
    for (var i=1; i<=num; i++) {
      var csvDataCells=[];
      csvDataCells.add('$i') ;
      for(var k=0;k<position_length;k++){
        if(final_case[i-1][init_arr[k]] == null)
          csvDataCells.add("No");
        else
          csvDataCells.add(final_case[i-1][init_arr[k]]);
      }
      //var csvDataCells = init_arr[i]; // data Analysis

      List<DataCell> cells = [];
      for(var j=0; j<csvDataCells.length; j++) {
        cells.add(DataCell(Text(csvDataCells[j],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))));
      }
      print("ADSGASDGASDGSDAGSADGASDGASDGASD");

      dataRow.add(DataRow(
        cells: cells,
        //color: MaterialStateColor.resolveWith((states) => colors[index]),
        color: MaterialStateProperty.resolveWith ((Set  states) {
          print(index);
          print(colors[index]);
          index++;
          if(index == 6)
            index = 0;
          return colors[index];// Use the default value.
        }),
      ));


    }
    return dataRow;
  }

  List<DataColumn> _getColumns(){
    List<DataColumn> dataColumn = [];

    dataColumn.add(DataColumn(label: Text('CASE',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white))));

    for (int i = 0; i<position_length;i++) {
        dataColumn.add(DataColumn(label: Text(init_arr[i],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),)));
    }

    return dataColumn;
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF01579B),
          centerTitle: true,
          title: Text("Possible Relocation Case"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Center(
            child: FutureBuilder(
                future: getinfo(),
                builder: (BuildContext context, AsyncSnapshot snapshot1) {
                  if (snapshot1.hasData == false) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(500, 300, 600, 300),
                      child: Column( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[ CircularProgressIndicator( backgroundColor: Colors.white, strokeWidth: 6), SizedBox(height: 20), Text('Please Waiting...', style: TextStyle( fontSize: 40, fontWeight: FontWeight.w700, color: Colors.black, shadows: <Shadow>[ Shadow(offset: Offset(4, 4), color: Colors.black12) ], decorationStyle: TextDecorationStyle.solid)) ], ),
                    );
                  }
                  else if (snapshot1.hasError) {
                    return Column( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[ CircularProgressIndicator( backgroundColor: Colors.white, strokeWidth: 6), SizedBox(height: 20), Text('Please Waiting...', style: TextStyle( fontSize: 40, fontWeight: FontWeight.w700, color: Colors.black, shadows: <Shadow>[ Shadow(offset: Offset(4, 4), color: Colors.black12) ], decorationStyle: TextDecorationStyle.solid)) ], );
                  }
                  else {
                    return DataTable(
                      headingRowColor:
                      MaterialStateColor.resolveWith((states) =>  Color(0xFF878787)),
                      horizontalMargin: 12.0,
                      columnSpacing: 28.0,
                      columns: _getColumns(),
                      rows: _getRows(),
                    );
                  }
                }
            ),
          ),
        ),
      ),
    );
  }
}

