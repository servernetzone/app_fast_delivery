import 'dart:convert';

import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/ui/parceiro_search_page2.dart';
import 'package:appfastdelivery/ui/update_version_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/parceiro_dao.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/ui/parceiro_page.dart';
import 'package:appfastdelivery/ui/pedidos_page.dart';
import 'package:appfastdelivery/ui/seguimento_page.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:get_version/get_version.dart';
import 'parceiro_search_page.dart';
import 'cliente_page.dart';
import 'endereco_login_page.dart';
import 'favoritos_page.dart';

class HomePage extends StatefulWidget {
  static final String routeName = '/Home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ParceiroDao parceiroDao = ParceiroDao();
  ClienteDao clienteDao = ClienteDao();
  List<Parceiro> _todosParceiros;




  List<String> _listaNomes = [
    'Promoções',
    'Lanches',
    'Restaurantes',
    'Conveniências',
    'Bebidas',
    'Cosméticos',
    'Água e Gás',
    'Farmácias',
    'Informática',
    'Pizzarias',
    'Horti-fruti',
    'Oriental',
    'Sobremesas',
    'Mercadinhos',
    'Naturais',
    'Sorveterias',
    'Variedades',
    'Serviços',
    'Vestuário'
  ];
  List<String> _listaImagens = [
    'images/promocoes.gif',
    'images/lanches.png',
    'images/restaurante.png',
    'images/conveniencia.png',
    'images/bebidas.png',
    'images/cosmeticos.png',
    'images/agua_e_gas.png',
    'images/farmacia.png',
    'images/informatica.png',
    'images/pizzaria.png',
    'images/horti_fruti.png',
    'images/oriental.png',
    'images/sobremesas.png',
    'images/mercadinho.png',
    'images/naturais.png',
    'images/sorvetes.png',
    'images/variedades.png',
    'images/servicos.png',
    'images/vestuario.png'
  ];
  List<String> _listaTipos = [
    'PROMOCOES',
    'LANCHES',
    'RESTAURANTE',
    'CONVENIENCIAS',
    'BEBIDAS',
    'COSMETICOS',
    'AGUA E GAS',
    'FARMACIAS',
    'INFORMATICA',
    'PIZZARIA',
    'HORTI_FRUTI',
    'ORIENTAL',
    'SOBREMESAS',
    'MERCADINHOS',
    'NATURAIS',
    'SORVETERIAS',
    'VARIEDADES',
    'SERVICOS',
    'VESTUARIO'
  ];


  Future<List<Parceiro>> _futureParceiros;

  @override
  void initState() {
    super.initState();
    print("initState()");
    _futureParceiros = _initFutureParceiros();
//    parceiroDao.list(Session.getEnderecoCiente().idCidade).then((retorno) {
//      _todosParceiros = retorno;
//    });
    verificarVersao();



  }

  Future<List<Parceiro>> _initFutureParceiros() async{
    return await parceiroDao.list(Session.getEnderecoCiente().idCidade);
  }

  verificarVersao() {
    print('**************** iniciou controle de versão ***********************');
    clienteDao.getVersion().then((response)async{
//      String pf = await GetVersion.platformVersion;
//      print('platformVersion: *$pf*');
      String projectCode = await GetVersion.projectCode;
//      print('projectCode: *$projectCode*');
      int code = int.parse(projectCode);
//      print('projectCode: *$code*');
      if(code < response['cod32']){
        print('versões diferentes! atualizar');
        print('code < response[cod32] = $code < ${response['cod32']}');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
          return UpdateVesionPage();
        }));
      }else{
        print('versões iguais ou maior. code >= response[cod32] = $code >= ${response['cod32']}');
      }

//      GetVersion.projectVersion.then((version){
////        print('version: *$version*');
////        print('response: *${response['versaoAndroid']}*');
//
//
//
//      });
    });
    print('*****************************************************************');
  }

  @override
  Widget build(BuildContext context) {
//    _listaParceiros = parceiroDao.list(Session.getEnderecoCiente().idCidade);
    return
      WillPopScope(
          onWillPop: ()async{
            print('onWillPop!');
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "FastDelivery",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: Container(),
            ),
            body: Container(
                margin: EdgeInsets.all(5.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    print('onRefresh!');
                    setState(() {
                      _futureParceiros = _initFutureParceiros();
                    });
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                          child:
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return EnderecoLoginPage(select: true);
                              }));
                            },
                            child: SizedBox(
                              height: 30.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  AspectRatio(
                                    aspectRatio: 0.15/0.2,
                                    child: Icon(Icons.location_on,
                                      size: 20.0,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        Session.getCliente().id == 1070 ? 'Enviar para ${Session.getEnderecoCiente().bairro} - ${Session.getEnderecoCiente().cidade}':
                                        'Enviar para ${Session.getEnderecoCiente().rua}, ${Session.getEnderecoCiente().numero} - '
                                            ' ${Session.getEnderecoCiente().bairro} - ${Session.getEnderecoCiente().cidade}',
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),

                                  AspectRatio(
                                    aspectRatio: 0.15/0.2,
                                    child:
                                    Icon(Icons.keyboard_arrow_down,
                                      size: 20.0,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),


                                  //                           Container(
                                  //                             color: Colors.purple,
                                  //                             width: 280.0,
                                  //                             padding: EdgeInsets.all(0.0),
                                  //                             margin: EdgeInsets.all(0.0),
                                  //                             child: Text('Enviar para ${Session.getEnderecoCiente().rua}, ${Session.getEnderecoCiente().numero} - '
                                  //                                 ' ${Session.getEnderecoCiente().bairro} - ${Session.getEnderecoCiente().cidade}',
                                  //                               maxLines: 1,
                                  //                               softWrap: false,
                                  //                               overflow: TextOverflow.ellipsis,
                                  //                               style: TextStyle(
                                  //                                   color: Theme.of(context).accentColor,
                                  //                                   fontWeight: FontWeight.bold,
                                  //                                   fontSize: 13.0),
                                  //                               textAlign: TextAlign.start,
                                  //                             ),
                                  //                           ),

                                  //                           Icon(Icons.keyboard_arrow_down,
                                  //                             size: 20.0,
                                  //                             color: Theme.of(context).accentColor,
                                  //                           ),
                                ],
                              ),
                            ),
                          )
                      ),

                      SliverToBoxAdapter(
                        child:  Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Container(
                              child: TextField(
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Buscar Estabelecimentos",
                                  hintStyle: TextStyle(fontSize: 13.0),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                                   return ParceiroSearchPage(_todosParceiros);
//                                 }));

                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                                   return ParceiroSearchPage(_todosParceiros);
                                    return ParceiroSearchPage2(_futureParceiros);
                                  }));
                                },
                              ),
                            )),
                      ),

                      SliverToBoxAdapter(
                        child: Container(
                          height: 90.0,
                          margin: EdgeInsets.only(left: 0.0, right: 0.0),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _screenCarregarCategorias(),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: FutureBuilder(
                          future: _futureParceiros,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return
                                  Center(
                                    child: Container(
                                      width: 200.0,
                                      height: 200.0,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                                        strokeWidth: 5.0,
                                      ),
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
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                                    child: _screenListMain(context, snapshot),
                                  );
                                  //                           _listScreen(context, snapshot);
                                }
                            }
                          },
                        ),
                      ),


                    ],
                  ),
                )
            ),

            bottomNavigationBar: BottomAppBar(
                elevation: 5.0,
                color: Colors.white,
                child: Container(
                    height: 45.0,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.home, color: Theme.of(context).accentColor),
                            onPressed: () {
                              print("Ja esta nessa tela");
                            }),
                        IconButton(
                            icon: Icon(Icons.favorite, color: Configuration.colorDefault2),
                            onPressed: () {
                              //Navigator.of(context).pop();
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return FavoritosPage();
                              }));
                            }),
                        IconButton(
                            icon: Icon(Icons.list, color: Configuration.colorDefault2),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return PedidosPage();
                              }));
                            }),
                        IconButton(
                            icon: Icon(Icons.account_circle, color: Configuration.colorDefault2),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ClientePage();
                              }));
                            }),
                      ],
                    )
                  //                 Padding(
                  //                     padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  //                     child:
                  //
                  //                 )
                )
            ),
          )

      );
  }

  Widget _screenListMain(BuildContext context, AsyncSnapshot<List<Parceiro>> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
//                    print('snapshot.data[index].id: ${snapshot.data[index].id}');
//                    print('snapshot.data[index].nome: ${snapshot.data[index].nome}');
//            print('Parceiro.porcentagemCartao: ${snapshot.data[index].porcentagemCartao}');

            Session.setListaItens(List());
//                    Session.setIdParceiro(snapshot.data[index].id);
//                    Session.setNomeParceiro(snapshot.data[index].nome);
//                    Session.setImageParceiro(snapshot.data[index].imagemLogo);
//                    Session.setParceiro(snapshot.data[index]);
//                    print('Session.getParceiro.nome: ${Session.getIdParceiro()} - ${Session.getParceiro().nome}');
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
    );
  }

  Widget _verificarIconeCartao(Parceiro _parceiro) {
    if (_parceiro.isCartao) {
      return Icon(Icons.credit_card,
//          color: Colors.white,
          size: 20.0);
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
                  color: Configuration.colorGreen,
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
                  color: Configuration.colorRed,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          )
        ],
      );
    }
  }

  List<Widget> _screenCarregarCategorias(){
    List<Widget> lista = List<Widget>();

    for(int i = 0; i < _listaNomes.length; i++){
      lista.add(
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(left: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5.0),
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(_listaImagens[i])),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        color: Theme.of(context).accentColor,
                        width: 1.5,
                      )),
                ),
                Text(_listaNomes[i],
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).accentColor,
                    ))
              ],
            ),
          ),
          onTap: () {
            print(_listaTipos[i]);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return SeguimentoPage(_listaTipos[i], _listaNomes[i], Session.getEnderecoCiente().idCidade);
            }));
          },
        ),
      );
    }



    return lista;
  }
}
