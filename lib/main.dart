import 'package:flutter/material.dart';
import 'package:minhacarteira/pages/about.dart';
import 'package:minhacarteira/pages/home.dart';
import 'package:minhacarteira/pages/help.dart';
import 'package:minhacarteira/pages/Items.dart';
import 'pages/item-edit.dart';

void main() => runApp(minha_carteira());

class minha_carteira extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomePage.tag: (context) => HomePage(),
    AboutPage.tag: (context) => AboutPage(),
    HelpPage.tag: (context) => HelpPage(),
    ItemsPage.tag: (context) => ItemsPage(),
    ItemEditPage.tag: (context) => ItemEditPage(),
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Minha carteira',
      theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.redAccent,
          textTheme: TextTheme(
              headline: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              title: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.normal,
                  color: Colors.blueAccent),
              body1: TextStyle(fontSize: 14))),
      home: HomePage(),
      routes: routes,
    );
  }
}
