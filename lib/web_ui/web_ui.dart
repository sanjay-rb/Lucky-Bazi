import 'package:betting_app/home_page/components/home_body.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebUi extends StatelessWidget {
  const WebUi({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(child: HomeBody()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.amber,
                  child: Text("Download App Now!"),
                  onPressed: () {
                    String urlString = 'https://bit.ly/luckybazi';
                    canLaunch(urlString).then((value) => launch(urlString));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
