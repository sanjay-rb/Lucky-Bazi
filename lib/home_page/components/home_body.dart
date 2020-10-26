import 'package:betting_app/consts/const_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size cardSize = Size(
      MediaQuery.of(context).size.width * 0.45,
      MediaQuery.of(context).size.width * 0.49,
    );
    return StreamBuilder(
      stream: currentBaziDoc.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          DocumentSnapshot doc = snapshot.data;
          if (!doc.exists) {
            currentBaziDoc.set({
              '10:15': {'number1': '*', 'number2': '***'},
              '11:15': {'number1': '*', 'number2': '***'},
              '12:15': {'number1': '*', 'number2': '***'},
              '13:15': {'number1': '*', 'number2': '***'},
              '14:15': {'number1': '*', 'number2': '***'},
              '15:15': {'number1': '*', 'number2': '***'},
              '16:15': {'number1': '*', 'number2': '***'},
              '17:15': {'number1': '*', 'number2': '***'},
              '18:15': {'number1': '*', 'number2': '***'},
              '19:15': {'number1': '*', 'number2': '***'},
              '20:15': {'number1': '*', 'number2': '***'},
              '21:15': {'number1': '*', 'number2': '***'},
            });
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: SingleChildScrollView(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    12,
                    (index) => Card(
                      elevation: 5,
                      child: Container(
                        width: cardSize.width,
                        height: cardSize.height,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      doc.data()[roundData[index]]['number1'],
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(
                                      doc.data()[roundData[index]]['number2'],
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                            Container(
                              width: cardSize.width,
                              height: cardSize.height * 0.2,
                              color: Colors.grey.shade300,
                              child: Center(
                                child: Text(timeForRound[roundData[index]]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
