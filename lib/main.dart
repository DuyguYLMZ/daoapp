import 'package:dao/screens/announcementpage.dart';
import 'package:dao/screens/homepage.dart';
import 'package:dao/screens/loginpage.dart';
import 'package:dao/util/dataprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DAO',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
        //home: MyHomePage(title: 'DAO Home Page'),
      ),
    );
  }
}

