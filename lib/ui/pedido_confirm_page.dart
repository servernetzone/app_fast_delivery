import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/helper/carrinho.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:appfastdelivery/ui/carrinho_page.dart';
import 'package:appfastdelivery/ui/pedidos_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/json_utils.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';

import 'home_page.dart';

class PedidoConfirmPage extends StatefulWidget {
  @override
  _PedidoConfirmPageState createState() => _PedidoConfirmPageState();
}

class _PedidoConfirmPageState extends State<PedidoConfirmPage> {
  double _valorItens = 0.0;
  double _valorTaxa = 0.0;
  bool active = true;

  TextEditingController _observacaoController = TextEditingController();
  TextEditingController _ticketController = TextEditingController();
  FocusNode _focus = FocusNode();


  @override
  void initState() {
    _valorItens = _calcularValorTotal();
    if((Session.getFormaPagamento().tipo.toUpperCase() == 'CREDITO' || Session.getFormaPagamento().tipo.toUpperCase() == 'DEBITO') && Session.getParceiro().porcentagemCartao != 0.0){
      _valorTaxa = _valorItens * (Session.getParceiro().porcentagemCartao/100);
//      _valorItens = _valorTaxa + _valorItens;
    }
    print(_valorItens);
    print(Session.getPedido().valorEntrega);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Confirme seu pedido', style: TextStyle(fontSize: 16.0)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
//            color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: ImageUtil.loadWithRetry(
                                      Session.getParceiro().imagemLogo),
                                  fit: BoxFit.cover),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '${Session.getParceiro().nome}',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 13.0),
                          maxLines: 5,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 7.0),

//                PRODUTOS
                  Text(
                    'PRODUTOS',
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 7.0, bottom: 7.0),
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      direction: Axis.horizontal,
                      children: _screenListProdutos(context),
                    ),
                  ),
                  SizedBox(height: 7.0),

//                ENTREGA
                  Text(
                    'ENTREGA',
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 7.0, bottom: 7.0),
                    child: Text(
                      '${Session.getPedido().endereco.rua}, ${Session.getPedido().endereco.numero}'
                              .toUpperCase() +
                          '\n${Session.getPedido().endereco.bairro}'
                              .toUpperCase() +
                          ' - ${Session.getPedido().endereco.observacao}'
                              ' - ${Session.getPedido().endereco.referencia}\n'
                              '${Session.getPedido().endereco.cep}'
                              ' - ${Session.getPedido().endereco.cidade.toUpperCase()}',
                      style: TextStyle(fontSize: 13.0),
                      maxLines: 7,
                    ),
                  ),
                  SizedBox(height: 7.0),

//              PAGAMENTO
                  Text(
                    'PAGAMENTO',
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${Session.getFormaPagamento().descricao}'
                        '${Session.getFormaPagamento().tipo == 'dinheiro' || Session.getFormaPagamento().tipo == 'saldo' ? '' : Session.getFormaPagamento().tipo}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.5),
                      ),
                      Container(
                        height: 35.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Session.getFormaPagamento().tipo == 'saldo' ? AssetImage(Session.getFormaPagamento().imagem) :ImageUtil.loadWithRetry(
                                    Session.getFormaPagamento().imagem))),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.0),
                  Session.getFormaPagamento().tipo.toUpperCase() == 'CREDITO' ||  Session.getFormaPagamento().tipo.toUpperCase() == 'DEBITO'
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
                          Text(FormatUtil.adicionaMascaraProcentagem(Session.getParceiro().porcentagemCartao, decimal: 1),
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
                          Text(FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(_valorTaxa)),
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12.5
                            ),
                          ),
                        ],
                      ),
                    ],
                  ): Container(),
                  SizedBox(height: 7.0),

//              TOTAIS
                  Text('TOTAIS',
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 7.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Produtos',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            Text(
                              FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(_valorItens+_valorTaxa)),
                              style: TextStyle(
                                  color: Configuration.colorAccent1,
                                  fontSize: 13.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Entrega',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            Text(
                              FormatUtil.adicionaMascaraDinheiro(
                                  FormatUtil.doubleToPrice(
                                      Session.getPedido().valorEntrega)),
                              style: TextStyle(
                                  color: Configuration.colorAccent1,
                                  fontSize: 13.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                            ),
                            Text(
                              FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(((_valorItens+_valorTaxa) + Session.getPedido().valorEntrega))),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.0),

//              OBSERVAÇÕES
                  Text(
                    'OBSERVAÇÕES',
                    style: TextStyle(
                        color: Configuration.colorAccent1,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),

//                  Container(
//                      padding:
//                          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//
//                          Padding(
//                            padding: EdgeInsets.only(bottom: 6.0),
//                            child: RaisedButton(
//                                child: Text("Confirmar pedido",
//                                    style: TextStyle(
//                                        color:
//                                            Theme.of(context).backgroundColor,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 14.0)),
//                                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                                onPressed: active
//                                    ? () {
//                                  setState(() {
//                                    active = false;
//                                  });
//                                  Session.getPedido().valor = FormatUtil.fixedValueDouble(_valorItens);
//                                  Session.getPedido().parceiro = Session.getIdParceiro();
//                                  Session.getPedido().cliente = Session.getCliente().id;
//                                  Session.getPedido().observacao = _observacaoController.text.isNotEmpty == true
//                                          ? _observacaoController.text
//                                          : '';
//                                  Session.getPedido().itens.clear();
//                                  for (ItemCarrinho itemCarrinho in Session.getListaItens()) {
//                                    ItemPedido itemPedido = ItemPedido(
//                                        itemCarrinho.idProduto,
//                                        itemCarrinho.quantidade,
//                                        itemCarrinho.valor,
//                                        'situação',
//                                        itemCarrinho.observacao.isEmpty == true
//                                            ? 'Sem observações' : itemCarrinho.observacao,
//                                        _montarObjetoEscolhaAdicional(
//                                            itemCarrinho.adicionaisEscolhidos));
//                                    Session.getPedido().itens.add(itemPedido);
//                                  }
//
//                                  JsonUtils.novoPedido(pedido: Session.getPedido()).then((lista) {
//                                    List<Widget> actions = List<Widget>();
//                                    actions.add(
//                                        FlatButton(
//                                        child: Text('OK'),
//                                        onPressed: () {
//                                          if (lista[1] == 'SALVO') {
//                                            Session.setListaItens(List());
//                                            Session.getPersistence().save(
//                                                List(),
//                                                Session.getIdParceiro());
//                                            Session.setPedido(Pedido
//                                                .instance()); // modificado aki
////                                             Navigator.of(context).popUntil(ModalRoute.withName(HomePage.routeName));
////                                             Navigator.of(context).push(MaterialPageRoute(builder: (context){
////                                               return PedidosPage();
////                                             }));
//
//                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
//                                                return HomePage();
//                                            }),
//                                              ModalRoute.withName(HomePage.routeName),
//                                            );
//                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                                              return PedidosPage();
//                                            }));
//                                          } else {
//                                            Navigator.of(context).pop();
//                                            setState(() {
//                                              active = true;
//                                            });
//                                          }
//                                        }));
//
//                                    MessageUtil.alertMessageScreen(
//                                        context,
//                                        lista[0],
//                                        lista[1] == 'SALVO'
//                                            ? 'Verifique o andamento na lista de pedidos realizados.'
//                                            : lista[1],
//                                        actions);
//                                  });
//                                  print('=================================================================');
//                                  print('======================== PEDIDO =================================');
//                                  print('porcentagemCartao: ${Session.getPedido().porcentagemCartao}\n');
//                                  print('valor (valor dos itens sem valorEntrega): ${Session.getPedido().valor}');
//                                  print('tipo : ${Session.getPedido().tipo}');
//                                  print('situacao: ${Session.getPedido().situacao}');
//                                  print('status: ${Session.getPedido().status}');
//                                  print('entrega: ${Session.getPedido().entrega}');
//                                  print('observacao: ${Session.getPedido().observacao}');
//                                  print('idParceiro: ${Session.getPedido().parceiro}');
//                                  print('======================== Endereço =========================================');
//                                  print('Endereco: ${Session.getPedido().endereco}');
//                                  print('rua: ${Session.getPedido().endereco.rua}');
//                                  print('numero: ${Session.getPedido().endereco.numero}');
//                                  print('bairro: ${Session.getPedido().endereco.bairro}');
//                                  print('cep: ${Session.getPedido().endereco.cep}');
//                                  print('referencia: ${Session.getPedido().endereco.referencia}');
//                                  print('observacao: ${Session.getPedido().endereco.observacao}');
//                                  print('cidade: ${Session.getPedido().endereco.cidade}');
//                                  print('idCidade: ${Session.getPedido().endereco.idCidade}');
//                                  print('idCliente do endereco: ${Session.getPedido().endereco.idCliente}');
//                                  print('=================================================================');
//                                  print('idCliente: ${Session.getPedido().cliente}');
//                                  print('valorPagoCliente (entrega+valor): ${Session.getPedido().valorPagoCliente}');
//                                  print('valorEntrega: ${Session.getPedido().valorEntrega}');
//                                  print('============================  Pagamento ==========================');
//                                  print('pagamentosPedido: [id] ${Session.getPedido().pagamentosPedido[0].formaPagamento}');
//                                  print('valor: [entrega+valor] ${Session.getPedido().pagamentosPedido[0].valor}');
//                                  print('========================= Carrinho ==============================');
//
//                                  for (ItemPedido itemPedido in Session.getPedido().itens) {
//                                    print('idproduto: ${itemPedido.produto}');
//                                    print('quantidade: ${itemPedido.quantidade}');
//                                    print('valorItem: ${itemPedido.valorPedido}');
//                                    print('situacao: ${itemPedido.situacao}');
//                                    print('observacao: ${itemPedido.observacao}');
//                                    for (EscolhaAdicional escolhaAdicional in itemPedido.adicionais) {
//                                      print('pkadicional ${escolhaAdicional.pkdoadicional}');
//                                    }
//                                  }
//                                }
//                                : null
//                                ),
//                          ),
//                          Padding(
//                            padding: EdgeInsets.only(bottom: 30.0),
//                            child: OutlineButton(
//                                child: Text("Voltar ao carrinho",
//                                    style: TextStyle(
//                                        color: Configuration.colorRed,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 14.0)),
//                                borderSide:
//                                    BorderSide(color: Configuration.colorRed),
//                                padding:
//                                    EdgeInsets.only(top: 15.0, bottom: 15.0),
//                                onPressed: () {
//                                  Navigator.of(context).push(
//                                      MaterialPageRoute(builder: (context) {
//                                    return CarrinhoPage(
//                                        Session.getListaItens());
//                                  }));
//                                }),
//                          ),
//                        ],
//                      )),

                  Container(
                      padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 6.0),
                            child: TextField(
                              focusNode: _focus,
                              controller: _observacaoController,
                              maxLines: 3,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Configuration.colorWrite3,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Configuration.colorWrite3,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Configuration.colorWrite3,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),

//                                labelText: 'Observações:',
//                                labelStyle: TextStyle(
//                                    color: Colors.indigo,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 14.0),
                                  alignLabelWithHint: true,
                                  hintText:
                                  'Alguma observação para o pedido, entrega, etc...',
                                  hintStyle: TextStyle(fontSize: 13.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: TextField(
                              controller: _ticketController,
                              maxLines: 1,
                              enabled: Session.getFormaPagamento().tipo != 'saldo',
                              style: TextStyle(fontSize: 16.0),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:  Theme.of(context).accentColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:  Theme.of(context).accentColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),

                                labelText: 'Ticket:',
                                labelStyle: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                                  alignLabelWithHint: true,
                                  hintText: 'Informe o código do ticket',
                                  hintStyle: TextStyle(fontSize: 15.0)),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 6.0),
                            child: RaisedButton(
                                child: Text("Confirmar pedido",
                                    style: TextStyle(
                                        color:
                                        Theme.of(context).backgroundColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0)),
                                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                                onPressed: active
                                    ? () {
                                  setState(() {
                                    active = false;
                                  });
                                  Session.getPedido().valor = FormatUtil.fixedValueDouble(_valorItens);
                                  Session.getPedido().parceiro = Session.getIdParceiro();
                                  Session.getPedido().cliente = Session.getCliente().id;
                                  Session.getPedido().observacao = _observacaoController.text.isNotEmpty == true
                                      ? _observacaoController.text : '';
                                  Session.getPedido().itens.clear();
                                  Session.getPedido().ticket = _ticketController.text;
                                  for (ItemCarrinho itemCarrinho in Session.getListaItens()) {
                                    ItemPedido itemPedido = ItemPedido(
                                        itemCarrinho.idProduto,
                                        itemCarrinho.quantidade,
                                        itemCarrinho.valor,
                                        'situação',
                                        itemCarrinho.observacao.isEmpty == true
                                            ? 'Sem observações' : itemCarrinho.observacao,
                                        _montarObjetoEscolhaAdicional(itemCarrinho.adicionaisEscolhidos)
                                    );
                                    Session.getPedido().itens.add(itemPedido);
                                  }

                                  JsonUtils.novoPedido(pedido: Session.getPedido()).then((lista) {
                                    List<Widget> actions = List<Widget>();
                                    actions.add(
                                        FlatButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              if (lista[1] == 'SALVO') {
                                                Session.setListaItens(List());
                                                Session.getPersistence().save(
                                                    List(),
                                                    Session.getIdParceiro());
                                                Session.setPedido(Pedido
                                                    .instance()); // modificado aki
//                                             Navigator.of(context).popUntil(ModalRoute.withName(HomePage.routeName));
//                                             Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                                               return PedidosPage();
//                                             }));

                                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                                                  return HomePage();
                                                }),
                                                  ModalRoute.withName(HomePage.routeName),
                                                );
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                  return PedidosPage();
                                                }));
                                              } else {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  active = true;
                                                });
                                              }
                                            }));

                                    MessageUtil.alertMessageScreen(
                                        context,
                                        lista[0],
                                        lista[1] == 'SALVO'
                                            ? 'Verifique o andamento na lista de pedidos realizados.'
                                            : lista[1],
                                        actions);
                                  });
                                  print('=================================================================');
                                  print('======================== PEDIDO =================================');
                                  print('porcentagemCartao: ${Session.getPedido().porcentagemCartao}\n');
                                  print('ticket: ${Session.getPedido().ticket}\n');
                                  print('valor (valor dos itens sem valorEntrega): ${Session.getPedido().valor}');
                                  print('tipo : ${Session.getPedido().tipo}');
                                  print('situacao: ${Session.getPedido().situacao}');
                                  print('status: ${Session.getPedido().status}');
                                  print('entrega: ${Session.getPedido().entrega}');
                                  print('observacao: ${Session.getPedido().observacao}');
                                  print('idParceiro: ${Session.getPedido().parceiro}');
                                  print('======================== Endereço =========================================');
                                  print('Endereco: ${Session.getPedido().endereco}');
                                  print('rua: ${Session.getPedido().endereco.rua}');
                                  print('numero: ${Session.getPedido().endereco.numero}');
                                  print('bairro: ${Session.getPedido().endereco.bairro}');
                                  print('cep: ${Session.getPedido().endereco.cep}');
                                  print('referencia: ${Session.getPedido().endereco.referencia}');
                                  print('observacao: ${Session.getPedido().endereco.observacao}');
                                  print('cidade: ${Session.getPedido().endereco.cidade}');
                                  print('idCidade: ${Session.getPedido().endereco.idCidade}');
                                  print('idCliente do endereco: ${Session.getPedido().endereco.idCliente}');
                                  print('=================================================================');
                                  print('idCliente: ${Session.getPedido().cliente}');
                                  print('valorPagoCliente (entrega+valor): ${Session.getPedido().valorPagoCliente}');
                                  print('valorEntrega: ${Session.getPedido().valorEntrega}');
                                  print('============================  Pagamento ==========================');
                                  if(Session.getPedido().pagamentosPedido != null){
                                    print('pagamentosPedido: [id] ${Session.getPedido().pagamentosPedido[0].formaPagamento}');
                                    print('valor: [entrega+valor] ${Session.getPedido().pagamentosPedido[0].valor}');
                                  }else{
                                    print('pagamentosPedido: ${Session.getPedido().pagamentosPedido}');
                                    print('pagoComSaldo: ${Session.getPedido().pagoComSaldo}');
                                  }
                                  print('========================= Carrinho ==============================');

                                  for (ItemPedido itemPedido in Session.getPedido().itens) {
                                    print('idproduto: ${itemPedido.produto}');
                                    print('quantidade: ${itemPedido.quantidade}');
                                    print('valorItem: ${itemPedido.valorPedido}');
                                    print('situacao: ${itemPedido.situacao}');
                                    print('observacao: ${itemPedido.observacao}');
                                    for (EscolhaAdicional escolhaAdicional in itemPedido.adicionais) {
                                      print('pkadicional ${escolhaAdicional.pkdoadicional}');
                                    }
                                  }
                                }
                                    : null
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 30.0),
                            child: OutlineButton(
                                child: Text("Voltar ao carrinho",
                                    style: TextStyle(
                                        color: Configuration.colorRed,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0)),
                                borderSide:
                                BorderSide(color: Configuration.colorRed),
                                padding:
                                EdgeInsets.only(top: 15.0, bottom: 15.0),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return CarrinhoPage(
                                            Session.getListaItens());
                                      }));
                                }),
                          ),
                        ],
                      )),
                ],
              )),
        ));
  }

  double _calcularValorTotal() {
    List<ItemCarrinho> itens = Session.getListaItens();
    double valorTotal = 0.0;
    for (ItemCarrinho itemCarrinho in itens) {
      valorTotal += (itemCarrinho.valor * itemCarrinho.quantidade);
    }
    return valorTotal;
  }

  List<Widget> _screenListProdutos(BuildContext context) {
    List<Widget> lista = List<Widget>();

    for (ItemCarrinho itemCarrinho in Session.getListaItens()) {
      lista.add(
        ListTile(
            contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
            leading: Container(
              width: 65.0,
              height: 60.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          ImageUtil.loadWithRetry(itemCarrinho.imagemProduto),
                      fit: BoxFit.cover)),
            ),
            title: Text(
                "${itemCarrinho.quantidade}x ${itemCarrinho.descricaoProduto}",
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Configuration.colorAccent1)),
            trailing: Container(
              width: 70.0,
              child: Wrap(
                children: <Widget>[
                  Text(
                    FormatUtil.adicionaMascaraDinheiro(
                        FormatUtil.doubleToPrice(itemCarrinho.valor)),
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Color.fromRGBO(100, 100, 143, 1.0)),
                  ),
//                  QUANTIDADE
                  Text(
                    FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(
                        itemCarrinho.valor * itemCarrinho.quantidade)),
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(36, 36, 143, 1.0)),
                  ),
                ],
              ),
            )

//          Container(
//              width: 70.0,
//              child: Column(
//                children: <Widget>[
////                  VALOR
//                  Text(
//                      FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(itemCarrinho.valor)),
//                      style: TextStyle(
//                          fontSize: 13.0,
//                          color: Color.fromRGBO(100, 100, 143, 1.0)),
//
//                  ),
////                  QUANTIDADE
//                  Text(
//                    FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(itemCarrinho.valor * itemCarrinho.quantidade)),
//                    style: TextStyle(
//                        fontSize: 12.0,
//                        fontWeight: FontWeight.bold,
//                        color: Color.fromRGBO(36, 36, 143, 1.0)),
//                  ),
//                ],
//              )
//          ),
//              dense: true,
            ),
      );
    }

    return lista;
  }

  List<EscolhaAdicional> _montarObjetoEscolhaAdicional(
      List<AdicionalEscolhido> adicionaisEscolhidos) {
    List<EscolhaAdicional> lista = List<EscolhaAdicional>();
    for (AdicionalEscolhido adicionalEscolhido in adicionaisEscolhidos) {
      EscolhaAdicional escolhaAdicional =
          EscolhaAdicional(adicionalEscolhido.id);
      lista.add(escolhaAdicional);
    }
    return lista;
  }
}
