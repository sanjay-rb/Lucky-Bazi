import 'package:betting_app/consts/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({
    Key key,
    @required this.docs,
  }) : super(key: key);

  final DocumentSnapshot docs;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Image.asset('images/nav_banner.jpg'),
          SizedBox(
            height: 25,
          ),
          ListTile(
            title: Text("Profile"),
            leading: Icon(
              Icons.account_circle_sharp,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                Routes.updatePlayer,
                arguments: [docs.id, true],
              );
            },
          ),
          if (docs.data()['type'] == "admin")
            ListTile(
              title: Text("Player List"),
              leading: Icon(
                Icons.playlist_play_rounded,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.playerList);
              },
            ),
          ListTile(
            title: Text("History"),
            leading: Icon(
              Icons.history,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.histroy);
            },
          ),
          if (docs.data()['type'] != "admin")
            ListTile(
              title: Text("Play Game"),
              leading: Icon(
                Icons.play_arrow,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.playGame,
                    arguments: docs.id);
              },
            ),
          if (docs.data()['type'] == "admin")
            ListTile(
              title: Text("See Result"),
              leading: Icon(
                Icons.play_arrow,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.seeResult);
              },
            ),
          ListTile(
            title: Text("Log Out"),
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onTap: () {
              SharedPreferences.getInstance()
                  .then((value) => value.setString('isLogin', null));
              Navigator.pushReplacementNamed(context, Routes.loginPage);
            },
          )
        ],
      ),
    );
  }
}
