import 'package:flutter/material.dart';
import 'package:minhacarteira/layout.dart';

class HelpPage extends StatelessWidget {

  static String tag = 'help-page';
  @override
  Widget build(BuildContext context) {
    return Layout.getContent(context, Center(
      child: Text('Este aplicativo foi criado com o intuito de auxiliar sua vida financeira.Elaborando uma lista de débitos diários para maior controle'),

    ));
  }
}
