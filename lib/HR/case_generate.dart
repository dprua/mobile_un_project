import 'dart:convert';
import 'dart:io';

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
    position_length = post.docs.length;
    apply_length = apply.docs.length;
    fac_pos = await factorial(position_length);
    arr = new List(2);
    init_arr = new List<String>(position_length);
    arr[1] = position_length;
    arr[0] = fac_pos;
    for(int i =0;i<position_length;i++){
      init_arr[i] = post.docs.elementAt(i).data()["Title"];
    }
    apply_arr = new List(position_length); // 각 포지션 별로 지원한 사람 숫
    make2darr();
    int count = 0;
    for(int i =0;i<position_length;i++){
      for(int j = 0; j<apply_length;j++){
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
    //var StringStringMap1 = {'1' : "wefwefa",'3':"dsfewgwe"};
    //var StringStringMap2 = {'2' : "adfwegwe"};
    // var a = {'Data Analysis': 'stf1', 'dhs': 'stf5', 'yezzin': 'stf2', 'CEO position': 'admin_stf'};
    // var b = {'yezzin': 'stf2', 'dhs': 'stf5', 'Data Analysis': 'stf1', 'CEO position': 'admin_stf'};
    // print("SHWHDHFWHDFWHDFHWFHW");
    // print(mapEquals(a, b));
    // Map<String, Map> superMap = new Map();
    // superMap["subMap"] = new Map();
    // superMap["efae"] = new Map();
    // superMap["subMap"].addAll(StringStringMap1);
    // superMap["efae"].addAll(StringStringMap2);
    // print(superMap);
    // print("SDFASDF");
    //print(twoDList);
    //print(solution);
    var init =  Map.fromIterables(twoDList[0], solution[0]);
    final_case[num] = new Map();
    final_case[num].addAll(init);
    num++;
    for(int i=0;i<fac_pos;i++){
      var b = Map.fromIterables(twoDList[i], solution[i]);
      var c = judge(b);
    }
    // print(final_case);
    // print(final_case.length);
    // print(num);
    // print(position_length);
    // print(init);
    // print(init.keys);
    // print(init.values);
    // print(init.keys.elementAt(0));
    print(final_case[0]['dhs']);
    Map<int, Map> possible_case = new Map();
    for(int i = 0; i < final_case.length; i++){
      possible_case[i] = new Map();
      for(int j = 0 ; j < position_length; j++)
        possible_case[i].addAll({init.keys.elementAt(j):final_case[i][init.keys.elementAt(j)]});
    }
    //print("KFDFJQLWDGJWDKGJQDWLGD");
    print(possible_case);

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Possible Relocation Case"),
      ),
      body: FutureBuilder(
          future: getinfo(),
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
              return new ListView.builder(
                itemCount: snapshot1.data.length,
                itemBuilder: (BuildContext context, int index) {
                  int key = snapshot1.data.keys.elementAt(index);
                  return new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("$key"),
                        subtitle: new Text("${snapshot1.data[key]}"),
                      ),
                      new Divider(
                        height: 2.0,
                      ),
                    ],
                  );
                },
              );
            }
          }
      ),
    );
  }
}