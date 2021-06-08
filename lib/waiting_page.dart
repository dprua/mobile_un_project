import 'package:flutter/material.dart';

class Waiting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
            child: Column(
              children: [
                Text("Loading....",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                CircularProgressIndicator(),
              ],
            )
        ),
        ),
      );
  }
}