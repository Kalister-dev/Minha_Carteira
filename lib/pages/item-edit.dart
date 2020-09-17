import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:minhacarteira/layout.dart';
import '../application.dart';
import 'Items.dart';
import 'package:minhacarteira/models/item.dart';

class ItemEditPage extends StatefulWidget {

  static String tag = 'page-item-add';
  static Map item;

  @override
  _ItemEditPageState createState() => _ItemEditPageState();
}

final GlobalKey<FormState>_formKey = GlobalKey<FormState>();

final TextEditingController _cName = TextEditingController();

final TextEditingController _cData = TextEditingController();

final MoneyMaskedTextController _cValor =MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$ '
);

class _ItemEditPageState extends State<ItemEditPage> {
  @override
  Widget build(BuildContext context) {
    // Instancia model
    ModelItem itemBo = ModelItem();


    _cName.text = ItemEditPage.item['name'];
    final inputName = TextFormField(
      controller: _cName,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Nome do item',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
          )
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Obrigatório';
        }
        return null;
      },
    );

    _cData.text = ItemEditPage.item['data'].toString();
    final inputData = TextFormField(
      controller: _cData,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Data',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
          )
      ),
      validator: (value) {
        double valueAsDouble = (double.tryParse(value) ?? 0.0);

        if (valueAsDouble <= 0 || valueAsDouble >31) {
          return 'Informe uma data válida';
        }
        return null;
      },
    );


    _cValor.text = ItemEditPage.item['valor'].toString();
    final inputValor = TextFormField(
      controller: _cValor,
      autofocus: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          hintText: 'Valor R\$',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
          )
      ),
      validator: (value) {
        if (currencyToDouble(value) < 0.0) {
          return 'Obrigatório';
        }
        return null;
      },
    );

    Container content = Container(
        child: Form(
          key: _formKey,
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: <Widget>[
                Text(
                  "Editar :  "+ItemEditPage.item['name'].toString()+"",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),
                ),
                SizedBox(height: 10),
                Text('Nome da despesa'),
                inputName,
                SizedBox(height: 10),
                Text('Data'),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        child: inputData,
                      ),
                    ]
                ),
                SizedBox(height: 10),
                Text('Valor'),
                inputValor,
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  ),
                SizedBox(height: 50),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.red,
                        child: Text('Cancelar', style:TextStyle(color: Colors.white)),
                        padding: EdgeInsets.only(left: 50, right: 50),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text('Salvar', style:TextStyle(color: Colors.white)),
                        padding: EdgeInsets.only(left: 50, right: 50),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {

                            // Adiciona no banco de dados
                            itemBo.update(
                                {
                                  'name': _cName.text,
                                  'data': _cData.text,
                                  'valor': _cValor.text,
                                  'created': DateTime.now().toString()
                                },
                                ItemEditPage.item['pk_item']
                            ).then((saved) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed(ItemsPage.tag);
                            });
                          }
                        },
                      )
                    ])
              ]
          ),
        )
    );

    return Layout.getContent(context, content, false);
  }
}
