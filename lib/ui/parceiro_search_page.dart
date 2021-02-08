import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/ui/parceiro_page.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/session.dart';


class ParceiroSearchPage extends StatefulWidget {

  List<Parceiro> _parceiros;

  ParceiroSearchPage(List<Parceiro> listaParceiros) {
    _parceiros = listaParceiros;
  }

  @override
  _ParceiroSearchPageState createState() => _ParceiroSearchPageState();
}

class _ParceiroSearchPageState extends State<ParceiroSearchPage> {
  final _BuscaController = TextEditingController();
  List<Parceiro> _todosparceiros;
  List<Parceiro> _parceirosbuscados = List();

  @override
  void initState() {
    super.initState();
    _todosparceiros = widget._parceiros;
    //_parceirosbuscados = _todosparceiros;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Busca Parceiros",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .backgroundColor,
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child:
              Container(
                child: TextField(
                  controller: _BuscaController,
                  autofocus: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey,),
                    hintText: "Buscar Estabelecimentos",
                    hintStyle: TextStyle(fontSize: 13.0),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffix: FlatButton(

                      color: Theme
                          .of(context)
                          .backgroundColor,
                      child: Text("Voltar", style: TextStyle(color: Colors
                          .red)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
//                  onTap: (){
//                    print("Apareceu teclado");
//                  },
                  onChanged: (value) {
                    _buscaParceiros(value);
                  },
                ),
              )


          ),
          Expanded(
            child: _listScreen(context),
          ),
        ],
      )),
    );
  }

  void _buscaParceiros(String value) {
    if (value.length >= 3) {
      List<Parceiro> _busca = List();
      for (Parceiro p in _todosparceiros) {
        if (FormatUtil.removeAcentos(p.nome).toUpperCase().contains(
            FormatUtil.removeAcentos(value).toUpperCase())) {
          _busca.add(p);
        }
      }
      setState(() {
        _parceirosbuscados = _busca;
      });
    } else {
      //Caso exista parceiros na busca remove, caso contrario nao faz nada
      if (_parceirosbuscados.length > 0) {
        setState(() {
          _parceirosbuscados.clear();
        });
      }
    }
  }

  Widget _listScreen(BuildContext context) {
    if (_parceirosbuscados.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.store, size: 80, color: Theme
              .of(context)
              .accentColor,),
          Padding(padding: EdgeInsets.all(10),
            child: Text("Digite o nome do estabelecimento",
                style: TextStyle(color: Theme
                    .of(context)
                    .accentColor, fontSize: 16)),
          ),
        ],
      );
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: ListView.builder(
            itemCount: _parceirosbuscados.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();

//                  Session.getCarrinho(Session.getIdParceiro()).then((itens){
//                    Navigator.push(context, MaterialPageRoute(builder: (context) {
//                      Session.setIdParceiro(_parceirosbuscados[index].id);
//                      return ParceiroPage(_parceirosbuscados[index], length: itens.length);
//                    }));
//                  });
//                  Session.setIdParceiro(_parceirosbuscados[index].id);
//                  Session.setParceiro(_parceirosbuscados[index]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ParceiroPage(_parceirosbuscados[index]);
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
                                                  Colors.black.withOpacity(0.7),
                                                  BlendMode.darken),
                                              fit: BoxFit.cover,
                                              image: ImageUtil.loadWithRetry(
                                                  _parceirosbuscados[index]
                                                      .imagemBackground))),
//
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            120.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
//
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 15.0),
                                              child: Text(
                                                _parceirosbuscados[index].nome,
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
                                                  mainAxisSize: MainAxisSize
                                                      .max,
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
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  left: 3.0),
                                                              child: Text(
                                                                _parceirosbuscados[index]
                                                                    .valoresEntrega
                                                                    .toString()
                                                                    .replaceAll(
                                                                    '.', ','),
                                                                style: TextStyle(
                                                                    fontSize: 13.0,
                                                                    color: Colors
                                                                        .white
                                                                ),
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      _parceirosbuscados[index]
                                                          .estimativaEntrega,
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.white),
                                                      textAlign: TextAlign
                                                          .center,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          right: 5.0),
                                                      child: _verificarIconeCartao(
                                                          _parceirosbuscados[index]),
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
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 10.0, left: 120.0),
                                          child: Text(
                                            _parceirosbuscados[index]
                                                .situacao == true
                                                ? 'ABERTO'
                                                : 'FECHADO',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: _parceirosbuscados[index]
                                                    .situacao == true
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
                                      Radius.circular(10.0))
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
                                        image: ImageUtil.loadWithRetry(
                                            _parceirosbuscados[index]
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
          )
      );
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


}
