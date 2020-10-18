import 'package:betting_app/consts/const_data.dart';
import 'package:flutter/material.dart';

class PlayGame extends StatefulWidget {
  static final routeName = '/playGame';
  final uid;
  const PlayGame({Key key, this.uid}) : super(key: key);

  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  List roundSelector, numberSelector1, numberSelector2;
  int index;
  PageController _pageCtrl;
  String roundTaken, numberTaken1, numberTaken2;

  void _submitPlayData() async {
    String isConfirm = await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          final _formkey = GlobalKey<FormState>();
          TextEditingController _amountCtrl = TextEditingController();
          return AlertDialog(
            title: Text(
              "Confirm your numbers",
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Round $roundTaken",
                    textAlign: TextAlign.center,
                  ),
                  DataTable(
                    columns: [
                      DataColumn(
                        label: Text("number 1"),
                      ),
                      DataColumn(
                        label: Text("number2"),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(numberTaken1)),
                        DataCell(Text(numberTaken2))
                      ]),
                    ],
                  ),
                  TextFormField(
                    controller: _amountCtrl,
                    validator: (value) {
                      if (value.isEmpty) return "Enter amount for bet";
                      if (int.parse((value)) == 0)
                        return "Enter amount for bet";
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount to Play!',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              OutlineButton(
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    Navigator.pop(context, _amountCtrl.text);
                  }
                },
                child: Text("Confirm"),
              ),
            ],
          );
        },
      ),
    );
    if (isConfirm != null) {
      showDialog(
          context: context,
          child: Center(
            child: CircularProgressIndicator(),
          ));
      currentBaziDoc.collection('result').doc(roundTaken).get().then((doc) {
        if (doc.exists) {
          currentBaziDoc.collection('result').doc(roundTaken).update({
            numberTaken1: doc.data()[numberTaken1] == null
                ? 1
                : ++doc.data()[numberTaken1],
            numberTaken2: doc.data()[numberTaken2] == null
                ? 1
                : ++doc.data()[numberTaken2],
          }).then((value) {
            userCollection.doc(widget.uid).get().then((user) {
              if (int.parse(user.data()['wallet']) > int.parse(isConfirm)) {
                userCollection
                    .doc(widget.uid)
                    .collection('bazi')
                    .doc(
                        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
                    .get()
                    .then((value) {
                  if (value.exists) {
                    userCollection
                        .doc(widget.uid)
                        .collection('bazi')
                        .doc(
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
                        .update({
                      roundTaken: {
                        "number1": numberTaken1,
                        "number2": numberTaken2,
                        "amount": isConfirm,
                      }
                    }).then((value) {
                      userCollection.doc(widget.uid).update({
                        'wallet': (int.parse(user.data()['wallet']) -
                                int.parse(isConfirm))
                            .toString()
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    });
                  } else {
                    userCollection
                        .doc(widget.uid)
                        .collection('bazi')
                        .doc(
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
                        .set({
                      roundTaken: {
                        "number1": numberTaken1,
                        "number2": numberTaken2,
                        "amount": isConfirm,
                      }
                    }).then((value) {
                      userCollection.doc(widget.uid).update({
                        'wallet': (int.parse(user.data()['wallet']) -
                                int.parse(isConfirm))
                            .toString()
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    });
                  }
                });
              } else {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("Error"),
                    content: Text(
                        "Amount exhausted!\nYour balance is ${user.data()['wallet']}"),
                  ),
                );
              }
            });
          });
        } else {
          currentBaziDoc.collection('result').doc(roundTaken).set({
            numberTaken1: 1,
            numberTaken2: 1,
          }).then((value) {
            userCollection.doc(widget.uid).get().then((user) {
              if (int.parse(user.data()['wallet']) > int.parse(isConfirm)) {
                userCollection
                    .doc(widget.uid)
                    .collection('bazi')
                    .doc(
                        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
                    .get()
                    .then((value) {
                  if (value.exists) {
                    userCollection
                        .doc(widget.uid)
                        .collection('bazi')
                        .doc(
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
                        .update({
                      roundTaken: {
                        "number1": numberTaken1,
                        "number2": numberTaken2,
                        "amount": isConfirm,
                      }
                    }).then((value) {
                      userCollection.doc(widget.uid).update({
                        'wallet': (int.parse(user.data()['wallet']) -
                                int.parse(isConfirm))
                            .toString()
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    });
                  } else {
                    userCollection
                        .doc(widget.uid)
                        .collection('bazi')
                        .doc(
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
                        .set({
                      roundTaken: {
                        "number1": numberTaken1,
                        "number2": numberTaken2,
                        "amount": isConfirm,
                      }
                    }).then((value) {
                      userCollection.doc(widget.uid).update({
                        'wallet': (int.parse(user.data()['wallet']) -
                                int.parse(isConfirm))
                            .toString()
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    });
                  }
                });
              } else {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("Error"),
                    content: Text(
                        "Amount exhausted!\nYour balance is ${user.data()['wallet']}"),
                  ),
                );
              }
            });
          });
        }
      });
    }
  }

  @override
  void initState() {
    index = 0;
    roundTaken = '***';
    numberTaken1 = '-1';
    numberTaken2 = '###';
    _pageCtrl = PageController(initialPage: index);
    roundSelector = List.generate(roundData.length, (index) => false);
    numberSelector1 = List.generate(number1.length, (index) => false);
    numberSelector2 = List.generate(number2[0].length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: index != 2
          ? FloatingActionButton(
              onPressed: () {
                if (index == 0 && roundTaken == '***') {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text("Select Round Time"),
                      content:
                          Text("Please select the round time for the game."),
                      actions: [
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Play"),
                        ),
                      ],
                    ),
                  );
                } else if (index == 1 && numberTaken1 == '-1') {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text("Select Number 1"),
                      content: Text(
                          "Please select the your lucky number 1 for the game."),
                      actions: [
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Play"),
                        ),
                      ],
                    ),
                  );
                } else {
                  setState(() {
                    ++index;
                  });
                  _pageCtrl.animateToPage(
                    index % 3,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                }
              },
              child: Icon(
                Icons.navigate_next,
              ),
            )
          : null,
      appBar: AppBar(
        title: Text("Play Game"),
      ),
      body: Container(
        child: PageView(
          controller: _pageCtrl,
          physics: new NeverScrollableScrollPhysics(),
          children: [
            buildTimeSelector(),
            buildNumberOneSelector(),
            buildNumberTwoSelector(),
          ],
        ),
      ),
    );
  }

  Widget buildTimeSelector() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Select Round Time",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                roundSelector.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Builder(
                    builder: (context) => InkWell(
                      onTap: () {
                        List time = roundData[index].toString().split(':');
                        DateTime currentTime = DateTime.now();
                        if (currentTime
                            .difference(DateTime(
                                currentTime.year,
                                currentTime.month,
                                currentTime.day,
                                int.parse(time[0]),
                                int.parse(time[1])))
                            .isNegative) {
                          setState(() {
                            roundSelector = List.generate(
                                roundData.length, (index) => false);
                            roundSelector[index] = !roundSelector[index];
                            roundTaken = roundData[index];
                          });
                        } else {
                          Scaffold.of(context).showSnackBar(
                            new SnackBar(
                              content: Text(
                                  "Round ${timeForRound[roundData[index]]} is already over!"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
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
        ),
      ],
    );
  }

  Widget buildNumberOneSelector() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Select Number 1",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                number1.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        numberSelector1 =
                            List.generate(number1.length, (index) => false);
                        numberSelector1[index] = !numberSelector1[index];
                        numberTaken1 = number1[index];
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: numberSelector1[index]
                          ? Colors.amber.shade100
                          : Colors.white,
                      child: Center(
                        child: Text(
                          number1[index].toString(),
                          style: TextStyle(
                            fontSize: 25,
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
      ],
    );
  }

  Widget buildNumberTwoSelector() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  number2[0].length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          numberSelector2 = List.generate(
                              number2[0].length, (index) => false);
                          numberSelector2[index] = !numberSelector2[index];
                          numberTaken2 =
                              number2[int.parse(numberTaken1)][index];
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        color: numberSelector2[index]
                            ? Colors.amber.shade100
                            : Colors.white,
                        child: Center(
                          child: Text(
                            int.parse(numberTaken1) == -1
                                ? ""
                                : number2[int.parse(numberTaken1)][index],
                            style: TextStyle(
                              fontSize: 25,
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
          SizedBox(
            height: 70,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: RaisedButton(
                color: Colors.black,
                onPressed: _submitPlayData,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
