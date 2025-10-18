import 'package:flutter/material.dart';

class Nicholaslim extends StatelessWidget {
  const Nicholaslim({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nicholas Lim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hello, Nicholas Lim!'),
        ),
      ),
    );
  }
}