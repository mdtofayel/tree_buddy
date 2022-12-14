import 'package:flutter/material.dart';
import 'package:tree_boddy/utils/colors.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'This is web',
        style: TextStyle(color: mobileBackgroundColor),
      )),
    );
  }
}
