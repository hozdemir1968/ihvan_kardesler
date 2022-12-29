import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage(this.e, this.trace, {Key? key}) : super(key: key);
  final Object e;
  final StackTrace? trace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(e.toString()),
          Text(trace.toString()),
        ],
      ),
    );
  }
}
