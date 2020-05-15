import 'package:flutter/material.dart';
import 'package:appfastdelivery/helper/adicional.dart';
import 'package:appfastdelivery/helper/variacao.dart';
import 'package:appfastdelivery/util/configuration.dart';


class VariacoesShowPage extends StatefulWidget {
  final Variacao variacao;
  final String title;

  VariacoesShowPage(this.variacao, this.title);
  @override
  _VariacoesShowPageState createState() => _VariacoesShowPageState();
}

class _VariacoesShowPageState extends State<VariacoesShowPage> {
  Variacao _variacao;
  String _title;
  bool _isChecked  = false;


  @override
  void initState() {
    super.initState();
    _variacao = widget.variacao;
    _title = widget.title;
  }

  bool _isSelected(){
    int count = 0;
    for(Adicional adicionalAux in _variacao.adicionais){
      if(adicionalAux.selected){
        return true;
      }
    }
      return false;
  }
  int _count(){
    int count = 1;
    for(Adicional adicionalAux in _variacao.adicionais){
      if(adicionalAux.selected){
        count++;
      }
    }
    return count;
  }

  void _alertErrorCountVariation(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            Container(
                padding: EdgeInsets.only(top: 50.0, bottom: 70.0),
                color: Configuration.colorAccent3,
                child:
                AlertDialog(
                  title: Text('Limite de escolhas excedido!'),
                  titleTextStyle: TextStyle(fontSize: 16.0, color: Configuration.colorAccent0),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Você só pode escolher, no máximo ${_variacao.maximo} opções.',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
            );

        }
    );
  }

  _returnPage(BuildContext context){

//    if(_count() > _variacao.maximo){
//      print('limite de escolhas excedido. maximo ${_variacao.maximo}');
//      _alertError();
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////      showDialog(
////          context: context,
////          barrierDismissible: false, // user must tap button!
////          builder: (BuildContext context) {
////            return
////              AlertDialog(
////              title: Text('Limite de escolhas excedido!'),
////              titleTextStyle: TextStyle(fontSize: 16.0, color: Color.fromRGBO(36, 36, 143, 1.0)),
////              content: SingleChildScrollView(
////                child: ListBody(
////                  children: <Widget>[
////                    Text('Você só pode escolher, no máximo ${_variacao.maximo} opções.',
////                      style: TextStyle(fontSize: 15.0),
////                    ),
////                  ],
////                ),
////              ),
////              actions: <Widget>[
////                FlatButton(
////                  child: Text('OK'),
////                  onPressed: () {
////                    Navigator.of(context).pop();
////                  },
////                ),
////              ],
////            );
////          },
////        );
//
//    }






    if(_isSelected()){
        Navigator.of(context).pop(_variacao);
//        print(_variacao);
//        Navigator.pop(context, _variacao);
      }else{
        Navigator.of(context).pop(_variacao.id);
//        Navigator.pop(context, null);
      }


  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: (){
          _returnPage(context);
        },
        child:
        Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(_title),
              centerTitle: true,
              backgroundColor: Theme.of(context).accentColor,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: (){
                    _returnPage(context);
                  },
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Container(
                  height: 45.0,
                  color: Configuration.colorAccent0,
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("${_variacao.descricao}",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.white
                              )
                          ),

                          Text("No Minimo ${_variacao.minimo}. No Máximo ${_variacao.maximo}.",
                              style: TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.white
                              )
                          ),
                        ],
                      )
                  ),
                ),

                Expanded(
                    child: ListView.builder(
//                  shrinkWrap: true,
//                  physics: ClampingScrollPhysics(),
                        itemCount: _variacao.adicionais.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child:
                            CheckboxListTile(
                              title: Text("${_variacao.adicionais[index].descricao}"),
                              activeColor: Colors.indigo,
                              value: _variacao.adicionais[index].selected,
                              onChanged: (value) {

                                print(value);
                                print('varicao ${_variacao.adicionais[index].selected}');
                                if (_count() > _variacao.maximo) {
                                  if(_variacao.adicionais[index].selected == true){
                                    setState(() {
                                      _variacao.adicionais[index].selected = value;
                                    });
                                    print('é o cara ${value}');
                                  }else{
                                    print('limite de escolhas excedido. maximo ${_variacao.maximo}');
                                    _alertErrorCountVariation();
                                  }
                                }else{
                                  setState(() {
                                    _variacao.adicionais[index].selected = value;
                                  });

                                }
                              },
                              secondary: Text("R\$ ${_variacao.adicionais[index].valor.replaceAll(".", ",")}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14.0),),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
//
                          );
                        })
                )

              ],
            ),

            bottomNavigationBar: BottomAppBar(
                child: Container(
                  height: 45.0,
                  child: FlatButton(
                      onPressed: (){
                        _returnPage(context);
                      },
                      color: Color.fromRGBO(36, 36, 143, 1.0),
                      child: Center(
                        child: Text("Concluir",
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)
                        ),
                      )
                  ),
                )


            )

        ),
      );
  }
}
