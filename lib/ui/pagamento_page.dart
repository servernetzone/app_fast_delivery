import 'package:appfastdelivery/util/message_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:appfastdelivery/dao/forma_pagamento_dao.dart';
import 'package:appfastdelivery/helper/carrinho.dart';
import 'package:appfastdelivery/helper/forma_pagamento.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:appfastdelivery/ui/pedido_confirm_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/session.dart';


class PagamentoPage extends StatefulWidget {
  @override
  _PagamentoPageState createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  FormaPagamentoDao _formaPagamentoDao = FormaPagamentoDao();
  Future<List<FormaPagamento>> _future;
  FormasPagamentoPedido _formasPagamentoPedido;
  double _valorCompra;
  double _valorTotal;
  double _valorTaxa;

  var _valorTrocoController = MoneyMaskedTextController(
    precision: 2,
    decimalSeparator: ',',

  );


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
//    _formaPagamentoDao = FormaPagamentoDao();
    _future = _initFuture();
    super.initState();

    _valorCompra = _calcularValorTotal();
    _valorTotal = _valorCompra + Session.getPedido().valorEntrega;
    print('_valorCompra: $_valorCompra');
    print('valorEntrega: ${Session.getPedido().valorEntrega}');
    print('_valorTotal: $_valorTotal');
  }

  Future<List<FormaPagamento>> _initFuture() async{
    return _formaPagamentoDao.list(Session.getIdParceiro());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       appBar: AppBar(
         title: Text('Como prefere pagar?',
             style: TextStyle(
                 fontSize: 16.0)
         ),
         centerTitle: true,
       ),
      body: SingleChildScrollView(
        child:
        FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child:
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                        strokeWidth: 5.0,
                      ),
                    ),
                  );

                default:
                  if (snapshot.hasError) {
                    return Container(
                      child: Center(
                        child: Text(
                            "A conexão falhou!"),
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10.0),

                          Text('Pagamento na entrega',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child:
                            Wrap(
                              spacing: 50.0,
                              runSpacing: 0.0,
                              direction: Axis.horizontal,
                              children: _verifyPaymentForm(context, snapshot, 'DINHEIRO'),
                            ),
                          ),
                          SizedBox(height: 10.0),

                          Text('Cartão de crédito',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Wrap(
                              spacing: 10.0,
                              runSpacing: 3.0,
                              direction: Axis.horizontal,
                              children: _verifyPaymentForm(context, snapshot, 'CREDITO'),
                            ),
                          ),

                          Text('Cartão de dédito',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Wrap(
                              spacing: 5.0,
                              runSpacing: 3.0,
                              direction: Axis.horizontal,
                              children: _verifyPaymentForm(context, snapshot, 'DEBITO'),
                            ),
                          ),
                          SizedBox(height: 10.0),


                          Text('Pagamento com saldo. Saldo atual: ${FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(Session.getCliente().saldo))}',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Container(
                                width: 155.0,
                                height: 50.0,
                                child:
                                ListTile(
                                  contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  leading: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: AssetImage('images/saldo.png'),
                                        )
                                    ),
                                  ),
                                  title: Text('SALDO',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: (){

                                    Session.setFormaPagamento(FormaPagamento(00, 'SALDO', 'images/saldo.png', 'saldo'));
                                    Session.getPedido().pagamentosPedido = null;
                                    Session.getPedido().pagoComSaldo = true;
                                    Session.getPedido().porcentagemCartao = Session.getParceiro().porcentagemCartao;
                                    Session.getPedido().valorPagoCliente =  _valorCompra + Session.getPedido().valorEntrega;
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                      return PedidoConfirmPage();
                                    }));
                                    print('Ação via saldo:');
                                    print('id: ${ Session.getFormaPagamento().id}');
                                    print('descrição: ${ Session.getFormaPagamento().descricao}');
                                    print('tipo: ${ Session.getFormaPagamento().tipo}');

                                  },
                                )
                            ),
                          ),


                          Container(
                            margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
                            child: Text('O pagamento é realizado no ato da entrega do pedido.'
                                'Caso escolha pagar no cartão, o entregador irá levar a '
                                'maquininha até você.',
                              style: TextStyle(
                                color: Configuration.colorAccent1,
                                fontSize: 11.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ],
                      ),
                    );
                  }
              }
            })

      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 50.0,
        color: Colors.white,
        child:
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Configuration.colorWrite1.withOpacity(0.5), style: BorderStyle.solid, width: 1.0)
            )
          ),
          height: 30.0,
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Session.getPedido().entrega == true ? 'Produtos + entrega' : 'Produtos',
                  style: TextStyle(
                    fontSize: 11.0,
                    color: Configuration.colorAccent1
                  ),
                ),
                Text(Session.getPedido().entrega == true
                    ? FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(_valorTotal))
                    : FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(_valorCompra)),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Configuration.colorAccent1,
                    fontWeight: FontWeight.bold
                  ),

                ),
              ],
            ),
          )

        )
      ),

    );
  }



  double _calcularValorTotal() {
    List<ItemCarrinho> itens = Session.getListaItens();
    double valorTotal = 0.00;
    for (ItemCarrinho itemCarrinho in itens) {
      valorTotal += (itemCarrinho.valor * itemCarrinho.quantidade);
    }
//    print(Session.getPedido().valorEntrega);
    return FormatUtil.fixedValueDouble(valorTotal);
  }

  List<Widget> _verifyPaymentForm(BuildContext context, AsyncSnapshot snapshot, String tipo){
    List<Widget> lista = List<Widget>();
    for(FormaPagamento formaPagamento in snapshot.data){
      if(formaPagamento.tipo.toUpperCase() == tipo){
        lista.add(
            Container(
              width: 155.0,
              height: 50.0,
              child:
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: NetworkImage(formaPagamento.imagem)
                            )
                        ),
                      ),
                title: Text(formaPagamento.descricao,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                onTap: (){
                  Session.getPedido().pagamentosPedido = [];
//                  print(formaPagamento.descricao);
                  if(tipo == 'DINHEIRO'){
                    Session.getPedido().pagoComSaldo = false;
                    _showDialogConfirmTroco(context, formaPagamento);
                  }else{
                    Session.getPedido().pagoComSaldo = false;
                    _valorTaxa = 0.0;
                    if(Session.getParceiro().porcentagemCartao == 0.0){
                      _formasPagamentoPedido = FormasPagamentoPedido(
                          formaPagamento.id,   _valorCompra + Session.getPedido().valorEntrega
                      );
                      Session.getPedido().valorPagoCliente =  _valorCompra + Session.getPedido().valorEntrega;
                      Session.setFormaPagamento(formaPagamento);
                      if(Session.getPedido().pagamentosPedido.isNotEmpty){
                        Session.getPedido().pagamentosPedido.clear();
                      }
                      Session.getPedido().porcentagemCartao = Session.getParceiro().porcentagemCartao;
                      Session.getPedido().pagamentosPedido.add(_formasPagamentoPedido);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return PedidoConfirmPage();
                      }));


                      print('Ação no cartão:');
                      print('Cartão: ${formaPagamento.descricao}');
                      print('Session.getPedido().pagamentosPedido[0].formaPagamento: ${Session.getPedido().pagamentosPedido[0].formaPagamento}');
                      print('Session.getPedido().pagamentosPedido[0].valor: ${Session.getPedido().pagamentosPedido[0].valor}');

                    }else{
                      _valorTaxa = _valorCompra * (Session.getParceiro().porcentagemCartao/100);
                      MessageUtil.alertMessageScreen(
                          context,
                          'Você escolheu pagar no cartão!',
                          'Uma taxa de ${FormatUtil.adicionaMascaraProcentagem(Session.getParceiro().porcentagemCartao, decimal: 1)}'
                              ' equivalente a ${FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(_valorTaxa))}'
                              ' para pagamentos no cartão, será aplicada ao valor do seu pedido, '
                              ' conforme definido pelo parceiro ${Session.getParceiro().nome}.\nDeseja confirmar?',
                          [
                            FlatButton(
                                child: Text('Sim'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  print('porcentagem: ${(Session.getParceiro().porcentagemCartao/100)}');
                                  print('valor calculado: $_valorTaxa');
                                  print('valor total: ${_valorCompra + _valorTaxa}');
                                  _formasPagamentoPedido = FormasPagamentoPedido(
                                      formaPagamento.id,  _valorCompra + Session.getPedido().valorEntrega
                                  );
                                  Session.getPedido().valorPagoCliente = _valorCompra + Session.getPedido().valorEntrega;
                                  Session.setFormaPagamento(formaPagamento);
                                  if(Session.getPedido().pagamentosPedido.isNotEmpty){
                                    Session.getPedido().pagamentosPedido.clear();
                                  }
                                  Session.getPedido().pagamentosPedido.add(_formasPagamentoPedido);
                                  Session.getPedido().porcentagemCartao = Session.getParceiro().porcentagemCartao;
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                    return PedidoConfirmPage();
                                  }));


                                  print('Ação no cartão:');
                                  print('Cartão: ${formaPagamento.descricao}');
                                  print('Session.getPedido().pagamentosPedido[0].formaPagamento: ${Session.getPedido().pagamentosPedido[0].formaPagamento}');
                                  print('Session.getPedido().pagamentosPedido[0].valor: ${Session.getPedido().pagamentosPedido[0].valor}');
                                }
                            ),
                            FlatButton(
                                child: Text('Não'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }
                            )
                          ]
                      );
                    }
                    //FAZER PARA CARTÃO
                  }

                },
              )
            )
        );
      }
    }
    return lista;
  }

  _showDialogConfirmTroco(BuildContext context, FormaPagamento formaPagamento){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            Container(
                color: Theme.of(context).accentColor.withOpacity(0.5),
                child:
                Center(
                    child: AlertDialog(
//                                    contentPadding: EdgeInsets.all(5.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        content:
                        Container(
                          height: 120.0,
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Precisa de troco?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                              ),
                              SizedBox(height: 10.0),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('O pedido deu ',
                                    style: TextStyle(
                                        fontSize: 12.0),
                                    textAlign: TextAlign.center,),

                                  Text(FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(_valorCompra+Session.getPedido().valorEntrega)),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                    textAlign: TextAlign.center,),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                      child: Text("Não",
                                        style: TextStyle(
                                            color: Configuration.colorRed2,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      color: Configuration.colorRed.withOpacity(0.2),
                                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(0.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(7.0),
                                              bottomLeft: Radius.circular(7.0)

                                          )
                                      ),
                                      onPressed: (){
                                        Session.getPedido().pagoComSaldo = false;
                                        _formasPagamentoPedido = FormasPagamentoPedido(
                                            formaPagamento.id,  _valorCompra + Session.getPedido().valorEntrega
                                        );
                                        Session.getPedido().valorPagoCliente = _valorCompra + Session.getPedido().valorEntrega;
                                        Session.setFormaPagamento(formaPagamento);
                                        if(Session.getPedido().pagamentosPedido.isNotEmpty){
                                          Session.getPedido().pagamentosPedido.clear();
                                        }
                                        Session.getPedido().pagamentosPedido.add(_formasPagamentoPedido);
                                        Session.getPedido().porcentagemCartao = 0.0;
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                          return PedidoConfirmPage();
                                        }));


                                        print('Ação no dinheiro sem troco:');
                                        print('formaPagamentoId: ${Session.getPedido().pagamentosPedido[0].formaPagamento}');
                                        print('pagamentosPedido[0].valor: ${Session.getPedido().pagamentosPedido[0].valor}');

                                      }),

                                  RaisedButton(
                                      child: Text("Sim",
                                        style: TextStyle(
                                            color: Configuration.colorGreen,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      color: Colors.green.withOpacity(0.2),
                                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(7.0),
                                              bottomRight: Radius.circular(7.0),
                                              topLeft: Radius.circular(0.0),
                                              bottomLeft: Radius.circular(0.0)

                                          )
                                      ),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        _showDialogInputTroco(context, formaPagamento);
                                      }),
                                ],
                              ),

//                                             ButtonBar(
//                                               children: <Widget>[
//                                                 RawMaterialButton(child: Text("ok"), onPressed: (){}),
//                                                 RawMaterialButton(child: Text("ok"), onPressed: (){}),
//                                               ],
//                                             )



                            ],
                          ),
                        )
                    )
                )
            );
        }
    );

  }

  _showDialogInputTroco(BuildContext context, FormaPagamento formaPagamento){
    _valorTrocoController.text = '';
    FocusNode _focus = FocusNode();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            Container(
                color: Theme.of(context).accentColor.withOpacity(0.5),
                child:
                Center(
                    child: AlertDialog(

//                                    contentPadding: EdgeInsets.all(5.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        content:
                        Container(
                          height: 190.0,
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Precisa de troco?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                              ),
                              SizedBox(height: 10.0),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('O pedido deu ',
                                    style: TextStyle(
                                        fontSize: 12.0),
                                    textAlign: TextAlign.center,),

                                  Text(FormatUtil.adicionaMascaraDinheiro(FormatUtil.doubleToPrice(_valorCompra + Session.getPedido().valorEntrega)),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                    textAlign: TextAlign.center,),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child:
                                    TextFormField(
                                      focusNode: _focus,
                                    maxLength: 9,
                                    controller: _valorTrocoController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 14.0
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 10.0, 10.0, 10.0),
                                      labelText: 'Troco para quanto?',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 14.0
                                      ),
                                      hintText: '',
                                      hintStyle: TextStyle(
                                          fontSize: 15.0
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Theme
                                              .of(context)
                                              .accentColor
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme
                                                  .of(context)
                                                  .accentColor
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme
                                                  .of(context)
                                                  .accentColor
                                          )
                                      ),
                                    ),

                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Preencha o campo para prosseguir!';
                                      }

                                      if(value.length <= 6){
                                        double valor = FormatUtil.stringToDouble(value.replaceAll(',', '.'));
//                                        print('menor que 6: $valor');
                                        if(valor <= (_valorCompra + Session.getPedido().valorEntrega)){
                                          return 'O valor digitado é menor\n ou igual do que o valor da compra!';
                                        }
                                      }else{
                                        double valor = FormatUtil.stringToDouble(value.replaceAll('.', '').replaceAll(',', '.'));
//                                        print('maior que 6: $valor');
//                                        print('valor da compra: $_valorCompra');
                                        if(valor <= (_valorCompra + Session.getPedido().valorEntrega)){
                                          return 'Digite um valor maior do que\no valor do pedido!';
                                        }
                                      }


                                    },
                                  ),
                                  ),

                                  FlatButton(
                                      child: Text('Continuar',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      onPressed: (){
                                        if(_formKey.currentState.validate()){
                                          double valor;
                                          if(_valorTrocoController.text.length <= 6){
                                            valor = FormatUtil.stringToDouble(_valorTrocoController.text.replaceAll(',', '.'));
                                          }else{
                                            valor = FormatUtil.stringToDouble(_valorTrocoController.text.replaceAll('.', '').replaceAll(',', '.'));
                                          }
                                          _formasPagamentoPedido = FormasPagamentoPedido(
                                              formaPagamento.id, valor
                                            );
                                          Session.getPedido().valorPagoCliente = valor;
                                          Session.setFormaPagamento(formaPagamento);
                                          if(Session.getPedido().pagamentosPedido.isNotEmpty){
                                            Session.getPedido().pagamentosPedido.clear();
                                          }
                                          Session.getPedido().pagamentosPedido.add(_formasPagamentoPedido);
                                          Session.getPedido().porcentagemCartao = 0.0;
                                          Session.getPedido().pagoComSaldo = false;
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                              return PedidoConfirmPage();
                                          }));

                                          print('Ação no dinheiro com troco:');
                                          print('formaPagamentoId: ${Session.getPedido().pagamentosPedido[0].formaPagamento}');
                                          print('pagamentosPedido[0].valor: ${Session.getPedido().pagamentosPedido[0].valor}');
                                        }
                                      })


                                ],
                              ),

                            ],
                          ),
                        )
                    )
                )
            );
        }
    );

  }


}
