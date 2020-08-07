import 'package:appfastdelivery/helper/favoritos_model.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/ui/parceiro_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();

  FavoritosPage({PageStorageKey<String> key}) : super(key: key);

  FavoritosPage.key(key) : super(key: key);
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    buscarParceirosFavoritos();
  }

  buscarParceirosFavoritos() async {
    await Provider.of<FavoritosModel>(context, listen: false).getParceirosFavoritos();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('Favoritos Page');
    List<Parceiro> parceirosFavoritos =
        Provider.of<FavoritosModel>(context).parceirosFavoritos;
    return RefreshIndicator(
      onRefresh: () => buscarParceirosFavoritos(),
      child: Center(
          child: Column(
        children: <Widget>[
          Expanded(
            child: _listScreen(context, parceirosFavoritos),
          ),
        ],
      )),
    );
  }

  Widget _listScreen(context, parceirosFavoritos) {
    if (parceirosFavoritos.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.favorite,
            size: 80,
            color: Theme.of(context).accentColor,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Seus favoritos aparecerão aqui",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 16)),
          ),
          Text("Na tela do estabelecimento, aperte no coração para ",
              style: TextStyle(color: Colors.black, fontSize: 14)),
          Text("favoritar", style: TextStyle(color: Colors.black, fontSize: 14))
        ],
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        itemCount: parceirosFavoritos.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ParceiroPage(parceirosFavoritos[index]);
              }));
            },
            child: Card(
                elevation: 5.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment(-0.95, 1.0),
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
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
                                          image: ImageUtil.loadWithRetry(
                                              parceirosFavoritos[index]
                                                  .imagemBackground))),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        120.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            parceirosFavoritos[index].nome,
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
                                                      child: Text(
                                                        parceirosFavoritos[
                                                                index]
                                                            .valoresEntrega
                                                            .toString()
                                                            .replaceAll(
                                                                '.', ','),
                                                        style: TextStyle(
                                                            fontSize: 13.0,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Text(
                                              parceirosFavoritos[index]
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
                                                  parceirosFavoritos[index]),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 10.0, left: 120.0),
                                      child: Text(
                                        parceirosFavoritos[index].situacao ==
                                                true
                                            ? 'ABERTO'
                                            : 'FECHADO',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: parceirosFavoritos[index]
                                                        .situacao ==
                                                    true
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Container(
                            width: 100.0,
                            height: 90.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: ImageUtil.loadWithRetry(
                                        parceirosFavoritos[index].imagemLogo),
                                    fit: BoxFit.cover)),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          );
        },
      );
    }
  }

  Widget _verificarIconeCartao(Parceiro _parceiro) {
    if (_parceiro.isCartao) {
      return Icon(Icons.credit_card, color: Colors.white, size: 20.0);
    }
  }
}
