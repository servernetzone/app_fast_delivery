import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/dao/parceiro_dao.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/helper/parceiros_model.dart';
import 'package:appfastdelivery/ui/endereco_login_page.dart';
import 'package:appfastdelivery/ui/parceiro_page.dart';
import 'package:appfastdelivery/ui/seguimento_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParceirosPage extends StatefulWidget {
  String path;

  ParceirosPage(this.path, {PageStorageKey<String> key}) : super(key: key);

  @override
  _ParceirosPageState createState() => _ParceirosPageState();
}

class _ParceirosPageState extends State<ParceirosPage> {
  ParceiroDao parceiroDao = ParceiroDao();

  String get path => widget.path;

  ClienteDao clienteDao = ClienteDao();

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Parceiros Page');
    List<Parceiro> parceiros = Provider.of<ParceirosModel>(context).parceiros;

    return Container(
      child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<ParceirosModel>(context, listen: false).getParceiros();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return EnderecoLoginPage(
                              modal: true,
                            );
                          });
                    },
                    child: SizedBox(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 0.15 / 0.2,
                            child: Icon(
                              Icons.location_on,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                Session.getCliente().id == 1070
                                    ? 'Entrega: ${Session.getEnderecoCiente().bairro} - ${Session.getEnderecoCiente().cidade}'
                                    : 'Entrega: ${Session.getEnderecoCiente().rua}, ${Session.getEnderecoCiente().numero} - '
                                        ' ${Session.getEnderecoCiente().bairro} - ${Session.getEnderecoCiente().cidade}',
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 0.15 / 0.2,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 90.0,
                  margin: EdgeInsets.only(top: 16),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _screenCarregarCategorias(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: parceiros.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).accentColor),
                          strokeWidth: 5.0,
                        )),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: _screenListMain(context, parceiros),
                      ),
              ),
            ],
          )),
    );
  }

  Widget _screenListMain(BuildContext context, List<Parceiro> parceiros) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: parceiros.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Session.setListaItens(List());
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ParceiroPage(parceiros[index]);
            }));
          },
          child: Card(
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
                                            Colors.black.withOpacity(0.7),
                                            BlendMode.darken),
                                        fit: BoxFit.cover,
                                        image: ImageUtil.loadWithRetry(
                                            parceiros[index]
                                                .imagemBackground))),
//
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(120.0, 0.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
//
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          parceiros[index].nome,
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
                                                      parceiros[index]
                                                          .valoresEntrega
                                                          .toString()
                                                          .replaceAll('.', ','),
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          Text(
                                            parceiros[index].estimativaEntrega,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 5.0),
                                            child: _verificarIconeCartao(
                                                parceiros[index]),
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
                                      parceiros[index].situacao == true
                                          ? 'ABERTO'
                                          : 'FECHADO',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color:
                                              parceiros[index].situacao == true
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
                                      parceiros[index].imagemLogo),
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

  List<Widget> _screenCarregarCategorias() {
    List<Widget> lista = List<Widget>();

    for (int i = 0; i < _listaNomes.length; i++) {
      lista.add(
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(
                left: 5.0, right: i == _listaNomes.length - 1 ? 5.0 : 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    bottom: 5.0,
                  ),
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage(_listaImagens[i])),
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SeguimentoPage(_listaTipos[i], _listaNomes[i],
                  Session.getEnderecoCiente().idCidade);
            }));
          },
        ),
      );
    }
    return lista;
  }
}
