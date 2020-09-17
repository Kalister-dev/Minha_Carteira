import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:minhacarteira/pages/home.dart';
import 'package:minhacarteira/pages/about.dart';
import 'package:minhacarteira/pages/help.dart';
import 'package:minhacarteira/widgets/HomeList.dart';
import 'package:minhacarteira/pages/Items.dart';
import 'application.dart';
import 'models/Lista.dart';

class Layout{

  static final pages = [
    HomePage.tag,
    AboutPage.tag,
    HelpPage.tag
  ];

  static int currItem =0;

  static Scaffold getContent(BuildContext context, content,[bool showbottom = true]){

    BottomNavigationBar bottomNavBar =  BottomNavigationBar(
    currentIndex: currItem,
    fixedColor: Colors.red,
    items: <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('Home')),
    BottomNavigationBarItem(icon: Icon(Icons.assignment),title: Text('Sobre')),
    BottomNavigationBarItem(icon: Icon(Icons.help),title: Text('Ajuda'))


    ],
    onTap: (int i){
    currItem = i;
    Navigator.of(context).pushReplacementNamed(pages[i]);
    },
    );



    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.blue,
        title: Text('Minha Carteira'),
        actions: showbottom ?_getActions(context) : [],
      ),
      bottomNavigationBar: showbottom ? bottomNavBar : null,
      body: content,
    );
  }
static List<Widget> _getActions(context){
List<Widget> items = List<Widget>();


final _c =TextEditingController();
final MoneyMaskedTextController _cS =MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$ '
);


if (pages[currItem] == HomePage.tag) {
items.add(
    GestureDetector(
      onTap: (){
        showDialog(
            context: context,
            //barrierDismissible: false,
            builder: (BuildContext ctx){

              final imput = TextFormField(
                controller: _c,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Nome',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)
                    )
                ),
              );
              final imputS = TextFormField(
                controller: _cS,
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    hintText: 'Saldo R\$',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)
                    )
                ),
                validator: (value) {

                  if (currencyToDouble(value) < 0.0){
                    return 'Obrigatório';
                  }
                },
              );

              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      imput,
                      imputS
                    ],
                  ),
                ),
                title: Text("Novo mês"),
                actions: <Widget>[

                  RaisedButton(
                    color: Colors.red,
                    child: Text('Cancelar', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      Navigator.of(ctx).pop();
                    },
                  ),

                  RaisedButton(
                    color: Colors.blue,
                    child: Text('Adicionar', style: TextStyle(color: Colors.white),),
                    onPressed: (){

                      ModelLista listaBo = ModelLista();

                      listaBo.insert({
                        'name': _c.text,
                        'created': DateTime.now().toString()
                      }).then((newRowId) {
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pushReplacementNamed(HomePage.tag);
                      });

                    },
                  )
                ],
              );
            }
        );
      },
      child: Icon(Icons.add),
    )
  );
}
    items.add(Padding(padding: EdgeInsets.only(right: 20)));

return items;
}
}