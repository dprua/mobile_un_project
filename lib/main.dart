import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'Widget_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  //runApp(ShrineApp());
}




class MyApp extends StatelessWidget {
  var flag = false;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: FirebaseAuth.instance.authStateChanges()),
        //StreamProvider.value(value: FirebaseFirestore.instance.collection('users').snapshots()),
        // ChangeNotifierProvider(
        //     create: (context) => Boolcheck()),
        ChangeNotifierProvider<FirebaseProvider>(
            create: (context) => FirebaseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WidgetTree(),
      ),
    );
  }
}
