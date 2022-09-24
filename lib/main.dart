// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tejaswini_admin/screens/dash.dart';
import 'package:tejaswini_admin/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tejaswini_admin/screens/login.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tejaswini Admin",
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/register':(context)=> Register(),
        '/dash':(context)=> Dash(),
      },
    );
  }
}

class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
