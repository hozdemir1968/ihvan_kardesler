import 'package:flutter/material.dart';

class CircularProgressPage extends StatelessWidget {
  const CircularProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
