//import 'package:appfastdelivery/dao/parceiro_dao.dart';
//import 'package:appfastdelivery/util/image_utils.dart';
//import 'package:flutter/material.dart';
//import 'package:appfastdelivery/dao/categoria_dao.dart';
//import 'package:appfastdelivery/helper/categoria.dart';
//import 'package:appfastdelivery/helper/favorito.dart';
//import 'package:appfastdelivery/helper/parceiro.dart';
//import 'package:appfastdelivery/ui/parceiro_info_page.dart';
//import 'package:appfastdelivery/ui/produto_page.dart';
//import 'package:appfastdelivery/ui/subcategoria_page.dart';
//import 'package:appfastdelivery/util/configuration.dart';
//import 'package:appfastdelivery/util/format_util.dart';
//import 'package:appfastdelivery/util/json_utils.dart';
//import 'package:appfastdelivery/util/session.dart';
//
//import 'carrinho_page.dart';
//
//class ParceiroPage1 extends StatefulWidget {
//  Parceiro parceiro;
//
//  ParceiroPage1(this.parceiro);
//
//  ParceiroPage1.internal();
//
//  @override
//  _ParceiroPage1State createState() => _ParceiroPage1State();
//}
//
//class _ParceiroPage1State extends State<ParceiroPage1> {
//  Parceiro _parceiro;
//  int _idCliente;
//  bool _favorito = false;
//  CategoriaDao categoriaDao = CategoriaDao();
//  bool _first = true;
//  List<BoxShadow> boxShadow = List();
//
//  String _valorEntrega;
//  String _situacaoText = '';
//  Color _situacaoColor;
//  String _horario;
//  String _aceitaCartao = "";
//  Future<List<Categoria>> _futureCategoria;
//
//  @override
//  void initState() {
//    super.initState();
//    _parceiro = widget.parceiro;
//     _idCliente = Session.getCliente().id;
////    JsonUtils.isFavorito(idcliente: _idCliente, idparceiro: _parceiro.id)
////        .then((isFavorito) {
////      setState(() {
////        _favorito = isFavorito;
////      });
////    });
//    ParceiroDao.internal().isFavorito(idcliente: _idCliente, idparceiro: _parceiro.id).then((favorito){
//      setState(() {
//        _favorito = favorito;
//      });
//    });
//    verificarDadosParceiro();
//    boxShadow
//        .add(BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 2.0));
//
//    _futureCategoria = initFutureCategoria();
//
//
//    categoriaDao.list(_parceiro.id);
//  }
//
//  Future<List<Categoria>> initFutureCategoria() async{
//    return categoriaDao.list(_parceiro.id);
//  }
//
//  void verificarDadosParceiro() {
//    if (_parceiro.valoresEntrega == "Grátis" &&
//        _parceiro.valoresEntrega != null) {
//      _valorEntrega = "Gratuita";
//    } else {
//      _valorEntrega = _parceiro.valoresEntrega.replaceAll('.', ',');
//    }
//    if (_parceiro.situacao) {
//      _situacaoText = "ABERTO";
//      _situacaoColor = Configuration.colorGreen;
////      _situacaoColor = Color.fromRGBO(31, 122, 31, 1.0);
//      _horario = "fecha às ${_parceiro.fechamento}";
//    } else {
//      _situacaoText = "FECHADO";
//      _situacaoColor =  Configuration.colorRed;
//      _horario = "abre às ${_parceiro.abertura}";
//    }
//
//    if (_parceiro.isCartao) {
//      _aceitaCartao = "Aceitamos Cartão";
//    } else {
////      _aceitaCartao = "";
//    }
//  }
//
//  Widget _verificarIconeCartao() {
//    if (_parceiro.isCartao) {
//      return Icon(Icons.credit_card,
//        color: Configuration.colorBlack,
//      );
//    }
//    return Padding(padding: EdgeInsets.only(right: 70));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
////        backgroundColor: Color(0xff6200ee),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.info), onPressed: () {
//            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              return ParceiroInfoPage(_parceiro);
//            }));
//          }),
//          //IconButton(icon: Icon(Icons.search), onPressed: () {})
//        ],
//      ),
//
////        body: SingleChildScrollView(
//
//      body: Container(
//          child: Column(
//          children: <Widget>[
//              Container(
//              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
//  //            decoration: BoxDecoration(
//  //                borderRadius: BorderRadius.only(
//  //                    topLeft: Radius.circular(5.0),
//  //                    topRight: Radius.circular(5.0)),
//  //                image: DecorationImage(
//  //                    colorFilter: ColorFilter.mode(
//  //                        Colors.black.withOpacity(0.7), BlendMode.darken),
//  //                    fit: BoxFit.cover,
//  //                    image: NetworkImage(_parceiro.imagemBackground))
//  //            ),
//
//              decoration: BoxDecoration(
//                boxShadow: boxShadow,
//              ),
//
//              child:
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: <Widget>[
//                  Column(
//                    children: <Widget>[
////                      Row(
////                        children: <Widget>[
////                          Padding(
////                            padding: EdgeInsets.only(left: 0.0, right: 30.0),
////                            child: Column(
////                              children: <Widget>[
////
////                                Text(
////                                  _situacaoText,
////                                  style: TextStyle(
////                                      fontWeight: FontWeight.bold,
////                                      color: _situacaoColor,
////                                      fontSize: 15.0),
////                                  textAlign: TextAlign.center,
////                                ),
////                                Text(
////                                  _horario,
////                                  style: TextStyle(fontSize: 10.0),
////                                  textAlign: TextAlign.center,
////                                )
////                              ],
////                            ),
////                          ),
////
////                          Column(
////                            children: <Widget>[
////                              Container(
////                                width: 90.0,
////                                height: 90.0,
////                                decoration: BoxDecoration(
////                                    shape: BoxShape.circle,
////                                    image: DecorationImage(
////                                        fit: BoxFit.cover,
////                                        image: ImageUtil.loadWithRetry(_parceiro.imagemLogo))),
////  //                                          NetworkImage(_parceiro.imagemLogo))),
////                              ),
////                              Padding(
////                                padding: EdgeInsets.only(top: 10.0, bottom: 3.0),
////                                child: Text(
////                                  "${_parceiro.nome}",
////                                  style: TextStyle(
////                                      fontWeight: FontWeight.bold,
////                                      fontSize: 15.0,
////                                      color: Theme.of(context).accentColor),
////                                  textAlign: TextAlign.center,
////                                ),
////                              ),
////                            ],
////                          ),
////
////                          Padding(
////                              padding: EdgeInsets.only(left: 30.0, right: 0.0),
////                              child: Column(
////                                children: <Widget>[
////                                  Text(
////                                    "ENTREGA",
////                                    style: TextStyle(
////                                        fontWeight: FontWeight.bold,
////                                        fontSize: 15.0),
////                                    textAlign: TextAlign.center,
////                                  ),
////                                  Text(
////                                    "${_parceiro.estimativaEntrega}",
////                                    style: TextStyle(fontSize: 12.0),
////                                    textAlign: TextAlign.center,
////                                  ),
////                                  Text(_valorEntrega,
////                                    style: TextStyle(
////                                        fontSize: 12.0,
////                                        color: Configuration.colorGreen),
////                                    textAlign: TextAlign.center,
////                                  )
////                                ],
////                              )),
////                        ],
////                      ),
////                      Row(
////                        mainAxisAlignment: MainAxisAlignment.center,
////                        children: <Widget>[
////                          Text(
////                            "${_parceiro.descricao}",
////                            style: TextStyle(fontSize: 12.0),
////                            textAlign: TextAlign.center,
////                          ),
////                        ],
////                      ),
////                      Padding(
////                          padding: EdgeInsets.all(0.0),
////                          child: Row(
////                            mainAxisAlignment: MainAxisAlignment.center,
////                            children: <Widget>[
////                              Column(
////                                crossAxisAlignment: CrossAxisAlignment.center,
////                                children: <Widget>[
////                                  Text(
////                                    "${_parceiro.descricao}",
////                                    style: TextStyle(fontSize: 12.0),
////                                    textAlign: TextAlign.center,
////                                  ),
////                                  Padding(
////                                      padding: EdgeInsets.only(
////                                          top: 7.0, bottom: 7.0, left: 100),
////                                      child: Row(
////                                        //crossAxisAlignment: CrossAxisAlignment.end,
////                                        children: <Widget>[
////                                          Column(
////                                            crossAxisAlignment:
////                                                CrossAxisAlignment.center,
////                                            children: <Widget>[
////                                              _verificarIconeCartao(),
////                                              Text(
////                                                "${_aceitaCartao}",
////                                                style: TextStyle(fontSize: 10.0),
////                                                textAlign: TextAlign.center,
////                                              ),
////                                            ],
////                                          ),
////                                          Padding(padding: EdgeInsets.only(right: 30),),
////                                        _botaoFavorito(),
////                                        ],
////                                      )),
////                                ],
////                              ),
////                            ],
////                          )),
//
//
//
//
////      Container(
////          child: Column(
////        children: <Widget>[
////          Container(
////            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
////            decoration: BoxDecoration(
////                borderRadius: BorderRadius.only(
////                    topLeft: Radius.circular(5.0),
////                    topRight: Radius.circular(5.0)),
////                image: DecorationImage(
////                    colorFilter: ColorFilter.mode(
////                        Colors.black.withOpacity(0.7), BlendMode.darken),
////                    fit: BoxFit.cover,
////                    image: NetworkImage(_parceiro.imagemBackground))
////            ),
////
//////            decoration: BoxDecoration(
//////              boxShadow: boxShadow,
//////            ),
////
////
//
////          ),
//
////        ],
////      )),
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
//                    ],
//                  ),
//                ],
//              ),
//            ),
//
//              Expanded(
//                child:
//                FutureBuilder(
//                    future: _futureCategoria,
//                    builder: (BuildContext context, AsyncSnapshot snapshot) {
//                      switch (snapshot.connectionState) {
//                        case ConnectionState.waiting:
//                        case ConnectionState.none:
//                          return  Center(
//                            child: Container(
//                              width: 200.0,
//                              height: 200.0,
//                              alignment: Alignment.center,
//                              child: CircularProgressIndicator(
//                                valueColor:
//                                AlwaysStoppedAnimation<Color>(Colors.indigo),
//                                strokeWidth: 5.0,
//                              ),
//                            ),
//                          );
//                        default:
//                          if (snapshot.hasError) {
//                            return Container(
//                              child: Center(
//                                child: Text("A Conexão Falhou!"),
//                              ),
//                            );
//                          } else {
//                            return _gridCategorias(context, snapshot);
//                          }
//                      }
//                    })
//
//            ),
//          ],
//      )),
//
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.shopping_cart),
////        backgroundColor: Color.fromRGBO(36, 36, 143, 1.0),
//        onPressed: () {
////          print('ANTES DO FOR');
////          for (ItemCarrinho item in Session.getListaItens()){
////            print('${item.descricaoProduto} - ${item.observacao}');
////          }
////          print('DEPOIS DO FOR');
//
//          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//            return CarrinhoPage(Session.getListaItens());
//          }));
//        },
//      ),
//    );
//  }
//
//  Widget _gridScreen() {
//    return null;
//  }
//
//  Widget _botaoFavorito() {
//    if (_favorito) {
//      return FlatButton(
//        child: Icon(
//          Icons.favorite,
//          color: Colors.red,
//        ),
//        onPressed: () {
//          JsonUtils.Favoritar(
//              favorito: Favorito(_idCliente, _parceiro.id, false),
//              context: context);
//          setState(() {
//            _favorito = false;
//          });
//        },
//      );
//    } else {
//      return FlatButton(
//        child: Icon(
//          Icons.favorite_border,
//          color: Theme.of(context).accentColor,
//        ),
//        onPressed: () {
//          JsonUtils.Favoritar(
//              favorito: Favorito(_idCliente, _parceiro.id, true),
//              context: context);
//          setState(() {
//            _favorito = true;
//          });
//        },
//      );
//    }
//  }
//
//  Widget _gridCategorias(BuildContext context, AsyncSnapshot snapshot) {
//    return GridView.builder(
//        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//            crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
//        itemCount: snapshot.data.length,
//        itemBuilder: (context, index) {
//          return GestureDetector(
//            onTap: () {
//              if (snapshot.data[index].hasSubCategoria) {
//                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                  return SubCategoriaPage(snapshot.data[index]);
//                }));
//              } else {
//                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                  return ProdutoPage.categoria(snapshot.data[index]);
////                  return null;
//                }));
//              }
//            },
//            child: Container(
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Container(
//                    width: 60.0,
//                    height: 60.0,
//                    decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        image: DecorationImage(
//                            fit: BoxFit.cover,
//                            image: ImageUtil.loadWithRetry(snapshot.data[index].image)),
//                        border: Border.all(
//                            color: Theme.of(context).accentColor,
//                            width: 2.0,
//                            style: BorderStyle.solid)),
//                  ),
//                  SizedBox(height: 7.0),
////                  Padding(
////                    padding: EdgeInsets.only(top: 10.0),
////                    child:
//                    Text(
//                      snapshot.data[index].descricao,
//                      textAlign: TextAlign.center,
//                      style: TextStyle(
//                          fontSize: 15.0,
//                          fontWeight: FontWeight.bold,
//                          color: Theme.of(context).accentColor,
//                    ),
////                    ),
//                  )
//                ],
//              ),
//            ),
//          );
//        });
//  }
//}
