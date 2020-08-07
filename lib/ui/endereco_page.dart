import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/bairro_dao.dart';
import 'package:appfastdelivery/dao/endereco_dao.dart';
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:appfastdelivery/ui/pagamento_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';

import 'endereco_search_page.dart';

class EnderecoPage extends StatefulWidget {
  @override
  _EnderecoPageState createState() => _EnderecoPageState();
}

class _EnderecoPageState extends State<EnderecoPage> {
  EnderecoDao _enderecoDao = EnderecoDao();
  BairroDao bairroDao;

  List<bool> _selects = List();
  Endereco _enderecoParceiro = null;
  EnderecoCliente _enderecoEscolhido = null;
  Future<List<Bairro>> _futureListBairros;
  Future<Endereco> _futureEndereco;


  @override
  void initState() {
    print('LOG[EnderecoPage]:  Entrou');


    bairroDao = BairroDao();

    _futureListBairros = _initFutureBairro();
    _futureEndereco = _initFutureEndereco();
    _initListEnderecos();
    super.initState();

  }

  Future<List<Bairro>> _initFutureBairro() async{
    return bairroDao.listActives(Session.getIdParceiro());
  }

  Future<Endereco> _initFutureEndereco() async{
    return _enderecoDao.get(Session.getIdParceiro());
  }

  void _initListEnderecos() async {
    Future<List<EnderecoCliente>> future = _enderecoDao.listEnderecosCliente(Session.getCliente().id);
    List<EnderecoCliente> lista;


    future.whenComplete((){
      print('LOG[EnderecoPage]:  busca de endereços - iniciou');
    }).then((list){
      print('LOG[EnderecoPage]:   busca de endereços - setou lista');
      lista = list;
    }).whenComplete((){
      if(lista.isNotEmpty){
        if (lista.length > _selects.length) {
          _selects.clear();
        }
        for (int i = 0; i < lista.length; i++) {
          if(lista[i].id == Session.getEnderecoCiente().id){
            _selects.add(true);
            _enderecoEscolhido = EnderecoCliente(
              lista[i].rua,
              lista[i].numero,
              lista[i].bairro,
              lista[i].cep,
              lista[i].nomeCidade,
              lista[i].referencia,
              lista[i].observacao,
              lista[i].idCidade,
              lista[i].idCliente,
            );
            _enderecoEscolhido.id = lista[i].id;

          }else{
            _selects.add(false);
            print('id: ${lista[i].id} - rua: ${lista[i].rua} ');
          }

        }
      }
      print('LOG[EnderecoPage]:  busca de endereços - finalizou');
    });
  }

  Future<List<EnderecoCliente>> _changeListEnderecosInFuture() async {
    Future<List<EnderecoCliente>> future = _enderecoDao.listEnderecosCliente(Session.getCliente().id);
    List<EnderecoCliente> lista;
    future.whenComplete((){
      print('LOG[_changeListEnderecosInFuture]:  busca de endereços - iniciou');
    }).then((list){
      print('LOG[_changeListEnderecosInFuture]:   busca de endereços - setou lista');
      lista = list;
    }).whenComplete((){
      if(lista.isNotEmpty){
        if (lista.length > _selects.length) {
          _selects.clear();
        }
        for (int i = 0; i < lista.length; i++) {
          if(lista[i].id == Session.getEnderecoCiente().id){
//            print('criou!!!');
            _selects.add(true);
//            _enderecoEscolhido = EnderecoCliente(
//              lista[i].rua,
//              lista[i].numero,
//              lista[i].bairro,
//              lista[i].cep,
//              lista[i].nomeCidade,
//              lista[i].referencia,
//              lista[i].observacao,
//              lista[i].idCidade,
//              lista[i].idCliente,
//            );
//            _enderecoEscolhido.id = lista[i].id;

          }else{
            _selects.add(false);
          }

//          print(lista[i].id);
        }
      }
      print('LOG[_changeListEnderecosInFuture]:  busca de endereços - finalizou');
    });



//    future.whenComplete((){
////      print('finalizou o whenComplete()');
//    }).then((lista){
//      if(lista.isNotEmpty){
////        if(lista.length > _selects.length){
////          _selects.clear();
////          for (int i = 0; i < lista.length; i++) {
////            _selects.add(false);
////          }
////        }else{
//          for (int i = 0; i < lista.length; i++) {
//            _selects.add(false);
//          }
////        }
//      }
////      print('finalizou o then()');
////      print('lista.length: ${lista.length}');
//    }).whenComplete((){
////      print('finalizou o whenComplete()');
//    });
    return future;
  }












  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                height: 230.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('images/maps_image.png')),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 30.0,
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).accentColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          )
                        ],
                      ),
                      Card(
                          elevation: 5.0,
                          child: Container(
                            width: 295.0,
                            height: 120.0,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    Session.getParceiro().nome,
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: FutureBuilder(
                                        future: _futureEndereco,
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                            case ConnectionState.none:
                                              return Center(
                                                child: Container(
                                                  width: 15.0,
                                                  height: 15.0,
                                                  alignment: Alignment.center,
                                                  child:
                                                      CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                                                    strokeWidth: 2.0,
                                                  ),
                                                ),
                                              );

                                            default:
                                              if (snapshot.hasError) {
                                                return Container(
                                                  child: Center(
                                                    child: Text(
                                                        "Endereço Indisponível!"),
                                                  ),
                                                );
                                              } else {
                                                _enderecoParceiro = snapshot.data;
                                                return Row(
                                                  children: <Widget>[
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          '${snapshot.data.rua}, ${snapshot.data.numero}'.toUpperCase(),
                                                          style: TextStyle(
                                                            color: Theme.of(context).accentColor,
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data.bairro.toUpperCase(),
                                                          style: TextStyle(
                                                            color: Theme.of(context).accentColor,
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              }
                                          }
                                        })),
                                Padding(
                                    padding: EdgeInsets.only(top: 0.0),
                                    child: OutlineButton(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).accentColor),
                                        textColor:
                                            Theme.of(context).accentColor,
                                        child: Text(
                                          'Retirar pedido no estabelecimento',
                                          style: TextStyle(fontSize: 11.0),
                                        ),
                                        onPressed: Session.getParceiro().permitirRetirarEstabelecimento == false ? null : () {
                                          if(_enderecoParceiro != null){
                                            Session.getPedido().endereco = _enderecoParceiro;
                                            Session.getPedido().entrega = false;
                                            Session.getPedido().valorEntrega = 0.0;
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                              return PagamentoPage();
                                            }));
                                            _updateSelect();
                                          }else{
                                            List<Widget> actions = List();
                                            actions.add(FlatButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK')));
                                            MessageUtil.alertMessageScreen(context,
                                                'Endereço Inválido!',
                                                'Verifique sua conexão de internet.',
                                                actions);
                                          }


//                                          print(Session.getPedido().entrega);
//                                          print(Session.getPedido().endereco.rua);
//                                          print(Session.getPedido().endereco.numero);
//                                          print(Session.getPedido().endereco.bairro);
//                                          print(Session.getPedido().endereco.referencia);
//                                          print(Session.getPedido().endereco.cidade);
//                                          print(Session.getPedido().endereco.observacao);
//                                          print(Session.getPedido().endereco.cep);



                                        })),
                              ],
                            ),
                          )),
                    ],
                  ),
                )),
            Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Onde entregar?',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15.0),
                    ),
                  ],
                )),
            FutureBuilder(
              future: _changeListEnderecosInFuture(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return
                      Center(
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          alignment: Alignment.center,
                          child:
                          CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<
                                Color>(Theme.of(context).accentColor),
                            strokeWidth: 5.0,
                          ),
                        ),
                      );

                  default:
                    if (snapshot.hasError) {
                      return
                        Container(
                          child: Center(
                            child: Text(
                                "A conexão falhou!!!"),
                          ),
                        );
                    } else {
                      return  _screenListEnderecos(snapshot);
                    }
                }




              })
//          _verifyEnderecos(),
          ],
        ),
      ),
      bottomNavigationBar: FutureBuilder(
          future: _futureListBairros,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return
//                    Container();
                    Center(
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child:
                      CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<
                            Color>(Theme.of(context).accentColor),
                        strokeWidth: 5.0,
                      ),
                    ),
                  );

                default:
                  if (snapshot.hasError) {
                    return
//                      Container();
                      Container(
                      child: Center(
                        child: Text(
                            "A conexão falhou!!!"),
                      ),
                    );
                  } else {
                    return
                      BottomAppBar(
                          child: RawMaterialButton(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("PAGAMENTO",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Theme.of(context).backgroundColor,
                                            fontWeight: FontWeight.bold)),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context).backgroundColor,
                                      size: 18.0,
                                    )
                                  ]),
                              onPressed: () {

                                if(_enderecoEscolhido != null){
                                  _futureEndereco.then((enderecoParceiro){
                                    print('************ _enderecoEscolhido.nomeCidade:${_enderecoEscolhido.nomeCidade}');
                                    print('************ enderecoParceiro.cidade: ${enderecoParceiro.cidade}');
                                    if(_enderecoEscolhido.nomeCidade.toUpperCase() == enderecoParceiro.cidade.toUpperCase()){
                                      Bairro bairro  = _verifyIsActive(snapshot.data);
                                      print('isActive: $bairro');

                                      if(bairro != null){
                                        Session.getPedido().endereco = Endereco(
                                          _enderecoEscolhido.rua,
                                          _enderecoEscolhido.numero,
                                          _enderecoEscolhido.bairro,
                                          _enderecoEscolhido.cep,
                                          _enderecoEscolhido.nomeCidade,
                                          _enderecoEscolhido.referencia,
                                          _enderecoEscolhido.observacao,
                                          _enderecoEscolhido.idCidade,
                                          _enderecoEscolhido.idCliente,
                                        );
                                        Session.getPedido().endereco.id = _enderecoEscolhido.id;
                                        Session.setEnderecoCiente(Session.getPedido().endereco);
                                        Session.saveEnderecoCiente(Session.getPedido().endereco);
                                        Session.getPedido().entrega = true;
                                        Session.getPedido().valorEntrega = double.parse(bairro.valorEntrega);

                                        print("ID: ${Session.getEnderecoCiente().id}");
                                        print("RUA: ${Session.getEnderecoCiente().rua}");

                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return PagamentoPage();
                                        }));


                                      }else{
                                        List<Widget> actions = List();
                                        actions.add(FlatButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK')));
                                        MessageUtil.alertMessageScreen(context,
                                            'Desculpe!',
                                            'O parceiro atualmente não efetua entregas nesse bairro.',
                                            actions);
                                      }


                                    }else{
                                      List<Widget> actions = List();
                                      actions.add(FlatButton(
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK')));
                                      MessageUtil.alertMessageScreen(context,
                                          'Desculpe!',
                                          'Voce atualmente está em um local inacessível para o parceiro efetuar entregas.',
                                          actions);
                                    }

                                  });
                                }else{
                                  List<Widget> actions = List();
                                  actions.add(FlatButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK')));
                                  MessageUtil.alertMessageScreen(context,
                                      'Ops!!!',
                                      'Para prosseguir é necessário selecionar um endereço para a entrega.',
                                      actions);
                                }


                              }));
//
                  }
              }

            })


    );
  }

  Bairro _verifyIsActive(dynamic data){
    print('bairro: \'${_enderecoEscolhido.bairro.toUpperCase()}\'');
            for (Bairro bairro in data) {
              if (bairro.descricao.toUpperCase() == _enderecoEscolhido.bairro.toUpperCase()) {
                print('bairro encontrado: \'${bairro.descricao.toUpperCase()}\'');
                return bairro;
              }
            }
    return null;
  }

  Widget _screenListEnderecos(AsyncSnapshot snapshot) {
    if (snapshot.data.isEmpty) {
      return Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Text(
              'Sem endereços cadastrados',
              style: TextStyle(
                color: Configuration.colorRed,
              ),
            ),

          ],
        ),
      );
    } else {
      return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _screenListTile2(context, snapshot, index);
            },
          ));
    }
  }

  Widget _screenListTile2(BuildContext context, AsyncSnapshot snapshot, int index) {
    if (index == snapshot.data.length - 1) {
      return Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Container(
                          width: 40.0,
                          height: 40.0,
                          alignment: Alignment.center,
                          child: Checkbox(
                              value: _selects[index],
                              onChanged: (value) {
                                if (value != null) {
                                  for (int i = 0; i < _selects.length; i++) {
                                    if (i == index) {
                                      setState(() {
                                        _selects[i] = value;
                                        if (_selects[i]) {
                                          _enderecoEscolhido = snapshot.data[index];
                                        } else {
                                          _enderecoEscolhido = null;
                                        }

                                        if (_enderecoEscolhido != null) {
                                          print(_enderecoEscolhido.rua);
                                        } else {
                                          print(_enderecoEscolhido);
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        _selects[i] = false;
//                                        _enderecoEscolhido = null;
                                      });
                                    }
                                  }
                                }
                              }),
                        ),
                        title: Text(
                          '${snapshot.data[index].rua}, ${snapshot.data[index].numero}'
                              ' \n${snapshot.data[index].bairro}'
                              .toUpperCase() +
                              ' - ${snapshot.data[index].referencia} - ' +
                              '${snapshot.data[index].nomeCidade}'.toUpperCase(),
                          style: TextStyle(fontSize: 11.0),
                        ),
                        trailing: Container(
                            padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  ''.replaceAll('.', ','),
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
               Container(
                child: FlatButton(
                  child: Text("Cadastrar novo endereço",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
//                   _showModalBottomSheet(context);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EnderecoSearchPage(statusPage: false,);
                    }));
                  },
                ),
              )
            ],
          ));
    } else {
      return Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    alignment: Alignment.center,
                    child: Checkbox(
                        value: _selects[index],
                        onChanged: (value) {
//                          print(index);

                          if (value != null) {
                            for (int i = 0; i < _selects.length; i++) {
//                               print(i);
                              if (i == index) {
                                setState(() {
                                  _selects[i] = value;
                                  if (_selects[i]) {
                                    _enderecoEscolhido = snapshot.data[index];
                                  } else {
                                    _enderecoEscolhido = null;
                                  }

                                  if (_enderecoEscolhido != null) {
                                    print(_enderecoEscolhido.rua);
                                  } else {
                                    print(_enderecoEscolhido);
                                  }
                                });
                              } else {
                                setState(() {
                                  _selects[i] = false;
//                                  _enderecoEscolhido = null;
                                });
                              }
                            }
                          }
                        }),
                  ),
                  title: Text(
                    '${snapshot.data[index].rua}, ${snapshot.data[index].numero}'
                        ' \n${snapshot.data[index].bairro}'
                        .toUpperCase() +
                        ' - ${snapshot.data[index].referencia} - ' +
                        '${snapshot.data[index].nomeCidade}'.toUpperCase(),
                    style: TextStyle(fontSize: 11.0),
                  ),
                  trailing: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            ''.replaceAll('.', ','),
                            style: TextStyle(fontSize: 11.0),
                          ),
                        ],
                      ))),
              Divider(
                color: Configuration.colorWrite1,
                indent: 20.0,
                height: 20.0,
              ),
            ],
          ));
    }
  }

  _updateSelect(){
    if(_selects.isNotEmpty){
      for (int i = 0; i < _selects.length; i++) {
        _selects[i] = false;
      }
    }
  }

}
