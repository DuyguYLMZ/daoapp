import 'package:dao/screens/announcementpage.dart';
import 'package:dao/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dao/util/dataprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        home: CheckAuth(),
        //home: MyHomePage(title: 'DAO Home Page'),
      ),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => new _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isLoggedIn;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future checkUser() async {
    isLoggedIn = false;
    User user = FirebaseAuth.instance.currentUser;
    await user.reload();

    if (user != null)
      setState(() {
        isLoggedIn = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? new AnnouncementPage() : new LoginPage();
  }
}
