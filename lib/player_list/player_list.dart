import 'package:betting_app/consts/const_data.dart';
import 'package:betting_app/consts/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayerList extends StatelessWidget {
  static final routeName = '/playerList';

  const PlayerList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userCollection.orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            QuerySnapshot snap = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text("Player List"),
              ),
              body: ListView(
                children: List.generate(
                  snap.docs.length,
                  (index) => ListTile(
                    title: Text(
                      snap.docs[index].data()['name'] +
                          ' - ' +
                          snap.docs[index].data()['phone'],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.updatePlayer,
                        arguments: [snap.docs[index].id, false],
                      );
                    },
                  ),
                ),
              ),
            );
          }
        });
  }
}
