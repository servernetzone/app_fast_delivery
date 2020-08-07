import 'package:appfastdelivery/dao/avalicao_dao.dart';
import 'package:appfastdelivery/dao/pedido_dao.dart';
import 'package:appfastdelivery/helper/avaliacao.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/helper/detailpedido.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/json_utils.dart';
import 'package:appfastdelivery/helper/carrinho.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:appfastdelivery/ui/carrinho_page.dart';
import 'package:appfastdelivery/ui/pedidos_page.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';

import 'avaliacao_page.dart';


class PedidoShowPage extends StatefulWidget {
  int _idPedido;
  String _codigoPedido;
  PedidoShowPage(int id, String codigo) {
    _idPedido = id;
    _codigoPedido = codigo;
//    JsonUtils.getPedidoDetail(id).then((onValue){
//    setState(){
//      _Pedido = onValue;
//    }
//    });
  }

  @override
  _PedidoShowPageState createState() => _PedidoShowPageState();
}

class _PedidoShowPageState extends State<PedidoShowPage> {
  double _valorItens;
  double _valorTaxa;

  TextEditingController _messagemController = TextEditingController(text: '');
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool activeButton = true;
  bool activeField = false;
  Future<PedidoDetail> _futurePedido;

  _PedidoShowPageState();

  @override
  void initState() {
//    _valorItens = _calcularValorTotal();
    super.initState();

    _reload();
  }

  void _reload(){
    _futurePedido = _initFuturePedidos(widget._idPedido);
  }

  Future<PedidoDetail> _initFuturePedidos(int id) async{
    return await PedidoDao.internal().get(id);
  }



//  double _calcularValorTotal(List<ItemCarrinho> itens) {
//    double valorTotal = 0.0;
//    for (ItemCarrinho itemCarrinho in itens) {
//      valorTotal += (itemCarrinho.valor * itemCarrinho.quantidade);
//    }
////    print(Session.getPedido().valorEntrega);
//    return valorTotal;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._codigoPedido,
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<PedidoDetail>(
        future: _futurePedido,
        builder: (BuildContext context, AsyncSnapshot<PedidoDetail> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                      strokeWidth: 5.0,
                    ),
                  )
              );
            default:
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text("A Conexão Falhou!"),
                  ),
                );
              } else {
                return _screenPedido(context, snapshot);
              }
          }
        },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
            height: 45.0,
            child:
            Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.arrow_back,
                              color: Theme.of(context).backgroundColor,
                              size: 18.0,
                            ),
                            Text("Voltar",
                              style: TextStyle(
                                color: Theme.of(context).backgroundColor
                              ),
                            )
                          ],
                        )),
                  ],
                ))
        ),
      ),
    );
  }

  Widget _screenPedido(BuildContext context, AsyncSnapshot<PedidoDetail> snapshot) {
    print('snapshot.data.pagoComSaldo = ${snapshot.data.pagoComSaldo}');
    print('snapshot.data.pagamentosPedido = ${snapshot.data.pagamentosPedido}');
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        Center(
          child:
          Column(
            children: <Widget>[
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: ImageUtil.loadWithRetry(snapshot.data.getParceiroImagem),
                      fit: BoxFit.cover
                  ),

                ),
              ),
              SizedBox(height: 10.0,),
              Text(snapshot.data.getParceiroNome,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0
                ),
              ),
              SizedBox(height: 10.0,),
              Text(snapshot.data.andamento,
                style: TextStyle(
                    color: snapshot.data.cor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0
                ),
              ),
              Text(snapshot.data.motivoCancelamento != null
                  ? snapshot.data.motivoCancelamento
                  : "",
                style: TextStyle(
                    color: snapshot.data.cor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0
                ),
              ),
              snapshot.data.cancelamento
                  ? RaisedButton(child: Text('Cancelar'),
                  color: Configuration.colorRed2,
                  textColor: Colors.white,
                  onPressed: (){
                    PedidoDao.internal().cancelarPedido(widget._idPedido).then((response){
                      MessageUtil.alertMessageScreen(context,
                          response['resposta'],
                          '',
                          [
                            FlatButton(
                              child: Text('OK'),
                              onPressed: (){
                                Navigator.of(context).pop();
                                setState(() {});
                                print(snapshot.data.cancelamento);
                              },
                            )
                          ]
                      );
                    }).catchError((error){
                      MessageUtil.alertMessageScreen(context,
                          'Cancelamento não finalizado',
                          'Não foi possível efetuar o cancelamento do seu pedido.',
                          [
                            FlatButton(
                              child: Text('OK'),
                              onPressed: (){
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            )
                          ]
                      );
                    });

                  }
              )
                  : Container(),
            ],
          ),
        ),
        SizedBox(height: 7.0),
//                PRODUTOS
        Text('PRODUTOS',
          style: TextStyle(
              color: Configuration.colorAccent1,
              fontWeight: FontWeight.bold,
              fontSize: 13.0
          ),
        ),
        Container(
//                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Wrap(
              spacing: 5.0,
              runSpacing: 3.0,
              direction: Axis.horizontal,
              children: _screenListProdutos(context, snapshot)
          ),
        ),
        SizedBox(height: 7.0),





//                ENTREGA
        Text('ENTREGA',
          style: TextStyle(
              color: Configuration.colorAccent1,
              fontWeight: FontWeight.bold,
              fontSize: 13.0
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 7.0, bottom: 7.0),
          child:  Text(snapshot.data.entrega == false ? 'Retirada no estabelecimento': '${snapshot.data.endereco.rua}, ${snapshot.data.endereco.numero}'.toUpperCase()+
              '\n${snapshot.data.endereco.bairro}'.toUpperCase()+
              ' - ${snapshot.data.endereco.observacao}'
                  ' - ${snapshot.data.endereco.referencia}\n'
                  '${snapshot.data.endereco.cep}'
                  ' - ${snapshot.data.endereco.cidade.toUpperCase()}',
            style: TextStyle(
                fontSize: 13.0
            ),
            maxLines: 7,
          ),
        ),
        SizedBox(height: 7.0),






//              PAGAMENTO
        Text('PAGAMENTO',
          style: TextStyle(
              color: Configuration.colorAccent1,
              fontWeight: FontWeight.bold,
              fontSize: 13.0
          ),
        ),

        snapshot.data.pagoComSaldo && (snapshot.data.pagamentosPedido == null || snapshot.data.pagamentosPedido.isEmpty)
        ? Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('SALDO',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5
                  ),
                ),
                Container(
                  height: 35.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/saldo.png'))
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.0),
          ],
        )
        : Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${snapshot.data.pagamentosPedido[0].getNome}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5
                  ),
                ),
                Container(
                  height: 35.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshot.data.pagamentosPedido[0].getImagem))
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.0),


//        PORCENTAGEM CARTÃO E VALOR APLICADO
            snapshot.data.pedidoCartao == true
                ?
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Taxa aplicada',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12.5
                      ),
                    ),
                    Text(snapshot.data.porcentagemCartao,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 12.5
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Valor aplicado',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12.5
                      ),
                    ),
                    Text(snapshot.data.valorTaxaCartao,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 12.5
                      ),
                    ),
                  ],
                ),
              ],
            ): Container(),
            SizedBox(height: 7.0),

          ],
        ),














//              TOTAIS
        Text('TOTAIS',
          style: TextStyle(
              color: Configuration.colorAccent1,
              fontWeight: FontWeight.bold,
              fontSize: 13.0
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 7.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Produtos',
                    style: TextStyle(
                        fontSize: 13.0
                    ),
                  ),
                  Text(snapshot.data.valor,
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontSize: 13.0
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Entrega',
                    style: TextStyle(
                        fontSize: 13.0
                    ),
                  ),
                  Text(snapshot.data.valorEntrega,
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontSize: 13.0
                    ),
                  ),
                ],
              ),

              snapshot.data.valorTicket == 0.0 ? Container() :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Ticket',
                    style: TextStyle(
                        fontSize: 13.0
                    ),
                  ),
                  Text('- ${FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(snapshot.data.valorTicket))}',
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontSize: 13.0
                    ),
                  ),
                ],
              ),
              snapshot.data.valorTicket == 0.0 ?  SizedBox(height: 5.0) : SizedBox(height: 10.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0
                    ),
                  ),
                  Text(snapshot.data.getPreco,
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
        SizedBox(height: 12.0),

//            OBSERVAÇÕES
        Text(snapshot.data.getTroco,
          style: TextStyle(
              color: Configuration.colorAccent2,
              fontSize: 13.0
          ),
        ),
        SizedBox(height: 12.0),

//              ANOTAÇÕES
        snapshot.data.andamento == 'Aguardando Aprovação' || snapshot.data.andamento == 'Pedido Aprovado'
            ? Form(
          key: _formKey,
          child:  Column(
            children: <Widget>[
              TextField(
                controller: _messagemController,
//                maxLines: 4,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor), borderRadius: BorderRadius.circular(5.0),),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor), borderRadius: BorderRadius.circular(5.0),),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
                  focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
                  labelText: 'Mensagem',
                  labelStyle: TextStyle(
                      color: Configuration.colorDefault4,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                  alignLabelWithHint: true,
                  hintText: 'Enviar mensagem para o parceiro...',
                  hintStyle: TextStyle(
                      fontSize: 13.0
                  ),
                ),
                onSubmitted: (text){
                  print('onFieldSubmitted');
                  _enviarMensagem();
                },
                onChanged: (text){
                  print('onChanged');
                  setState(() {
                    activeField = text.length > 0;
                  });
                },
              ),
              SizedBox(height: 10.0,),
              SizedBox(
                width: 120.0,
                height: 42.0,
                child:  RaisedButton(
                    child: Text("Enviar",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0)),
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    onPressed: activeField == false ? null : _enviarMensagem
                ),
              )
            ],
          ),
        )
            : Container(),

        Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _verificarAndamento(context, snapshot),

              ],
            )
        ),

      ],
    );
  }

  void _enviarMensagem() {
    if(activeField){
//      setState(() {
//        activeButton = false;
//      });
      PedidoDao.internal().enviarMensagem(_messagemController.text, widget._idPedido).then((response){
        if(response['status'] == 'success'){
          _messagemController.text = '';
          setState(() {
            activeField = false;
            activeButton = true;
          });
        }else{
          MessageUtil.alertMessageScreen(context,
              "Erro",
              response['resposta'],
              [
                FlatButton(
                  child: Text('OK'),
                  onPressed: (){
                    setState(() {
                      activeField = false;
                      activeButton = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ]
          );
        }

      }).catchError((error){
        MessageUtil.alertMessageScreen(context,
            "Erro",
            "Ocorreu um erro ao enviar sua mensagem para o pareiro. Tente novamente mais tarde.",
            [
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  setState(() {
                    activeField = false;
                    activeButton = true;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ]
        );
      });
    }
  }




  List<Widget> _screenListProdutos(BuildContext context, AsyncSnapshot snapshot){
    List<Widget> lista = List<Widget>();

    for(ItemPedidoDetail itemPedidoDetail in snapshot.data.itens){
      lista.add(
        ListTile(
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(itemPedidoDetail.getImagem),
                    fit: BoxFit.cover)),
          ),
          title:  Text("${itemPedidoDetail.quantidade} x ${itemPedidoDetail.getNomeProduto}",
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Configuration.colorAccent1)),
          trailing: Container(
              child: Column(
                children: <Widget>[
//                  VALOR
                  Text(
//                      FormatUtil.adicionaMascaraDinheiro(itemPedidoDetail.valorPedido),
                      itemPedidoDetail.valorPedido,
                      style: TextStyle(
                          fontSize: 11.0,
                          color: Color.fromRGBO(100, 100, 143, 1.0)
                      )
                  ),
//                  QUANTIDADE
                  Text(
                    FormatUtil.adicionaMascaraDinheiro(itemPedidoDetail.getPreco),
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(36, 36, 143, 1.0)),
                  ),
                ],
              )),
//              dense: true,
        ),
      );
    }

    return lista;
  }

  Widget _verificarAndamento(BuildContext context, AsyncSnapshot<PedidoDetail> snapshot){
    if(snapshot.data.getBotaoConfirmar){
      return  RaisedButton(
//                              color: Color.fromRGBO(36, 36, 143, 1.0),
          child: Text("Confirmar recebimento",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0)),
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(5.0),
//                              ),
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          onPressed: () {
            List<Widget> actions = List();
            actions.add(FlatButton(
              child: Text('Não'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ));
            actions.add(FlatButton(
              child: Text('Sim'),
              onPressed: (){
                Navigator.of(context).pop();
                _confirmarRecebimentoPedido(context, actions);
              },
            ));
            MessageUtil.alertMessageScreen(context,
                "Confirmar recebimento do Pedido?",
                "Alerta: Só realize esta ação quando estiver com o pedido em mãos"
                    " e estiver efetuado o pagamento!",
                actions);
          }
      );


    }else if(!snapshot.data.avaliado && snapshot.data.andamento == 'Pedido Entregue'){
      return  RaisedButton(
          child: Text("Avaliar",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0)),
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(5.0),
//                              ),
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return _getAvaliacaoPage(widget._idPedido);
            }));
          }
      );
    }else{
      return Container();
    }
  }

 void  _confirmarRecebimentoPedido(BuildContext context, List<Widget> actions){
    JsonUtils.confirmarRecebimento(widget._idPedido).then((retorno){
      if(retorno){
        actions = List();
        actions.add(FlatButton(
          child: Text('Não'),
          onPressed: (){
            Navigator.of(context).pop();
            setState(() {
            });
          },
        ));
        actions.add(FlatButton(
          child: Text('Sim'),
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return _getAvaliacaoPage(widget._idPedido);
            }));

          },
        ));
        MessageUtil.alertMessageScreen(context,
            "Recebimento confirmado com sucesso! ☺\n\n Deseja avaliar o pedido?",
            "",
            actions);

      }else{
        actions = List();
        actions.add(FlatButton(
          child: Text('Entendi'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ));
        MessageUtil.alertMessageScreen(context,
            "Confirmação de recebimento não finalizada!",
            "Ocorreu um erro ao confirmar o seu pedido. ",
            actions);

      }
    });
  }




  Widget _getAvaliacaoPage(int idPedido){
    return FutureBuilder<List<Avaliacao>>(
      future: AvaliacaoDao.internal().listAll(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return  Center(
            child: Container(
              width: 200.0,
              height: 200.0,
              color: Configuration.colorWrite1,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                strokeWidth: 5.0,
              ),
            ),
          );

        }else{
          return AvaliacaoPage.instance(snapshot.data, idPedido);
        }
      },
    );
  }





}
