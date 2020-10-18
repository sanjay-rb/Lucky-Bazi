import 'package:betting_app/consts/error.dart';
import 'package:betting_app/histroy/history.dart';
import 'package:betting_app/home_page/home_page.dart';
import 'package:betting_app/login_page/login_page.dart';
import 'package:betting_app/play_game/play_game.dart';
import 'package:betting_app/player_list/player_list.dart';
import 'package:betting_app/see_result/see_result.dart';
import 'package:betting_app/update_player/update_player.dart';
import 'package:flutter/material.dart';

class Routes {
  static final String loginPage = LoginPage.routeName;
  static final String homePage = HomePage.routeName;
  static final String updatePlayer = UpdatePlayer.routeName;
  static final String playerList = PlayerList.routeName;
  static final String playGame = PlayGame.routeName;
  static final String histroy = HistroyData.routeName;
  static final String seeResult = SeeResult.routeName;

  static routeBuilder(Widget page) {
    return MaterialPageRoute(
      builder: (context) => page,
    );
  }

  static Route<dynamic> routeGenerator(RouteSettings settings) {
    if (settings.name == loginPage) return routeBuilder(LoginPage());
    if (settings.name == homePage)
      return routeBuilder(HomePage(
        uid: settings.arguments,
      ));
    if (settings.name == playerList) return routeBuilder(PlayerList());
    if (settings.name == playGame)
      return routeBuilder(PlayGame(uid: settings.arguments));
    if (settings.name == histroy) return routeBuilder(HistroyData());
    if (settings.name == seeResult) return routeBuilder(SeeResult());

    if (settings.name == updatePlayer) {
      List data = settings.arguments;
      return routeBuilder(UpdatePlayer(
        uid: data[0],
        isProfile: data[1],
      ));
    }

    return routeBuilder(ErrorPage());
  }
}
