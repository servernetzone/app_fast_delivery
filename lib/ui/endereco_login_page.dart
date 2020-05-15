import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/bairro_dao.dart';
import 'package:appfastdelivery/dao/endereco_dao.dart';
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';

import 'endereco_search_page.dart';
import 'home_page.dart';

class EnderecoLoginPage extends StatefulWidget {
  static const String routeName = '/EnderecoLoginPage';

  bool select = false;

  EnderecoLoginPage({this.select : false});
  EnderecoLoginPage.select({this.select : false});


  @override
  _EnderecoLoginPageState createState() => _EnderecoLoginPageState();
}

class _EnderecoLoginPageState extends State<EnderecoLoginPage> {
  EnderecoDao _enderecoDao = EnderecoDao();
  BairroDao bairroDao;

  bool _selected = false;
//  int _length = 3;
  List<bool> _selects = List();
  List<Endereco> _enderecos;
  EnderecoCliente _enderecoEscolhido = null;

  Endereco _endereco;


  Future<List<Bairro>> _futureListBairros;
  Future<Endereco> _futureEndereco;
//  Future<List<EnderecoCliente>> _futureListEnderecos;

  @override
  void initState() {
    bairroDao = BairroDao();
    _futureEndereco = _initFutureEndereco();

    super.initState();
//    print("ID: ${Session.getEnderecoCiente().id}");
//    print("RUA: ${Session.getEnderecoCiente().rua}");

  }

  Future<Endereco> _initFutureEndereco() async{
    return Session.getEnderecoCienteInFuture();
  }

  Future<List<EnderecoCliente>> _initListEnderecos() async {
    Future<List<EnderecoCliente>> future = _enderecoDao.listEnderecosCliente(Session.getCliente().id);
    List<EnderecoCliente> lista = List();

    future.whenComplete((){
//      print('LOG[EnderecoLoginPage]:  busca de endereços - iniciou');
    }).then((list){
//      print('LOG[EnderecoLoginPage]:   busca de endereços - setou lista');
      lista = list;
    }).whenComplete((){
      if(lista.isNotEmpty){
        if (lista.length > _selects.length) {
          _selects.clear();
        }
        for (int i = 0; i < lista.length; i++) {
          _selects.add(false);
        }
      }else{
        print('lista de endereços vazia!');
      }
//      print('LOG[EnderecoLoginPage]:  busca de endereços - finalizou');
    });

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
                                    if(widget.select){
                                      Navigator.of(context).pop();
                                    }
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
                                      'Endereço atualmente selecionado',
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
                                                      valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Theme.of(context).accentColor),
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

//                                                          RaisedButton(
//                                                            child: Text('Limpar'),
//                                                              onPressed: () {
//
//                                                                  Session.setEnderecoCiente(null);
//                                                                  Session.clearEnderecoCiente();
//                                                                  print('limpou');
//                                                              }
//                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                }
                                            }
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
                        'Qual envio prefere?',
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 15.0),
                      ),
                    ],
                  )),
              FutureBuilder(
                  future: _initListEnderecos(),
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
//                      Container();
                            Container(
                              child: Center(
                                child: Text(
                                    "A conexão falhou!!!"),
                              ),
                            );
                        } else {
//                          print(snapshot.data);
                          print('idCliente: ${Session.getCliente()}');
                          return  _screenListEnderecos(snapshot);
                        }
                    }




                  })
//          _verifyEnderecos(),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: RawMaterialButton(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("PROSSEGUIR",
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
                onPressed:  () {

                  if(_enderecoEscolhido != null){
                    Endereco endereco = Endereco(
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
                    endereco.id = _enderecoEscolhido.id;
                    Session.setEnderecoCiente(endereco);
                    Session.saveEnderecoCiente(endereco);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {

                      return HomePage();
                    }),(routes){
                      return false;
                    });
                    print("ID: ${Session.getEnderecoCiente().id}");
                    print("RUA: ${Session.getEnderecoCiente().rua}");



                  } else{
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
                }
                )),
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
            SizedBox(height: 30.0),
            Session.getCliente().id == 1070 ? Container():
            FlatButton(
              child: Text("Cadastrar novo endereço",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EnderecoSearchPage(statusPage: true,);
                }));
              },
            ),
          ],
        ),
      );
    } else {
      return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _screenTile(context, snapshot, index);
            },
          ));
    }
  }



  Widget _screenTile(BuildContext context, AsyncSnapshot snapshot, int index) {
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
//                          print(index);
                                if (value != null) {
//                                  print(_selects.length);
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
//                                        _enderecoEscolhido = null;
                                      });
                                    }
                                  }
                                }
                              }),
                        ),
                        title: Text(Session.getCliente().id == 1070
                            ? '${snapshot.data[index].bairro} - ${snapshot.data[index].nomeCidade}'
                            :
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
              Session.getCliente().id == 1070 ? Container():
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
                      return EnderecoSearchPage(statusPage: true);
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
                  title: Text(Session.getCliente().id == 1070
                      ? '${snapshot.data[index].bairro} - ${snapshot.data[index].nomeCidade}'
                      :
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
