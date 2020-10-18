import 'package:betting_app/consts/const_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final round;
  ResultPage({this.round});
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String resultNumber1, resultNumber2;
  @override
  void initState() {
    resultNumber1 = '***';
    resultNumber2 = '***';
    super.initState();
  }

  _setResult1(val) {
    setState(() {
      resultNumber1 = val;
    });
  }

  _setResult2(val) {
    setState(() {
      resultNumber2 = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today Result"),
      ),
      body: StreamBuilder(
        stream:
            currentBaziDoc.collection('result').doc(widget.round).snapshots(),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            DocumentSnapshot doc = snapshot.data;
            if (doc.data() == null) {
              return Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Enter Number 1'),
                        onChanged: (value) {
                          resultNumber1 = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Enter Number 2'),
                        onChanged: (value) {
                          resultNumber2 = value;
                        },
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (resultNumber1 != '***' && resultNumber2 != '***') {
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("Confirm Result"),
                              content: Text(
                                  "Number 1 = $resultNumber1\nNumber 2 = $resultNumber2"),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            ),
                          ).then((isConfirm) {
                            if (isConfirm != null) {
                              currentBaziDoc.update({
                                widget.round: {
                                  'number1': resultNumber1,
                                  'number2': resultNumber2,
                                }
                              }).then((value) {
                                Navigator.pop(context);
                              });
                            }
                          });
                        }
                      },
                      child: Text("Publish"),
                    )
                  ],
                ),
              );
            } else {
              Map dataMap = doc.data();
              List sortedListOfKeys = dataMap.keys.toList()
                ..sort((k1, k2) => dataMap[k2].compareTo(dataMap[k1]));
              print(sortedListOfKeys);
              Map sortedMap = Map.fromIterable(
                sortedListOfKeys,
                key: (element) => element,
                value: (element) => dataMap[element],
              );
              List finalKey = sortedMap.keys.toList();
              List finalNumber1Key = finalKey
                  .where((element) => element.toString().length == 1)
                  .toList();
              List finalNumber2Key = finalKey
                  .where((element) => element.toString().length != 1)
                  .toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Enter Number 1'),
                      onChanged: (value) {
                        resultNumber1 = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Enter Number 2'),
                      onChanged: (value) {
                        resultNumber2 = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 2,
                      itemBuilder: (context, number) => ExpansionTile(
                        maintainState: true,
                        title: Text("Number ${number + 1}"),
                        children: [
                          if (number == 0)
                            SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('Number')),
                                    DataColumn(label: Text('Count')),
                                  ],
                                  rows: List.generate(
                                    finalNumber1Key.length,
                                    (index) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(finalNumber1Key[index]
                                              .toString()),
                                          onTap: () {
                                            _setResult1(finalNumber1Key[index]
                                                .toString());
                                          },
                                        ),
                                        DataCell(
                                          Text(sortedMap[finalNumber1Key[index]]
                                              .toString()),
                                          onTap: () {
                                            _setResult1(finalNumber1Key[index]
                                                .toString());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (number == 1)
                            SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('Number')),
                                    DataColumn(label: Text('Count')),
                                  ],
                                  rows: List.generate(
                                    finalNumber2Key.length,
                                    (index) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(finalNumber2Key[index]
                                              .toString()),
                                          onTap: () {
                                            _setResult2(finalNumber2Key[index]
                                                .toString());
                                          },
                                        ),
                                        DataCell(
                                          Text(sortedMap[finalNumber2Key[index]]
                                              .toString()),
                                          onTap: () {
                                            _setResult2(finalNumber2Key[index]
                                                .toString());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      separatorBuilder: (context, index) => Divider(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: RaisedButton(
                        color: Colors.amber,
                        child: Text(
                          "Publish",
                          // "Publish $resultNumber1 & $resultNumber2 as result",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          if (resultNumber1 != "***" &&
                              resultNumber1 != '***') {
                            showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text("Confirm Result"),
                                content: Text(
                                    "Number 1 = $resultNumber1\nNumber 2 = $resultNumber2"),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text("Confirm"),
                                  ),
                                ],
                              ),
                            ).then((isConfirm) {
                              if (isConfirm != null) {
                                currentBaziDoc.update({
                                  widget.round: {
                                    'number1': resultNumber1,
                                    'number2': resultNumber2,
                                  }
                                }).then((value) {
                                  Navigator.pop(context);
                                });
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
