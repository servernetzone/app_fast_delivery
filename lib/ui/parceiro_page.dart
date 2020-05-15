import 'package:appfastdelivery/dao/parceiro_dao.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/categoria_dao.dart';
import 'package:appfastdelivery/helper/categoria.dart';
import 'package:appfastdelivery/helper/favorito.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/ui/parceiro_info_page.dart';
import 'package:appfastdelivery/ui/produto_page.dart';
import 'package:appfastdelivery/ui/subcategoria_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/json_utils.dart';
import 'package:appfastdelivery/util/session.dart';

import 'carrinho_page.dart';

class ParceiroPage extends StatefulWidget {
  Parceiro parceiro;

  ParceiroPage(this.parceiro){
    Session.setParceiro(this.parceiro);
    Session.setIdParceiro(this.parceiro.id);
    print("this.parceiro.permitirRetirarEstabelecimento: ${this.parceiro.permitirRetirarEstabelecimento}");
  }
  ParceiroPage.internal();

  @override
  _ParceiroPageState createState() => _ParceiroPageState();
}

class _ParceiroPageState extends State<ParceiroPage> {
  Parceiro _parceiro;
  int _idCliente;
  bool _favorito = false;
  CategoriaDao categoriaDao = CategoriaDao();
  bool _first = true;
  List<BoxShadow> boxShadow = List();

  String _valorEntrega;
//  String _situacaoText = '';
//  Color _situacaoColor;
  String _horario;
  String _aceitaCartao = "";
  Future<List<Categoria>> _futureCategoria;

  List _listData = [];

  @override
  void initState() {

    _parceiro = widget.parceiro;

     _idCliente = Session.getCliente().id;
//    JsonUtils.isFavorito(idcliente: _idCliente, idparceiro: _parceiro.id)
//        .then((isFavorito) {
//      setState(() {
//        _favorito = isFavorito;
//      });
//    });
    ParceiroDao.internal().isFavorito(idcliente: _idCliente, idparceiro: _parceiro.id).then((favorito){
      setState(() {
        _favorito = favorito;
      });
    });

    verificarDadosParceiro();
    boxShadow.add(BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 2.0));

    _futureCategoria = initFutureCategoria();


    categoriaDao.list(_parceiro.id);
      super.initState();
  }

  int _atualizarItensCarrinho(){
    Session.getCarrinho(Session.getIdParceiro()).then((itens){
      return itens.length;
    });
  }


  Future<List<Categoria>> initFutureCategoria() async{
    return categoriaDao.list(_parceiro.id);
  }

  void verificarDadosParceiro() {
    if (_parceiro.valoresEntrega == "Grátis" &&
        _parceiro.valoresEntrega != null) {
      _valorEntrega = "Gratuita";
    } else {
      _valorEntrega = _parceiro.valoresEntrega.replaceAll('.', ',');
    }
//    if (_parceiro.situacao) {
////      _situacaoText = "ABERTO";
////      _situacaoColor = Configuration.colorGreen;
////      _situacaoColor = Color.fromRGBO(31, 122, 31, 1.0);
//      _horario = "fecha às ${_parceiro.fechamento}";
//    } else {
////      _situacaoText = "FECHADO";
////      _situacaoColor =  Configuration.colorRed;
//      _horario = "abre às ${_parceiro.abertura}";
//    }

    if (_parceiro.isCartao) {
      _aceitaCartao = "Aceitamos Cartão";
    } else {
//      _aceitaCartao = "";
    }
  }

  Widget _verificarIconeCartao() {
    if (_parceiro.isCartao) {
      return Icon(Icons.credit_card,
        color: Configuration.colorBlack,
      );
    }
    return Padding(padding: EdgeInsets.only(right: 70));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
//        color: Colors.green,
        child:
       RefreshIndicator(
           child: CustomScrollView(
             slivers: <Widget>[
               SliverAppBar(
                 pinned: false,
                 floating: true,
    //              forceElevated: true,
                 snap: false,
                 actions: <Widget>[
                   IconButton(icon: Icon(Icons.info), onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                       return ParceiroInfoPage(_parceiro);
                     }));
                   }),
                 ],
               ),
               SliverToBoxAdapter(
                   child:
                   Container(
                     margin: EdgeInsets.all(5.0),
                     child:
    //                Row(
    ////                  mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                  children: <Widget>[
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         SizedBox(height: 10.0),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: <Widget>[
                             Padding(
                               padding: EdgeInsets.only(left: 7.0, right: 0.0),
                               child: Column(
                                 children: <Widget>[
                                   Text(FormatUtil.doubleToStringTwoReplaced(_parceiro.classificacao),
                                     style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: Colors.yellow[900],
                                         fontSize: 15.0),
                                     textAlign: TextAlign.center,
                                   ),
                                   SizedBox(height: 3.0),
                                   Row(
                                     children: _screenContentAvaliacoes(_parceiro.classificacao),
                                   ),
                                   SizedBox(height: 10.0),
                                   Text(
                                     _parceiro.situacao == true
                                         ? 'ABERTO'
                                         : 'FECHADO',
                                     style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: _parceiro.situacao == true
                                             ? Configuration.colorGreen
                                             : Configuration.colorRed,
                                         fontSize: 15.0),
                                     textAlign: TextAlign.center,
                                   ),
                                   SizedBox(height: 3.0),
                                   Text(
                                     _parceiro.situacao == true
                                         ? "fecha às ${_parceiro.fechamento}"
                                         : "abre às ${_parceiro.abertura}",
                                     style: TextStyle(fontSize: 10.0),
                                     textAlign: TextAlign.center,
                                   )
                                 ],
                               ),
                             ),


                             Container(
                               width: 100.0,
                               height: 90.0,
                               decoration: BoxDecoration(
                                   shape: BoxShape.rectangle,
                                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                   
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(10.0),
//                                       topRight: Radius.circular(10.0),
//                                       bottomLeft: Radius.circular(10.0),
//                                       bottomRight: Radius.circular(10.0)
//                                   ),
                                   image: DecorationImage(
                                     fit: BoxFit.cover,
                                     image: ImageUtil.loadWithRetry(_parceiro.imagemLogo),
                                   )
                               ),
                             ),

                             Padding(
                                 padding: EdgeInsets.only(left: 0.0, right: 7.0),
                                 child: Column(
                                   children: <Widget>[
                                     Text(
                                       "ENTREGA",
                                       style: TextStyle(
                                           fontWeight: FontWeight.bold,
                                           fontSize: 15.0),
                                       textAlign: TextAlign.center,
                                     ),
                                     Text(
                                       "${_parceiro.estimativaEntrega}",
                                       style: TextStyle(fontSize: 12.0),
                                       textAlign: TextAlign.center,
                                     ),
                                     Text(_valorEntrega,
                                       style: TextStyle(
                                           fontSize: 12.0,
                                           color: Configuration.colorGreen),
                                       textAlign: TextAlign.center,
                                     )
                                   ],
                                 )),
                           ],
                         ),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Container(
    //                          color: Colors.green,
                               margin: EdgeInsets.only(top: 10.0, bottom: 3.0),
                               child: Text(
                                 "${_parceiro.nome}",
                                 maxLines: 4,
                                 softWrap: true,
                                 overflow: TextOverflow.ellipsis,
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 15.0,
                                     color: Theme.of(context).accentColor),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                           ],
                         ),



                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Container(
                               width: 300.0,
                               child: Text(
                                 "${_parceiro.descricao}",
                                 maxLines: 5,
                                 softWrap: false,
                                 overflow: TextOverflow.ellipsis,
                                 style: TextStyle(fontSize: 12.0),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                           ],
                         ),

                         Padding(
                             padding: EdgeInsets.only(top: 7.0, bottom: 7.0,),
                             child: Stack(
                               alignment: Alignment.center,
                               children: <Widget>[

                                 Container(
    //                              color: Colors.green,
                                   alignment: Alignment.center,
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: <Widget>[
                                       _parceiro.isCartao == true
                                           ? Icon(Icons.credit_card,
                                         color: Configuration.colorBlack,
                                       )
                                           : Padding(
                                           padding: EdgeInsets.only(right: 70)),
                                       Text(
                                         _parceiro.isCartao == true
                                             ? 'Aceitamos Cartão' : '',
                                         style: TextStyle(fontSize: 10.0),
                                         textAlign: TextAlign.center,
                                       ),
                                     ],
                                   ),
                                 ),
                                 Session.getCliente().id == 1070 ? Container():
                                 Container(
                                   padding: EdgeInsets.only(right: 20.0),
                                   alignment: Alignment.topRight,
                                   child: IconButton(
                                     onPressed: (){
                                       setState(() {
                                         if(_favorito){
                                           _favorito = false;
                                         }else{
                                           _favorito = true;
                                         }
                                       });
                                       ParceiroDao.internal().favoritar(favorito: Favorito(_idCliente, _parceiro.id, _favorito));
                                     },
                                     icon: Icon(_favorito ?  Icons.favorite : Icons.favorite_border,
                                     color: _favorito ?  Colors.red : Theme.of(context).accentColor,
                                     ),
                                   ),




//                                   _favorito == true
//                                       ? FlatButton(
//                                     child: Icon(
//                                       Icons.favorite,
//                                       color: Colors.red,
//                                     ),
//                                     onPressed: () {
//                                       JsonUtils.Favoritar(favorito: Favorito(_idCliente, _parceiro.id, false),
//                                           context: context);
//                                       setState(() {
//                                         _favorito = false;
//                                       });
//                                     },
//                                   ) :
//                                   FlatButton(
//                                     child: Icon(
//                                       Icons.favorite_border,
//                                       color: Theme.of(context).accentColor,
//                                     ),
//                                     onPressed: () {
//                                       JsonUtils.Favoritar(favorito: Favorito(_idCliente, _parceiro.id, true),
//                                           context: context);
//                                       setState(() {
//                                         _favorito = true;
//                                       });
//                                     },
//                                   ),



                                 ),


                               ],
                             )),



    //                        Padding(
    //                            padding: EdgeInsets.all(0.0),
    //                            child: Row(
    //                              mainAxisAlignment: MainAxisAlignment.center,
    //                              children: <Widget>[
    //                                Column(
    //                                  crossAxisAlignment: CrossAxisAlignment.center,
    //                                  children: <Widget>[
    ////                                    Text(
    ////                                      "${_parceiro.descricao}",
    ////                                      style: TextStyle(fontSize: 12.0),
    ////                                      textAlign: TextAlign.center,
    ////                                      maxLines: 3,
    ////                                    ),
    //
    //
    //
    //                                    Padding(
    //                                        padding: EdgeInsets.only(
    //                                            top: 7.0, bottom: 7.0, left: 100),
    //                                        child: Row(
    //                                          //crossAxisAlignment: CrossAxisAlignment.end,
    //                                          children: <Widget>[
    //                                            Column(
    //                                              crossAxisAlignment:
    //                                              CrossAxisAlignment.center,
    //                                              children: <Widget>[
    //                                                _verificarIconeCartao(),
    //                                                Text(
    //                                                  "${_aceitaCartao}",
    //                                                  style: TextStyle(fontSize: 10.0),
    //                                                  textAlign: TextAlign.center,
    //                                                ),
    //                                              ],
    //                                            ),
    //                                            SizedBox(height: 10.0,),
    ////                                            Padding(padding: EdgeInsets.only(right: 30),),
    //                                            _botaoFavorito(),
    //                                          ],
    //                                        )),
    //
    //                                  ],
    //                                ),
    //                              ],
    //                            )),
                       ],
                     ),
    //                  ],
    //                ),
                   )
               ),
               SliverToBoxAdapter(
                   child: Row(
                     children: <Widget>[
                       SizedBox(width: 10.0),
                       Text('CATEGORIAS',
                           style: TextStyle(
                             fontSize: 15.0,
                             fontWeight: FontWeight.bold,
                             color: Configuration.colorDefault2,
                           )
                       ),
                     ],
                   )
               ),
               FutureBuilder(
                   future: _futureCategoria,
                   builder: (BuildContext context, AsyncSnapshot snapshot) {
                     switch (snapshot.connectionState) {
                       case ConnectionState.waiting:
                       case ConnectionState.none:
                         return  SliverToBoxAdapter(
                           child:  Center(
                             child: Container(
                               width: 200.0,
                               height: 200.0,
                               alignment: Alignment.center,
                               child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                                 strokeWidth: 5.0,
                               ),
                             ),
                           ),
                         );

                       default:
                         if (snapshot.hasError) {
                           return SliverToBoxAdapter(
                             child:  Container(
                               child: Center(
                                 child: Text("A Conexão Falhou!"),
                               ),
                             ),
                           );

                         } else {
                           return _gridCategorias(context, snapshot);
                         }
                     }
                   }
               )
             ],
           ),
           onRefresh: () async {
              _futureCategoria = initFutureCategoria();
              setState(() {});
           },
       ),
      ),


      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CarrinhoPage(Session.getListaItens());
              }));
            },
            child: Icon(Icons.shopping_cart),

          ),


          _atualizarCarrinho(),
        ],
      )
    );
  }


  Widget _atualizarCarrinho(){
    return FutureBuilder(
        future: Session.getCarrinho(Session.getIdParceiro()),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            print('com dados');
            return snapshot.data.length > 0
                ?
            Container(
              width: 20.0,
              height: 20.0,

              alignment: Alignment.center,
              child: Text('${ snapshot.data.length}',
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .backgroundColor
                ),
              ),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),

            )
                :

            Container();

          }else{
            print('sem dados');
            return Container();
          }
        }
    );
  }




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



  Widget _gridCategorias(BuildContext context, AsyncSnapshot snapshot) {
//      _lengthList = Session.getListaItens().length;
    return SliverToBoxAdapter(
      child: GridView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (snapshot.data[index].hasSubCategoria) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SubCategoriaPage(snapshot.data[index]);
                  }));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProdutoPage.categoria(snapshot.data[index]);
//                  return null;
                  }));
                }
              },
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          image: DecorationImage(
                              image: ImageUtil.loadWithRetry(snapshot.data[index].image),
                          ),
                          border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 2.0,
                              style: BorderStyle.solid)),
                    ),
                    SizedBox(height: 7.0),
//                  Padding(
//                    padding: EdgeInsets.only(top: 10.0),
//                    child:
                    Expanded(
                        child: Text(
                          '${snapshot.data[index].descricao}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),
                        )
                    )
                  ],
                ),
              ),
            );
          }),
    );

  }

  List<Widget> _screenContentAvaliacoes(double value){
      double valorAtual = value;
      double restante;
      double decimal = double.parse((value - value.toInt()).toStringAsFixed(1));
      List<Widget> lista = [];
//      for(int i = 0; i < value.toInt(); i++){
//        lista.add(
//          Icon(Icons.star_border,
//            color: Colors.yellow[900],
//            size: 15.0,
//          ),
//        );
//      }
//      for(int i = 0; i < (value.toInt() == 5 ? 5 : (5 - value.toInt())); i++){
//        lista.add(
//          Icon(Icons.favorite_border,
//            color: Colors.yellow[900],
//            size: 15.0,
//          ),
//        );
//      }
    for(int i = 1; i < 6; i++){
      if(i <= value.toInt()){
        lista.add(
          Icon(Icons.star,
            color: Colors.yellow[900],
            size: 15.0,
          ),
        );
      }else{
        restante = (5 - i) + 0.0;
        if(restante + decimal > restante){
          lista.add(
            Icon(Icons.star_half,
              color: Colors.yellow[900],
              size: 15.0,
            ),
          );
          decimal = 0.0;
        }else{
          lista.add(
            Icon(Icons.star_border,
              color: Colors.yellow[900],
              size: 15.0,
            ),
          );
        }
      }


      }


      return lista;
  }
}
