import 'package:appfastdelivery/helper/parceiros_model.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:appfastdelivery/widgets/no_internet_message.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/ui/parceiro_page.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:provider/provider.dart';

class BuscarParceiroPage extends StatefulWidget {
  BuscarParceiroPage({PageStorageKey<String> key}) : super(key: key);

  @override
  _BuscarParceiroPageState createState() => _BuscarParceiroPageState();
}

class _BuscarParceiroPageState extends State<BuscarParceiroPage> {
  final _buscaController = TextEditingController();
  var _parceirosBuscados = List<Parceiro>();
  bool nadaEncontrado = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Parceiro> parceiros = Provider.of<ParceirosModel>(context).parceiros;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.grey[100]),
          child: TextField(
            style: TextStyle(fontSize: 16, color: Colors.black),
            controller: _buscaController,
            autofocus: true,
            decoration: InputDecoration(
                icon: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                border: InputBorder.none,
                hintText: "Buscar estabelecimento",
                hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon: IconButton(
                    onPressed: () => setState(() {
                          _buscaController.clear();
                          _buscaParceiros(_buscaController.text, parceiros);
                        }),
                    icon: Icon(
                      _buscaController.text.isNotEmpty
                          ? Icons.clear
                          : Icons.search,
                      color: Colors.grey,
                    ))),
            onChanged: (value) => _buscaParceiros(value, parceiros),
          ),
        ),
        centerTitle: true,
      ),
      body: ConnectivityWidget(
          builder: (context, isOnline) {
            return isOnline
                ? Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        Expanded(
                          child: _listScreen(context),
                        ),
                      ],
                    ),
                  )
                : NoInternetMessage();
          },
          offlineBanner: NoInternetMessageBanner()),
    );
  }

  void _buscaParceiros(String value, parceiros) {
    nadaEncontrado = false;
    List<Parceiro> _busca = List();
    if (value.isEmpty) {
      _busca.clear();
    } else {
      for (Parceiro p in parceiros) {
        if (FormatUtil.removeAcentos(p.nome)
            .toUpperCase()
            .contains(FormatUtil.removeAcentos(value).toUpperCase())) {
          _busca.add(p);
        }
      }
    }

    setState(() {
      if (_busca.isEmpty && value.isNotEmpty) {
        nadaEncontrado = true;
      }
      _parceirosBuscados = _busca;
    });
  }

  Widget _listScreen(BuildContext context) {
    if (nadaEncontrado) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.store,
            size: 80,
            color: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Nenhum estabelecimento encotrado",
                style: TextStyle(color: Colors.red, fontSize: 16)),
          ),
        ],
      );
    } else {
      if (_parceirosBuscados.length == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.store,
              size: 80,
              color: Theme.of(context).accentColor,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Digite o nome do estabelecimento",
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 16)),
            ),
          ],
        );
      } else {
        return Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: ListView.builder(
              itemCount: _parceirosBuscados.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ParceiroPage(_parceirosBuscados[index]);
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
//                                  SizedBox(height: 20.0,),
                                    Container(
                                        height: 75.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5.0),
                                                topRight: Radius.circular(5.0)),
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.black
                                                        .withOpacity(0.7),
                                                    BlendMode.darken),
                                                fit: BoxFit.cover,
                                                image: ImageUtil.loadWithRetry(
                                                    _parceirosBuscados[index]
                                                        .imagemBackground))),
//
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              120.0, 0.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
//
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 15.0),
                                                child: Text(
                                                  _parceirosBuscados[index]
                                                      .nome,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(Icons.motorcycle,
//                                                              color: Colors.white,
                                                            size: 20.0),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3.0),
                                                            child: Text(
                                                              _parceirosBuscados[
                                                                      index]
                                                                  .valoresEntrega
                                                                  .toString()
                                                                  .replaceAll(
                                                                      '.', ','),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.0,
                                                                  color: Colors
                                                                      .white),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    _parceirosBuscados[index]
                                                        .estimativaEntrega,
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        color: Colors.white),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.0),
                                                    child:
                                                        _verificarIconeCartao(
                                                            _parceirosBuscados[
                                                                index]),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 10.0, left: 120.0),
                                            child: Text(
                                              _parceirosBuscados[index]
                                                          .situacao ==
                                                      true
                                                  ? 'ABERTO'
                                                  : 'FECHADO',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: _parceirosBuscados[
                                                                  index]
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
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
                                              _parceirosBuscados[index]
                                                  .imagemLogo),
                                          fit: BoxFit.cover)),
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                );
              },
            ));
      }
    }
  }

  Widget _verificarIconeCartao(Parceiro _parceiro) {
    if (_parceiro.isCartao) {
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

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }
}
