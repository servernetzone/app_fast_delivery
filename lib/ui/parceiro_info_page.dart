import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appfastdelivery/dao/forma_pagamento_dao.dart';
import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/forma_pagamento.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:appfastdelivery/util/session.dart';

class ParceiroInfoPage extends StatefulWidget {
  Parceiro parceiro;

  ParceiroInfoPage(this.parceiro);

  @override
  _ParceiroInfoPageState createState() => _ParceiroInfoPageState();
}

class _ParceiroInfoPageState extends State<ParceiroInfoPage> {
  FormaPagamentoDao _formaPagamentoDao = FormaPagamentoDao();
  Future<List<FormaPagamento>> _future;
  Parceiro _parceiro;
  bool _verTelefone;
  String _telefone;
  Future<List<dynamic>> _futureEndereco;

  static Future<List<dynamic>> getEndereco(int id) async {
    var data = await http.get((Factory.internal().getUrl() + "parceiros/$id/"),
        headers: {'Accept': 'application/json'});
    dynamic jsonDataList = json.decode(utf8.decode(data.bodyBytes));

    return jsonDataList;
  }

  @override
  void initState() {
    super.initState();
    _future = _initFuture();
    _parceiro = widget.parceiro;
    _telefone = 'Ver telefone';
    _verTelefone = false;
    _futureEndereco = _initFutureEndereco();
  }

  Future<List<FormaPagamento>> _initFuture() async {
    return _formaPagamentoDao.list(Session.getIdParceiro());
  }

  Future<List<dynamic>> _initFutureEndereco() async {
    return getEndereco(_parceiro.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Info', style: TextStyle(
              fontSize: 16.0)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FutureBuilder(
                    future: _futureEndereco,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Center(
                              child: Container(
                                width: 200.0,
                                height: 200.0,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor),
                                  strokeWidth: 5.0,
                                ),
                              ));
                        default:
                          if (snapshot.hasError) {
                            return Container(
                              height: 500.0,
                              child: Center(
                                  child: Text('A conexão falhou!')
                              ),
                            );
                          } else {
                            return _screenPageInfo(context, snapshot);
                          }
                      }
                    },
                  ),
                  FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Container();
                          default:
                            if (snapshot.hasError) {
                              return Container();
                            } else {
                              return _screenPageList(context, snapshot);
                            }
                        }
                      })
                ]),
          ),
        ));
  }


  Widget _screenPageInfo(BuildContext context, AsyncSnapshot snapshot){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin:
                    EdgeInsets.only(bottom: 5.0),
                    height: 90.0,
                    width: 90.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: ImageUtil.loadWithRetry(_parceiro.imagemLogo)),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "${_parceiro.nome}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Theme.of(context)
                            .accentColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "${_parceiro.descricao}",
                    style: TextStyle(fontSize: 12.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text(
              '${snapshot.data[0]['endereco']['rua'].toUpperCase()}, ${snapshot.data[0]['endereco']['numero']}',
              style: TextStyle(fontSize: 13.0),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Text(
              snapshot.data[0]['endereco']['bairro']
                  .toUpperCase(),
              style: TextStyle(fontSize: 13.0),
              textAlign: TextAlign.center,
            ),
          ),
          FlatButton(
            child: Text(
              _telefone,
              style: TextStyle(
                  fontSize: 14.0, color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              if (_verTelefone) {
                String url =
                    'tel:${snapshot.data[0]['telefone']}';
                canLaunch(url).then((bool) {
                  launch(url).then((value) {});
                });
              } else {
                setState(() {
                  _verTelefone = true;
                  _telefone =
                  '${snapshot.data[0]['telefone'].toString()}';
                });
              }
            },
          ),
        ],
      ),
    );
  }



  Widget _screenPageList(BuildContext context, AsyncSnapshot snapshot){
    return  Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: 10.0, top: 10.0),
          child: Text(
            'FORMAS DE PAGAMENTO',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
        ),
      ),
      formaDePagamentoWidget(snapshot, 'DINHEIRO'),
      Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Text(
          'CRÉDITO',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 10),
        ),
      ),
      formaDePagamentoWidget(snapshot, 'CREDITO'),
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(
          'DÉBITO',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 10),
        ),
      ),
      formaDePagamentoWidget(snapshot, 'DEBITO'),
    ]);
  }


  Widget formaDePagamentoWidget(AsyncSnapshot snapshot, String tipo) {
    List<Widget> lista = List<Widget>();
    for (FormaPagamento formaPagamento in snapshot.data) {
      if (formaPagamento.tipo.toUpperCase() == tipo) {
        lista.add(Container(
          margin: EdgeInsets.only(right: 5.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: ImageUtil.loadWithRetry(formaPagamento.imagem))),
              ),
              Text(
                formaPagamento.descricao,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
        ));
      }
    }
    return Container(
        height: 60.0,
        child: ListView(scrollDirection: Axis.horizontal, children: lista));
  }
}
