import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 25,
              ),
              Text('This is non routed page'),
            ],
          ),
        ),
      ),
    );
  }
}
