import 'package:betting_app/consts/const_data.dart';
import 'package:betting_app/consts/route.dart';
import 'package:betting_app/home_page/components/home_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components/home_body.dart';
import 'components/nav_drawer.dart';

class HomePage extends StatefulWidget {
  static final routeName = '/home';
  final uid;
  HomePage({Key key, this.uid}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage;
  PageController _pageCtrl;
  @override
  void initState() {
    super.initState();
    currentPage = 0;
    _pageCtrl = PageController(
      initialPage: currentPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userCollection.doc(widget.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            DocumentSnapshot docs = snapshot.data;
            return Scaffold(
              appBar: buildAppBar(docs),
              floatingActionButton: docs.data()['type'] == "player"
                  ? FloatingActionButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.playGame,
                            arguments: docs.id);
                      },
                    )
                  : null,
              bottomNavigationBar:
                  docs.data()['type'] == "player" ? buildHomeBtmNav() : null,
              drawer: NavDrawer(docs: docs),
              body: docs.data()['type'] == "player"
                  ? PageView(
                      controller: _pageCtrl,
                      children: [
                        HomeBody(),
                        HomeUser(docs: docs),
                      ],
                    )
                  : HomeBody(),
            );
          }
        });
  }

  BottomNavigationBar buildHomeBtmNav() {
    return BottomNavigationBar(
      currentIndex: currentPage,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      onTap: (value) {
        currentPage = value;
        _pageCtrl.animateToPage(currentPage,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.online_prediction),
          title: Text('Result'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.money),
          title: Text('Bazi'),
        ),
      ],
    );
  }

  AppBar buildAppBar(DocumentSnapshot docs) {
    return AppBar(
      title: Text('Welcome ${docs.data()["name"]}'),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Wallet ₹${docs.data()["wallet"]}",
              style: TextStyle(
                fontSize: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
