import 'package:flutter/material.dart';
import 'package:minhacarteira/models/Lista.dart';
import 'package:intl/intl.dart';
import '../pages/home.dart';
import '../models/Lista.dart';
import '../pages/Items.dart';
import '../layout.dart';

enum ListAction { edit, delete }

class HomeList extends StatefulWidget {
  final List<Map> items;
  double saldoMes = 0.0;

  HomeList({this.items}) : super();

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  List<Widget> values = List<Widget>();

  ModelLista listaBo = ModelLista();

  @override
  Widget build(BuildContext context) {
    // Item default
    if (widget.items.length == 0) {
      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Nenhum mês adicionado'),
            trailing: Icon(Icons.more_horiz),
          )
        ],
      );
    }

    DateFormat df = DateFormat('dd/MM/yyyy HH:mm');

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (BuildContext contetx, int index) {
        Map item = widget.items[index];

        DateTime created = DateTime.tryParse(item['created']);

        return ListTile(
          leading: Icon(Icons.date_range, size: 42),
          title: Text(item['name']),
//          contentPadding: (item['saldo']),
          subtitle: Text(df.format(created)),
          trailing: PopupMenuButton<ListAction>(
            onSelected: (ListAction result) {
              switch (result) {
                case ListAction.edit:
                  this.showEditDialog(context, item);
                  break;

                case ListAction.delete:
                  listaBo.delete(item['pk_lista']).then((deleted) {
                    if (deleted) {
                      Navigator.of(context).pushReplacementNamed(HomePage.tag);
                    }
                  });
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<ListAction>>[
                PopupMenuItem<ListAction>(
                  value: ListAction.edit,
                  child:
                      Row(children: <Widget>[Icon(Icons.edit), Text('Editar')]),
                ),
                PopupMenuItem<ListAction>(
                  value: ListAction.delete,
                  child: Row(
                      children: <Widget>[Icon(Icons.delete), Text('Excluir')]),
                )
              ];
            },
          ),
          onTap: () {
            // Aponta na lista qual está selecionada
            ItemsPage.pklist = item['pk_lista'];
            ItemsPage.nameList = item['name'];

            // Muda de página
            Navigator.of(context).pushNamed(ItemsPage.tag);
          },
        );
      },
    );
  }

  void showEditDialog(BuildContext context, Map item) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          TextEditingController _cSaldo = TextEditingController();
          TextEditingController _cEdit = TextEditingController();
          _cEdit.text = item['name'];
          _cSaldo.text = item['saldo'];
          final input = TextFormField(
            controller: _cEdit,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Nome',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
          );

          return AlertDialog(
            title: Text('Editar'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  input,
                ],
              ),
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
                  ModelLista listaBo = ModelLista();

                  listaBo.update({
                    'name': _cEdit.text,
                    'saldo': _cSaldo.text,
                    'created': DateTime.now().toString()
                  }, item['pk_lista']).then((saved) {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pushReplacementNamed(HomePage.tag);
                  });
                },
              )
            ],
          );
        });
  }
}
