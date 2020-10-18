import 'package:betting_app/consts/const_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeUser extends StatelessWidget {
  const HomeUser({Key key, this.docs}) : super(key: key);
  final DocumentSnapshot docs;

  @override
  Widget build(BuildContext context) {
    final Size cardSize = Size(
      MediaQuery.of(context).size.width * 0.45,
      MediaQuery.of(context).size.width * 0.49,
    );
    return StreamBuilder(
      stream: userCollection
          .doc(docs.id)
          .collection('bazi')
          .doc(
              '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
          .snapshots(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          DocumentSnapshot doc = snapshot.data;
          if (doc.exists) {
            return Container(
              child: SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      doc.data().length,
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
                                  '₹ ' +
                                      doc
                                          .data()
                                          .values
                                          .elementAt(index)['amount'],
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
                                        doc
                                            .data()
                                            .values
                                            .elementAt(index)['number1'],
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      Text(
                                        doc
                                            .data()
                                            .values
                                            .elementAt(index)['number2'],
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
                                  child: Text(timeForRound[
                                      doc.data().keys.elementAt(index)]),
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
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Let's Play! Choose your lucky number now.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
