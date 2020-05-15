import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/parceiro_dao.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/ui/home_page.dart';
import 'package:appfastdelivery/ui/parceiro_page.dart';
import 'package:appfastdelivery/ui/pedidos_page.dart';
import 'package:appfastdelivery/util/json_utils.dart';
import 'package:appfastdelivery/util/session.dart';

import 'cliente_page.dart';



class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  Future<List> _favoritos;
  int _idCliente;
  Future<List<Parceiro>> _futureParceirosFavoritos;

  @override
  void initState() {
    super.initState();
    _idCliente = Session.getCliente().id;
    _futureParceirosFavoritos = _initFutureParceirosFavoritos();
  }

  Future<List<Parceiro>> _initFutureParceirosFavoritos() async{
    return await ParceiroDao.internal().listFavoritos(_idCliente);
  }


  @override
  Widget build(BuildContext context) {
//    _favoritos = JsonUtils.getFavoritos(_idCliente);
//    _favoritos = ParceiroDao.internal().listFavoritos(_idCliente);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favoritos",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
//        backgroundColor: Color(0xff6200ee),
        centerTitle: true,
      ),
      body:  Center(child:Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: _futureParceirosFavoritos,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container(
                        child: Center(
                          child: Text("A Conexão Falhou!"),
                        ),
                      );
                    } else {
                      return _listScreen(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
            height: 45.0,
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.home, color: Configuration.colorDefault2),
                        onPressed: () {
//                          Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return HomePage();
                          }));
                        }),
                    IconButton(
                        icon: Icon(Icons.favorite, color: Theme.of(context).accentColor),
                        onPressed: () {
                          //Navigator.of(context).pop();
                          print("Ja esta nessa tela");

                        }),
                    IconButton(
                        icon: Icon(Icons.list, color: Configuration.colorDefault2),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return PedidosPage();
                          }));
                        }),
                    IconButton(
                        icon: Icon(Icons.account_circle, color: Configuration.colorDefault2),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return ClientePage();
                          }));
                        }),
                  ],
                )
            )),
      ),
    );
  }

  Widget _listScreen(BuildContext context, AsyncSnapshot snapshot){
    if (snapshot.data.length == 0){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.favorite,size: 80, color: Theme.of(context).accentColor,),
          Padding(padding: EdgeInsets.all(10),
            child: Text("Seus favoritos aparecerão aqui",style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16)),
          ),
          Text("Na tela do estabelecimento, aperte no coração para ",style: TextStyle(color: Colors.black,fontSize: 14)),
          Text("favoritar",style: TextStyle(color: Colors.black,fontSize: 14))
        ],
      );
    }else{
      return Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
//                  Session.setIdParceiro(snapshot.data[index].id);
//                  Session.setParceiro(snapshot.data[index]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ParceiroPage(snapshot.data[index]);
                  }));
                },
                child: Card(
                    elevation: 5.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment(-0.95, 1.0),
                          children: <Widget>[
                            Container(
                              child:  Column(
                                children: <Widget>[
//                                  SizedBox(height: 20.0,),
                                  Container (
                                      height: 75.0,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5.0),
                                              topRight: Radius.circular(5.0)),
                                          image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.7),
                                                  BlendMode.darken),
                                              fit: BoxFit.cover,
                                              image: ImageUtil.loadWithRetry(snapshot.data[index].imagemBackground))),
//
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            120.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
//
                                            Padding(
                                              padding: EdgeInsets.only(top: 15.0),
                                              child: Text(
                                                snapshot.data[index].nome,
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.fade,

                                              ),
                                            ),
//
                                            Container(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.motorcycle,
//                                                              color: Colors.white,
                                                              size: 20.0),
                                                          Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: 3.0),
                                                              child: Text(snapshot.data[index].valoresEntrega.toString().replaceAll('.', ','),
                                                                style: TextStyle(
                                                                    fontSize: 13.0,
                                                                    color: Colors.white
                                                                ),
                                                                textAlign:
                                                                TextAlign.center,
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data[index]
                                                          .estimativaEntrega,
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.white),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(right: 5.0),
                                                      child: _verificarIconeCartao(
                                                          snapshot.data[index]),
                                                    ),
                                                  ],
                                                )),
//
                                          ],
                                        ),
                                      )),
                                  Container(
                                    height: 25.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start ,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.0, left: 120.0),
                                          child: Text(
                                            snapshot.data[index].situacao == true
                                                ? 'ABERTO'
                                                : 'FECHADO',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: snapshot.data[index].situacao == true
                                                    ? Configuration.colorGreen
                                                    : Configuration.colorRed,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Container(
                                width: 100.0,
                                height: 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)
                                    ),
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        image: ImageUtil.loadWithRetry(snapshot.data[index].imagemLogo),
                                        fit: BoxFit.cover)),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              );
            },
          )
      );}
  }

  Widget _verificarIconeCartao(Parceiro _parceiro){

    if(_parceiro.isCartao){
      return Icon(Icons.credit_card, color: Colors.white, size: 20.0);
    }
  }

  Widget _verificarSituacaoWidget(Parceiro _parceiro) {
    if (_parceiro.situacao) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(
              "ABERTO",
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(
              "FECHADO",
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          )
        ],
      );
    }
  }



}
