import 'package:betting_app/consts/const_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistroyData extends StatelessWidget {
  static final routeName = '/history';
  const HistroyData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: StreamBuilder(
        stream: baziCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            QuerySnapshot querySnapshot = snapshot.data;
            return Container(
              child: ListView(
                children: List.generate(
                  querySnapshot.docs.length,
                  (index) => ExpansionTile(
                    title: Text(querySnapshot.docs[index].id),
                    children: [
                      Column(
                        children: List.generate(roundData.length, (val) {
                          val = val + 1;
                          var num1 = querySnapshot.docs[index]
                              [roundData[val - 1]]['number1'];
                          var num2 = querySnapshot.docs[index]
                              [roundData[val - 1]]['number2'];
                          return ListTile(
                            title: Text("Round $val Winner!"),
                            trailing: Text("$num1 & $num2"),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
