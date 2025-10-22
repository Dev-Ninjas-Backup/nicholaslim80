import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = <Widget>[
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Orders Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Account Page', style: TextStyle(fontSize: 24))),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
