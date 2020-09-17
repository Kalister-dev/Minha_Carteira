import 'dart:async';
import 'package:minhacarteira/widgets/ItemsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minhacarteira/application.dart';
import 'package:minhacarteira/layout.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:minhacarteira/models/item.dart';
import 'package:minhacarteira/widgets/HomeList.dart';

import '../application.dart';
import '../application.dart';

class ItemsPage extends StatefulWidget {
  static final tag = 'items-page';

  static int pklist;
  static String nameList;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _cName = TextEditingController();

  final TextEditingController _cData = TextEditingController();

  final MoneyMaskedTextController _cValor = MoneyMaskedTextController(
      thousandSeparator: '.', decimalSeparator: ',', leftSymbol: 'R\$ ');
  //Filtro da barra de pesquisa
  String filterText = "";

  final TextEditingController _cSaldo = TextEditingController();

  double saldo = 0.0;

  final ItemsListBloc itemsListBloc = ItemsListBloc();

  void _addSaldo(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // ignore: missing_return
      builder: (BuildContext ctx) {
        final inputSaldo = TextFormField(
          controller: _cSaldo,
          autofocus: true,
          decoration: InputDecoration(
              hintText: 'Saldo',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        );
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text('Adicionar saldo'),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                inputSaldo,
              ]),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.red,
                child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Salvar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  setState(() {
                    saldo = currencyToDouble(_cSaldo.text);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, ItemsPage.tag);
                    print(saldo);
                  });
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    itemsListBloc.dispose();
    super.dispose();
  }

  void refresher() {
    setState(() {
      this.itemsListBloc.getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  '  Mês : ' + ItemsPage.nameList,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              FloatingActionButton(
                heroTag: "btn1",
                mini: true,
                backgroundColor: Colors.blue,
                onPressed: () {
                  setState(() {
                    _addSaldo(context);
                    print(saldo);
                  });
                },
                child: Icon(Icons.attach_money),
              ),
            ],
          ),
          Container(
            color: Color.fromRGBO(230, 230, 230, 0.5),
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  child: TextField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Pesquisar',
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                    onChanged: (text) {
                      setState(() {
                        filterText = text;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                  height: 80,
                ),
                SizedBox(
                  child: FloatingActionButton(
                    heroTag: "btn2",
                    mini: true,
                    backgroundColor: Colors.red,
                    onPressed: () {
                      setState(() {
                        _addNewOne(context);
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 295,
            child: StreamBuilder<List<Map>>(
              stream: itemsListBloc.lists,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: Text('Carregando...'));
                    break; // Useless after return
                  default:
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ItemsList(
                          items: snapshot.data,
                          filter: filterText,
                          refresher: this.refresher);
                    }
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.white, Colors.red]),
            ),
            height: 80,
            child: StreamBuilder<List<Map>>(
              stream: itemsListBloc.lists,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: Text('Carregando...'));
                    break; // Useless after return
                  default:
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text('Error: ${snapshot.error}');
                    } else {
                      //Recupera os itens
                      List<Map> items = snapshot.data;
//                      List<Map> lista = snapshot.data;

                      //Total de itens
                      int qtdTotal = items.length;

                      int qtdChecked = 0;

                      double subTotal = 0.0;
                      double vlrTotal = 0.0;

//                      double saldo = currencyToFloat(lista['saldo']);

                      for (Map item in items) {
                        double vlr = currencyToFloat(item['valor']);
                        vlrTotal += vlr;
                        saldo -= vlrTotal;

                        if (item['checked'] == 1) {
                          qtdChecked++;
                          subTotal += vlr;
                        }
                      }
                      //quando todos os itens estiverem marcados,o texto do valor total mudara de cor
                      //bool isClosed = (subTotal == vlrTotal);

                      return Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text('Items'),
                                    Text(
                                      qtdTotal.toString(),
                                      textScaleFactor: 1.1,
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text('Marcadas'),
                                    Text(qtdChecked.toString())
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text('Restante'),
                                    Text((qtdTotal - qtdChecked).toString())
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Color.fromRGBO(0, 0, 0, 0.04),
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'Marcadas :  ' + doubleToCurrency(subTotal),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    'Total      :  ' +
                                        doubleToCurrency(vlrTotal),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text('Saldo    :  ' + doubleToCurrency(saldo),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          )
                        ],
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
    return Layout.getContent(context, content, false);
  }

  void _addNewOne(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        final inputName = TextFormField(
          controller: _cName,
          autofocus: true,
          decoration: InputDecoration(
              hintText: 'Nome da despesa',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (value) {
            if (value.isEmpty) {
              return 'Obrigatório';
            }
          },
        );
        _cData.text = '1';
        final inputData = TextFormField(
          controller: _cData,
          autofocus: false,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: 'Data',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (value) {
            if (int.parse(value) < 1 || int.parse(value) > 31) {
              return ('Informe uma data válida');
            }
          },
        );

        final inputValor = TextFormField(
          controller: _cValor,
          autofocus: false,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
              hintText: 'Valor R\$',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (value) {
            if (currencyToDouble(value) < 0.0) {
              return 'Obrigatório';
            }
          },
        );

        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text('Adicionar despesa'),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                inputName,
                SizedBox(height: 15),
                inputData,
                SizedBox(height: 15),
                inputValor
              ]),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.red,
                child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Salvar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    // Instacia Model
                    ModelItem itemBo = ModelItem();

                    //Adiciona no banco de dados
                    itemBo.insert({
                      'fk_lista': ItemsPage.pklist,
                      'name': _cName.text,
                      'data': _cData.text,
                      'valor': _cValor.text,
                      'created': DateTime.now().toString()
                    }).then((saved) {
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pushReplacementNamed(ItemsPage.tag);
                    });
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class ItemsListBloc {
  ItemsListBloc() {
    getList();
  }
  ModelItem itemBo = ModelItem();

  final _controller = StreamController<List<Map>>.broadcast();

  get lists => _controller.stream;

  dispose() {
    _controller.close();
  }

  getList() async {
    _controller.sink.add(await itemBo.itemsByList(ItemsPage.pklist));
  }
}
