import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/produto_dao.dart';
import 'package:appfastdelivery/helper/carrinho.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:appfastdelivery/helper/produto.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';

import 'endereco_page.dart';

class CarrinhoPage extends StatefulWidget {
  final List<ItemCarrinho> lista;

  CarrinhoPage(this.lista);

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
//  ProdutoDao _produtoDao = ProdutoDao();
  Produto produto;

  List<ItemCarrinho> _itens;

  @override
  void initState() {
    _itens = widget.lista;
//    produto = Produto.internal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Seu carrinho', style: TextStyle(fontSize: 16.0)),
          centerTitle: true,
        ),
        backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
        body: Container(margin: EdgeInsets.all(10.0), child: _screenMain()),
        bottomNavigationBar: _screenBottom());
  }

  Widget _screenBottom() {
    if (_itens.isNotEmpty) {
      return BottomAppBar(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              color: Colors.white,
              height: 60.0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 35.0),
                          height: 60.0,
                          child: Padding(
                            padding: EdgeInsets.only(top: 14.0),
                            child: Text(
                              "SUB-TOTAL",
                              style: TextStyle(
                                  color: Color.fromRGBO(36, 36, 143, 1.0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(right: 35.0),
                          height: 60.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "R\$ ${FormatUtil.doubleToPrice(_calcularValorTotal())}",
                                style: TextStyle(
                                    color: Color.fromRGBO(36, 36, 143, 1.0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              Text(
                                _obterQuantidade(),
                                style: TextStyle(
                                    color: Color.fromRGBO(36, 36, 143, 1.0),
                                    fontSize: 13.5),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              )),
          RawMaterialButton(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("FINALIZAÇÃO",
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EnderecoPage();
                }));
              }),
        ],
      ));
    }
  }

  Widget _screenMain() {
    if (_itens.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shopping_cart,
                size: 55.0, color: Color.fromRGBO(0, 0, 0, 0.75)),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("Seu carrinho está vazio no momento",
                  style: TextStyle(
                      color: Color.fromRGBO(36, 36, 143, 1.0), fontSize: 18.0)),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Voltar",
                style: TextStyle(
                    color: Color.fromRGBO(36, 36, 143, 1.0),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _itens.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        child: _screenListTile(context, index));
                  }))
        ],
      );
    }
  }

  Widget _screenListTile(BuildContext context, int index) {
    if (index == _itens.length - 1) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(_itens[index].imagemProduto),
                              fit: BoxFit.cover)),
                    ),
                    title: Text("${_itens[index].descricaoProduto}",
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(36, 36, 143, 0.5))),
                    subtitle: Text("",
                        style: TextStyle(
                          fontSize: 5.0,
                        )),
                    trailing: Container(
                        child: Column(
                      children: <Widget>[
                        Text(
                            "R\$ ${FormatUtil.doubleToPrice(_itens[index].valor)}",
                            style: TextStyle(
                                fontSize: 11.0,
                                color: Color.fromRGBO(100, 100, 143, 1.0))),
                        Text(
                          "R\$ ${FormatUtil.doubleToPrice(_calcularValor(_itens[index].valor, _itens[index].quantidade))}",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(36, 36, 143, 1.0)),
                        ),
                      ],
                    )),
//              dense: true,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _preencher(_itens[index]),
                    ),
                  ),
                  _screenObservacao(_itens[index]),
                ],
              ),
            ),
            Container(
              child: FlatButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.remove_shopping_cart,
                      color: Configuration.colorRed,
                      size: 16.0,
                    ),
                    Text("Esvaziar carrinho",
                        style: TextStyle(
                            color: Configuration.colorRed,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                onPressed: () {
                  List<Widget> actions = List();
                  actions.add(FlatButton(
                    child: Text(
                      'NÃO',
                      style: TextStyle(color: Color.fromRGBO(0, 153, 51, 1.0)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ));
                  actions.add(FlatButton(
                    child: Text('SIM',
                        style:
                            TextStyle(color: Color.fromRGBO(0, 153, 51, 1.0))),
                    onPressed: () {
                      setState(() {
                        _itens = List();
                        Session.getPersistence()
                            .save(_itens, Session.getIdParceiro());
                        Session.setListaItens(_itens);
                      });
                      Navigator.of(context).pop();
                    },
                  ));
                  MessageUtil.alertMessageScreen(
                      context,
                      'Tem certeza que deseja retirar todos os produtos do carrinho?',
                      '',
                      actions);
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListTile(
              leading: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(_itens[index].imagemProduto),
                        fit: BoxFit.cover)),
              ),
              title: Text("${_itens[index].descricaoProduto}",
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(36, 36, 143, 0.5))),
              subtitle: Text("",
                  style: TextStyle(
                    fontSize: 5.0,
                  )),
              trailing: Container(
                  child: Column(
                children: <Widget>[
                  Text("R\$ ${FormatUtil.doubleToPrice(_itens[index].valor)}",
                      style: TextStyle(
                          fontSize: 11.0,
                          color: Color.fromRGBO(100, 100, 143, 1.0))),
                  Text(
                    "R\$ ${FormatUtil.doubleToPrice(_calcularValor(_itens[index].valor, _itens[index].quantidade))}",
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(36, 36, 143, 1.0)),
                  ),
                ],
              )),
//              dense: true,
            ),
            Container(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _preencher(_itens[index]),
              ),
            ),
            _screenObservacao(_itens[index]),
          ],
        ),
      );
    }

//return Container();
  }

  Widget _screenObservacao(ItemCarrinho itemCarrinho) {
    if (itemCarrinho.observacao != "") {
      return Padding(
        padding: EdgeInsets.only(bottom: 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 25.0),
              color: Color.fromRGBO(36, 36, 143, 0.2),
              alignment: Alignment.centerLeft,
              child: Text(
                "Obs: ${itemCarrinho.observacao}",
                style: TextStyle(
                    color: Color.fromRGBO(36, 36, 143, 1.0), fontSize: 10.0),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 0.0),
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${itemCarrinho.quantidade}',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(36, 36, 143, 1.0)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 7.0),
                          child: Icon(
                            Icons.navigate_next,
                            color: Color.fromRGBO(36, 36, 143, 0.2),
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Quantidade',
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(36, 36, 143, 0.4)),
                    ),
                  ],
                ),
                onPressed: () {
                  _screenSelect(itemCarrinho);
                },
              ),
            )
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 0.0),
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${itemCarrinho.quantidade}',
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(36, 36, 143, 1.0)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.0),
                        child: Icon(
                          Icons.navigate_next,
                          color: Color.fromRGBO(36, 36, 143, 0.2),
                          size: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Quantidade',
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(36, 36, 143, 0.4)),
                  ),
                ],
              ),
              onPressed: () {
                _screenSelect(itemCarrinho);
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _preencher(ItemCarrinho itemCarrinho) {
    String variacao = "";

    List<Widget> lista = List<Widget>();
    for (AdicionalEscolhido adicionalEscolhido
        in itemCarrinho.adicionaisEscolhidos) {
      if (variacao != adicionalEscolhido.descricaoVariacao) {
        variacao = adicionalEscolhido.descricaoVariacao;
        lista.add(Text(
          "$variacao",
          style: TextStyle(
              color: Color.fromRGBO(36, 36, 143, 1.0), fontSize: 11.0),
        ));
      }
      lista.add(Text(
        "   ${adicionalEscolhido.descricao}",
        style:
            TextStyle(color: Color.fromRGBO(36, 36, 143, 0.5), fontSize: 11.0),
      ));
    }

    return lista;
  }

  double _calcularValor(double valor, int quantidade) {
    return (valor * quantidade);
  }

  double _calcularValorTotal() {
    double valorTotal = 0.00;
    
    for (ItemCarrinho itemCarrinho in _itens) {
     
      valorTotal += _calcularValor(itemCarrinho.valor, itemCarrinho.quantidade);
    }
    return valorTotal;
  }

  String _obterQuantidade() {
    int quantidade = 0;
    for (ItemCarrinho itemCarrinho in _itens) {
      quantidade += itemCarrinho.quantidade;
    }

    if (quantidade > 1) {
      return '$quantidade produtos';
    } else {
      return '$quantidade produto';
    }
  }

  _screenSelect(ItemCarrinho itemCarrinho) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
            color: Color.fromRGBO(36, 36, 143, 0.9),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 260.0,
                    height: 50.0,
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Quantidade',
                            style: TextStyle(
                                color: Color.fromRGBO(36, 36, 143, 1.0),
                                fontSize: 15.0),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 230, 230, 1.0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                    ),
                  ),
                  Container(
                      width: 260.0,
                      height: 300.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              children: _listScreenSelect(itemCarrinho),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    width: 260.0,
                    height: 50.0,
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            color: Color.fromRGBO(185, 0, 0, 1.0),
                            size: 16.0,
                          ),
                          Text(
                            'Remover produto',
                            style: TextStyle(
                                color: Color.fromRGBO(185, 0, 0, 1.0),
                                fontSize: 12.0),
                          )
                        ],
                      ),
                      onPressed: () {
                        List<Widget> actions = List();
                        actions.add(FlatButton(
                          child: Text(
                            'NÃO',
                            style: TextStyle(
                                color: Color.fromRGBO(0, 153, 51, 1.0)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ));
                        actions.add(FlatButton(
                          child: Text('SIM',
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 153, 51, 1.0))),
                          onPressed: () {
                            setState(() {
                              _itens.remove(itemCarrinho);
                              Session.getPersistence()
                                  .save(_itens, Session.getIdParceiro());
                              Session.setListaItens(_itens);
                            });
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ));

                        MessageUtil.alertMessageScreen(
                            context,
                            'Quer mesmo remover o produto?',
                            '${itemCarrinho.quantidade}x ${itemCarrinho.descricaoProduto}',
                            actions);
//
//                            Session.setListaItens(_itens);
//                            Session.getPersistence().save(_itens, Session.getIdParceiro());
//                            Navigator.of(context).pop();
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 230, 230, 1.0),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    width: 220.0,
                    child: OutlineButton(
                        child: Text("Fechar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(200, 200, 200, 1.0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        onPressed: () {
//                            setState(() {
//                              _quantidade = 1;
//                            });
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  List<Widget> _listScreenSelect(ItemCarrinho itemCarrinho) {
    List<Widget> listSelect = List();
    for (int i = 1; i <= 50; i++) {
      listSelect.add(
        FlatButton(
          child: Text(
            '$i',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              itemCarrinho.quantidade = i;
              print(itemCarrinho.quantidade);
            });

            Session.setListaItens(_itens);
            Session.getPersistence().save(_itens, Session.getIdParceiro());
            Navigator.pop(context);
          },
        ),
      );
    }
    return listSelect;
  }
}
