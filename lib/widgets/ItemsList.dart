import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:minhacarteira/application.dart';
import 'package:minhacarteira/models/item.dart';
import 'package:minhacarteira/pages/Items.dart';
import 'package:minhacarteira/pages/item-edit.dart';



class ItemsList extends StatefulWidget {


  final List<Map> items;
  final String filter;
  final Function refresher;

  const ItemsList({Key key, this.items, this.filter, this.refresher}) : super(key: key);

  @override
  _ItemsListState createState () => _ItemsListState();
  }

class _ItemsListState extends State<ItemsList> {

  @override
  Widget build(BuildContext context) {
    // Item default
    if (widget.items.isEmpty){
      return ListView(children: <Widget>[ListTile(title: Text('Nenhuma despesa para exibir ainda'))
      ]);
    }

    List<Map> filteredList = List<Map>();
    //Tem algum filtro ?
    if (widget.filter.isNotEmpty){
      for(dynamic item in widget.items){
        
        //
        String name = item['name'].toString().toLowerCase();
        if(name.contains(widget.filter.toLowerCase())){
          filteredList.add(item);
        }
      }
    } else {
      filteredList.addAll(widget.items);
    }


    //Se a campo de busca estiver vazio
    if (filteredList.isEmpty){
      return ListView(children: <Widget>[
        ListTile(title: Text('Nenhuma despesa encontrada'))
      ]);
    }

    ModelItem itemBo = ModelItem();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, int i){

      Map item = filteredList[i];

      double realValor = currencyToDouble(item['valor']);


      return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        closeOnScroll: true,
        child: ListTile(
          leading: GestureDetector(
            child: Icon(
                ((item['checked'] == 1) ? Icons.check_box: Icons.check_box_outline_blank),
                color: Colors.red,
                size: 42

            ),
            onTap: (){
              itemBo.update({'checked': !(item['checked'] == 1) }, item['pk_item']).then((bool updated){
                if (updated){
                  widget.refresher();
                };
              });
            },
          ),
          title: Text(item['name']),
          subtitle: Text('Data  : [ ${item['data']} ]  -  ${item['valor']}'),
          trailing: Icon(Icons.arrow_back),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Editar',
            icon: Icons.edit,
            color: Colors.white10,
            foregroundColor: Colors.black45,
            onTap: (){

              itemBo.getItem(item['pk_item']).then((Map i){

                //adiciona o item encontrado
                ItemEditPage.item = i;

                //vai para a pagina
                Navigator.of(context).pushNamed(ItemEditPage.tag);

              });
            },
          ),
          IconSlideAction(
            caption: 'Deletar',
            icon: Icons.delete,
            color: Colors.white10,
            foregroundColor: Colors.red,
            onTap: (){

              showDialog(
                  context: context,
              barrierDismissible: true,
              builder: (BuildContext ctx){
                  return AlertDialog(
                    title: Text('Deseja deletar a despesa ${item['name']} ?', style: TextStyle(fontSize: 17)),
                    actions: <Widget>[
                      RaisedButton(
                        color: Colors.red,
                        child: Text('Não', style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          Navigator.of(ctx).pop();
                        },
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text('Sim', style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          itemBo.delete(item['pk_item']);
                          Navigator.of(ctx).pop();
                          Navigator.of(ctx).pushReplacementNamed(ItemsPage.tag);
                          },
                      )
                    ],
                  );
              }
              );
            },
          )
        ],
      );
      },
    );
  }
}