import 'package:flutter/material.dart';
import 'package:transmission_app/ui/login_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transmission',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.purpleAccent,
          buttonColor: Colors.redAccent),
      routes: {
        '/': (BuildContext context) => LoginPage(),
      },
      initialRoute: '/',
    );
  }
}
