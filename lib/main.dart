import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'Widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}




class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: FirebaseAuth.instance.authStateChanges()),
        ChangeNotifierProvider<FirebaseProvider>(
            create: (context) => FirebaseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://www.softwareone.com/-/media/global/social-media-and-blog/hero/publisher-advisory_get-ready-for-the-office-2010-end-of-support-header.jpg?rev=5496ff43323143be831b8a7922711cf2&sc_lang=en-fi&hash=A250C8730555358AEFE638574FCA0AF4"),
                fit: BoxFit.cover
              )
            ),
            child: WidgetTree()
        ),
      ),
    );
  }
}
