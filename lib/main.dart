import 'package:flutter/material.dart';

import 'package:crm/controllers/login_controller.dart';
import 'package:crm/pages/loadingPage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When we navigate to the "/" route, build the FirstScreen Widget
//        '/': (context) => ListPage(title: 'Lessons'),
//        '/': (context) => LoginPage(),
//        '/': (context) => DashBoard(),
        '/': (context) => LoadingPage(auth: new LoginController()),
//        '/': (context) => ClientInfo(),
        // When we navigate to the "/second" route, build the SecondScreen Widget
//        '/second': (context) => SecondScreen(),
      },
      title: 'Eldora Power CRM',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
//      home: new LoginPage(), Uncomment this line if need be
    );
  }
}