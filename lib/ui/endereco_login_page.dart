import 'dart:async';

import 'package:appfastdelivery/dao/bairro_dao.dart';
import 'package:appfastdelivery/dao/endereco_dao.dart';
import 'package:appfastdelivery/helper/parceiros_model.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:appfastdelivery/ui/home_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'endereco_search_page.dart';

class EnderecoLoginPage extends StatefulWidget {
  static const String routeName = '/EnderecoLoginPage';

  bool modal;

  EnderecoLoginPage({this.modal = false});

  @override
  _EnderecoLoginPageState createState() => _EnderecoLoginPageState();
}

class _EnderecoLoginPageState extends State<EnderecoLoginPage> {
  bool get modal => widget.modal;
  EnderecoDao _enderecoDao = EnderecoDao();
  BairroDao bairroDao;
  StreamController streamController;
  List<bool> _selects = List();
  EnderecoCliente _enderecoEscolhido = null;

  @override
  void initState() {
    bairroDao = BairroDao();
    super.initState();
    streamController = StreamController<List<EnderecoCliente>>();
    _buscarEnderecos();
  }

  void _buscarEnderecos() async {
    var lista = await _initListEnderecos();
    streamController.add(lista);
  }

  Future<List<EnderecoCliente>> _initListEnderecos() async {
    Future<List<EnderecoCliente>> future =
        _enderecoDao.listEnderecosCliente(Session.getCliente().id);
    List<EnderecoCliente> lista = List();

    future.whenComplete(() {}).then((list) {
      lista = list;
    }).whenComplete(() {
      if (lista.isNotEmpty) {
        if (lista.length > _selects.length) {
          _selects.clear();
        }
        for (int i = 0; i < lista.length; i++) {
          _selects.add(false);
        }
      } else {
        print('lista de endereços vazia!');
      }
    });

    return future;
  }

  @override
  Widget build(BuildContext context) {
    if (modal) {
      return _body(context);
    }
    return Scaffold(
      body: _body(context),
    );
  }

  Container _body(BuildContext context) {
    return Container(
      margin: modal
          ? EdgeInsets.only(right: 8, left: 8) : EdgeInsets.zero,
      height: modal
          ? MediaQuery.of(context).size.height * 0.75
          : MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(150, 20, 150, 20),
            child: modal
                ? Container(
                    height: 8,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadiusDirectional.all(
                            const Radius.circular(8))),
                  )
                : null,
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Onde entregar?',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 22.0),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: streamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).accentColor),
                        strokeWidth: 5.0,
                      ),
                    ),
                  );

                default:
                  if (snapshot.hasError) {
                    return Container(
                      child: Center(
                        child: Text("A conexão falhou!!!"),
                      ),
                    );
                  } else {
                    print('idCliente: ${Session.getCliente()}');
                    return _screenListEnderecos(snapshot);
                  }
              }
            },
          ),
          Session.getCliente().id == 1070
              ? Container()
              : Container(
                  color: Theme.of(context).accentColor,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return EnderecoSearchPage(statusPage: true);
                          },
                        ),
                      );
                    },
                    title: Text(
                      "Cadastrar novo endereço",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _selecionar(BuildContext context) {
    if (_enderecoEscolhido != null) {
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
      Navigator.of(context).pop();
    }
  }

  Widget _screenListEnderecos(AsyncSnapshot snapshot) {
    if (snapshot.data.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sem endereços cadastrados',
                style: TextStyle(
                  color: Configuration.colorRed,
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return _screenTile(context, snapshot, index);
          },
        ),
      );
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
                  onTap: () {
                    _enderecoEscolhido = snapshot.data[index];
                    print(_enderecoEscolhido.nomeCidade);
                    var enderecoCliente = Session.getEnderecoCiente();
                    if (enderecoCliente != null && enderecoCliente.cidade !=
                        _enderecoEscolhido.nomeCidade) {
                      _selecionar(context);

                      Provider.of<ParceirosModel>(context, listen: false)
                          .getParceiros();
                    }else {
                      _selecionar(context);
                    }
                    if (!modal) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return HomePage();
                          },
                        ),
                        (routes) {
                          return false;
                        },
                      );
                    }
                  },
                  title: Text(
                    Session.getCliente().id == 1070
                        ? '${snapshot.data[index].bairro} - ${snapshot.data[index].nomeCidade}'
                        : '${snapshot.data[index].rua}, ${snapshot.data[index].numero}'
                                    ' \n${snapshot.data[index].bairro}'
                                .toUpperCase() +
                            ' - ${snapshot.data[index].referencia} - ' +
                            '${snapshot.data[index].nomeCidade}'.toUpperCase(),
                    style: TextStyle(fontSize: 11.0),
                  ),
                  leading: Icon(Icons.place),
                ),
                Divider(
                  color: Configuration.colorWrite1,
                  indent: 20.0,
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ));
    } else {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.place),
                onTap: () {
                  _enderecoEscolhido = snapshot.data[index];
                  var enderecoCliente = Session.getEnderecoCiente();
                  if (enderecoCliente != null && enderecoCliente.cidade !=
                      _enderecoEscolhido.nomeCidade) {
                    _selecionar(context);

                    Provider.of<ParceirosModel>(context, listen: false)
                        .getParceiros();
                  }else {
                    _selecionar(context);
                  }
                  if (!modal) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return HomePage();
                        },
                      ),
                      (routes) {
                        return false;
                      },
                    );
                  }
                },
                title: Text(
                  Session.getCliente().id == 1070
                      ? '${snapshot.data[index].bairro} - ${snapshot.data[index].nomeCidade}'
                      : '${snapshot.data[index].rua}, ${snapshot.data[index].numero}'
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
        ),
      );
    }
  }
}
