// import 'package:app/pages/forecast.dart';
// import 'package:app/pages/forecast.dart';
// import 'package:app/pages/enternow.dart';
import 'package:app/pages/signup.dart';
// import 'package:app/pages/foreecastcard.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto', // Set Roboto as the global font
      ),
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }
}
