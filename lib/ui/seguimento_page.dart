import 'package:appfastdelivery/dao/parceiro_dao.dart';
import 'package:appfastdelivery/ui/promocoes_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/ui/parceiro_page.dart';
import 'package:appfastdelivery/util/json_utils.dart';
import 'package:appfastdelivery/util/session.dart';


class SeguimentoPage extends StatefulWidget {

  String seguimento;
  String title;
  int idCidade;
  SeguimentoPage(this.seguimento, this.title, this.idCidade);

  @override
  _SeguimentoPageState createState() => _SeguimentoPageState();
}

class _SeguimentoPageState extends State<SeguimentoPage> {
  ParceiroDao parceiroDao = ParceiroDao();
  Future<List<Parceiro>> _todosparceiros;
  String _seguimento;
  String _title;


  @override
  void initState() {
    super.initState();
    _seguimento = widget.seguimento;
    _title = widget.title;
    _todosparceiros = parceiroDao.listSeguimentos(widget.idCidade, _seguimento);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${_title}",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:  Center(
          child:
          Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: _todosparceiros,
              builder: (BuildContext context, AsyncSnapshot<List<Parceiro>> snapshot) {
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
    );
  }


  Widget _listScreen(BuildContext context, AsyncSnapshot<List<Parceiro>> snapshot ){

    if (snapshot.data.length == 0){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.store,size: 80, color: Theme.of(context).accentColor,),
          Padding(padding: EdgeInsets.all(10),
            child: Text("Nenhum parceiro encontrado!",style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16)),
          ),
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

                  Navigator.of(context).pop();

//                  Session.getCarrinho(Session.getIdParceiro()).then((itens){
//                    Navigator.push(context, MaterialPageRoute(builder: (context) {
//                      Session.setIdParceiro(snapshot.data[index].id);
//                      return ParceiroPage(snapshot.data[index], length: itens.length);
//                    }));
//                  });

                  if(_seguimento == 'PROMOCOES'){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      Session.setListaItens(List());
//                      Session.setIdParceiro(snapshot.data[index].id);
//                      Session.setNomeParceiro(snapshot.data[index].nome);
//                      Session.setImageParceiro(snapshot.data[index].imagemLogo);
//                      Session.setParceiro(snapshot.data[index]);
                      return PromocoesPage(snapshot.data[index]);
                    }));
                  }else{
//                    Session.setIdParceiro(snapshot.data[index].id);
//                    Session.setParceiro(snapshot.data[index]);
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ParceiroPage(snapshot.data[index]);
                    }));
                  }
                },
                child: Card(
                    elevation: 4.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    child:
                    Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment(-0.95, 1.0),
                          children: <Widget>[
                            Column(
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
                                            image: ImageUtil.loadWithRetry(snapshot.data[index].imagemBackground)
                                        )
                                    ),
                                    child:
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(120.0, 0.0, 0.0, 0.0),


                                      child:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: <Widget>[
//
                                          Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Text(snapshot.data[index].nome,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white,),
                                              textAlign:
                                              TextAlign.center,
                                            ),
                                          ),
//
                                          Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[Icon(
                                                          Icons.motorcycle,
                                                          color: Colors.white,
                                                          size: 20.0),
                                                        Padding(padding: EdgeInsets.only(left: 3.0),
                                                            child: Text(snapshot.data[index].valoresEntrega.toString().replaceAll('.', ','),
                                                              style: TextStyle(
                                                                  fontSize: 13.0,
                                                                  color: Colors.white
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            )
                                                        )

                                                      ],
                                                    ),
                                                  ),


                                                  Text(
                                                    snapshot.data[index]
                                                        .estimativaEntrega,
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        color:
                                                        Colors.white),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: 5.0),
                                                    child: _verificarIconeCartao(snapshot.data[index]),
                                                  ),
                                                ],
                                              )
                                          ),
//
                                        ],
                                      ),
                                    )
                                ),
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
//                                        NetworkImage(snapshot.data[index].imagemLogo),
                                        fit: BoxFit.cover)),
                              ),
                            )


                          ],
                        ),
                      ],
                    )
                ),
              );
            },
          )
      );
    }




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
