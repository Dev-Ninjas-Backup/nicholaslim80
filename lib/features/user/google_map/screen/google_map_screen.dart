import 'package:flutter/material.dart';
import 'package:nicholaslim80/features/user/google_map/widget/google_map_widget.dart';

class GoogleMapScreen extends StatelessWidget {
  const GoogleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Screen'),
      ),
      body: GoogleMapWidget(),
    );
  }
}