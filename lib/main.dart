import 'package:flutter/material.dart';
import 'package:prayer_times_app/main_elements_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Prayer Times",
      theme:ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: const  MainElements()
        ),
    );
  }
}



