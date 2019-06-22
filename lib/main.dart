import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transmission_app/page/login_ui.dart';
import 'package:transmission_app/services/http_helper/http_dio.dart';
import 'package:transmission_app/services/http_helper/req_header.dart';

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

void main() {
  // add interceptors
  dio.interceptors..add(LogInterceptor());
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  dio.options.receiveTimeout = 30000;
  dio.options.headers = RequestHeader.GetHeaderMap();
  runApp(MyApp());
}

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
