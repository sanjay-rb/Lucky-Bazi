import 'package:betting_app/consts/const_data.dart';
import 'package:betting_app/see_result/result_page.dart';
import 'package:flutter/material.dart';

class SeeResult extends StatefulWidget {
  static final routeName = '/seeResult';
  const SeeResult({Key key}) : super(key: key);

  @override
  _SeeResultState createState() => _SeeResultState();
}

class _SeeResultState extends State<SeeResult> {
  List roundSelector;
  String roundTaken;
  @override
  void initState() {
    roundSelector = List.generate(roundData.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Round"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
              roundSelector.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      roundSelector =
                          List.generate(roundData.length, (index) => false);
                      roundSelector[index] = !roundSelector[index];
                      roundTaken = roundData[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(round: roundTaken),
                        ),
                      );
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: roundSelector[index]
                        ? Colors.amber.shade100
                        : Colors.white,
                    child: Center(
                      child: Text(
                        timeForRound[roundData[index]],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
