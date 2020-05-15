//WALTERLY
import 'package:appfastdelivery/dao/endereco_dao.dart';
import 'package:appfastdelivery/helper/cidade.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/bairro_dao.dart';
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/session.dart';

import 'bairro_list_page.dart';
import 'endereco_login_page.dart';
import 'endereco_page.dart';

class EnderecoNewPage extends StatefulWidget {

  EnderecoPedido endereco;
  Cidade cidade;
  bool statusPage = false;

  EnderecoNewPage(this.endereco, {this.cidade, this.statusPage});
  EnderecoNewPage.instance();

  @override
  _EnderecoNewPageState createState() => _EnderecoNewPageState();
}

class _EnderecoNewPageState extends State<EnderecoNewPage> {

  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _numeroController = TextEditingController();
  TextEditingController _complementoController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _referenciaController = TextEditingController();
  TextEditingController _cidadeController = TextEditingController();
  TextEditingController _cepController = TextEditingController();
  TextEditingController _ufController = TextEditingController();

  FocusNode _focus = FocusNode();


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BairroDao _bairroDao;
  EnderecoDao _enderecoDao;
  bool _activeContinuarButton = true;

  EnderecoPedido _enderecoPedido;
//  Endereco _endereco;
  EnderecoCliente _enderecoCliente;

  @override
  void initState() {
    _enderecoDao = EnderecoDao();
    _bairroDao = BairroDao();
//    _enderecoPedido = EnderecoPedido();

    _enderecoPedido = widget.endereco;
    _fillData();



    if(widget.cidade != null){
      print(widget.cidade.descricao);
      print(widget.cidade.bairros[0].descricao);
    }else{
      print(widget.cidade);
    }
    super.initState();
  }

  _fillData(){
    _enderecoController.text = _enderecoPedido.rua != null ? _enderecoPedido.rua : '';
    _numeroController.text = _enderecoPedido.numero != null ?_enderecoPedido.numero.toString() : '';
    _complementoController.text = _enderecoPedido.observacao != null ? _enderecoPedido.observacao : '';
    _bairroController.text = 'SELECIONE';
    _referenciaController.text = _enderecoPedido.referencia != null ? _enderecoPedido.referencia : '';
    _cidadeController.text = _enderecoPedido.cidade != null ? _enderecoPedido.cidade.toUpperCase() : '';
    _ufController.text = _enderecoPedido.uf != null ? _enderecoPedido.uf.toUpperCase() : '';
    _cepController.text = _enderecoPedido.cep != null ? _enderecoPedido.cep : '';
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: Container(
          padding: EdgeInsets.all(20.0),
          color: Theme
              .of(context)
              .backgroundColor,
          child:
          SingleChildScrollView(
            child:
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      padding: EdgeInsets.all(0.0),
                      alignment: Alignment(-0.4, 0),
                      color: Colors.green,
                      icon: Icon(Icons.arrow_back,
                        color: Theme
                            .of(context)
                            .accentColor,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),

                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Entregar onde?',
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .accentColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[


//                      RUA
                        Text('Endereço',
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .accentColor,
                              fontSize: 12.0
                          ),
                        ),
                        TextFormField(
                          focusNode: _focus,
                          controller: _enderecoController,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            hintText: 'Rua, avenida travessa, etc',
                            hintStyle: TextStyle(
                                fontSize: 15.0
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .accentColor
                                )
                            ),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .accentColor
                                )
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .accentColor
                                )
                            ),
                          ),

                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Você esqueceu de preencher aqui!';
                            }
                          },
                        ),

//                      NUMERO E COMPLEMENTO
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text('Número',
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .accentColor,
                                            fontSize: 12.0
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _numeroController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 10.0, 10.0, 10.0),
                                          hintText: 'Digite o número',
                                          hintStyle: TextStyle(
                                              fontSize: 15.0
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor
                                              )
                                          ),
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor
                                              )
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor
                                              )
                                          ),
                                        ),

                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Você esqueceu de\npreencher aqui!';
                                          }
                                          if (value.contains(".") || value.contains(",")) {
                                            return 'Digite somente\nnúmeros!';
                                          }
                                        },
                                      )
                                    ],
                                  )
                              ),
                              SizedBox(width: 30.0),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text('Complemento',
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .accentColor,
                                            fontSize: 12.0
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _complementoController,
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 10.0, 10.0, 10.0),
                                          hintText: 'Apto, bloco, sala',
                                          hintStyle: TextStyle(
                                              fontSize: 15.0
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor
                                              )
                                          ),
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor
                                              )
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),

//                      BAIRRO
                        Text('Bairro',
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .accentColor,
                              fontSize: 12.0
                          ),
                        ),
                        GestureDetector(
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _bairroController,
                              enableInteractiveSelection: false,
//                            enabled: false,
                              onSaved: (value) {
                                print(value);
                                print('foi1');
                              },
                              onFieldSubmitted: (value) {
                                print(value);
                                print('foi2');
                              },


                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.chevron_right,
                                  color: Theme
                                      .of(context)
                                      .accentColor,
//                              size: 18.0
                                ),
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.fromLTRB(
                                    10.0, 10.0, 0.0, 5.0),
                                hintText: 'Selecione o bairro',
                                hintStyle: TextStyle(
                                    fontSize: 15.0
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                    )
                                ),
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                    )
                                ),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                    )
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                    )
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                    )
                                ),

                              ),
                              validator: (value) {
                                if (value == 'SELECIONE') {
                                  return 'Selecione um bairro aqui!';
                                }
                                if (value.isEmpty) {
                                  return 'Você esqueceu de preencher aqui!';
                                }
                              },

                            ),
                          ),
                          onTap: () async {
                            dynamic bairro = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BairroListPage.internal(widget.cidade.bairros);
                            }));
                            _bairroController.text = bairro;
                          },
                        ),
                        SizedBox(height: 10.0),

//                      PONTO DE REFERENCIA
                        Text('Ponto de referência',
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .accentColor,
                              fontSize: 12.0
                          ),
                        ),
                        TextFormField(
                          controller: _referenciaController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            hintText: 'Cor da casa, próximo de...',
                            hintStyle: TextStyle(
                                fontSize: 15.0
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .accentColor
                                )
                            ),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .accentColor
                                )
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .accentColor
                                )
                            ),
                          ),

                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ajude o entregador. Quanto mais detalhes melhor.';
                            }
                          },
                        ),
//                      CEP
                        _verifyCep(),

//                      MUNICIPIO E UF
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text('Município',
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .accentColor
                                                .withOpacity(0.5),
                                            fontSize: 12.0
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _cidadeController,
                                        enabled: false,
                                        style: TextStyle(
                                            color: Configuration.colorWrite2),
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 10.0, 10.0, 10.0),
                                          hintText: '',
                                          hintStyle: TextStyle(
                                              fontSize: 15.0
                                          ),
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor.withOpacity(0.5)
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              SizedBox(width: 30.0),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text('UF',
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .accentColor
                                                .withOpacity(0.5),
                                            fontSize: 12.0
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _ufController,
                                        enabled: false,
                                        style: TextStyle(
                                            color: Configuration.colorWrite2),
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 10.0, 10.0, 10.0),
                                          hintText: '',
                                          hintStyle: TextStyle(
                                              fontSize: 15.0
                                          ),
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor.withOpacity(0.5)
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ),

                            ],
                          ),
                        ),


                      ],
                    ),
                  ),

                  SizedBox(height: 20.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Text('Continuar',
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .backgroundColor
                            ),
                          ),

                          onPressed: !_activeContinuarButton ? null : () {

                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _activeContinuarButton = false;
                              });

                              _enderecoCliente = EnderecoCliente(
                                  _enderecoController.text,
                                  int.parse(_numeroController.text),
                                  _bairroController.text,
                                  _enderecoPedido.cep,
                                  _cidadeController.text,
                                  _referenciaController.text,
                                  _complementoController.text.isNotEmpty == true
                                      ? _complementoController.text
                                      : 'Sem complemento',
                                  widget.cidade.id,
                                  Session.getCliente().id,

                              );

                              print('id: ${_enderecoCliente.id}');
                              print('rua: '+_enderecoCliente.rua);
                              print('numero: ${_enderecoCliente.numero}');
                              print('bairro: '+_enderecoCliente.bairro);
                              print('cep: '+_enderecoCliente.cep);
                              print('cidade: '+_enderecoCliente.nomeCidade);
                              print('referencia: '+_enderecoCliente.referencia);
                              print('observacao: '+_enderecoCliente.observacao);
                              print('idCidade: ${_enderecoCliente.idCidade}');
                              print('idCliente: ${_enderecoCliente.idCliente}');

//                              List<Endereco> enderecos =  Session.getListaEnderecos();
//                              enderecos.add(_endereco);
//                              Session.setListaEnderecos(enderecos);
                              _enderecoDao.novoEndereco(endereco: _enderecoCliente).then((lista){
//                                print(lista.length);
//                                print(lista[0]);
//                                print(lista[1]);

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                print('statusPage: ${widget.statusPage}');

                                if(widget.statusPage){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                    return EnderecoLoginPage();
                                  }));

                                }else{
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                    return EnderecoPage();
                                  }));
                                }


//
//                                List<Widget> actions = List<Widget>();
//                                actions.add(
//                                    FlatButton(child: Text('OK'),
//                                        onPressed: (){
//
//                                          if(lista[1] == ''){
//                                            Session.setListaItens(List());
//                                            Session.getPersistence()
//                                                .save(List(), Session.getIdParceiro());
//                                            Session.setPedido(Pedido.instance());// modificado aki
//                                            Navigator.of(context).popUntil(ModalRoute.withName(Navigator.defaultRouteName));
//                                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                                              return PedidosPage();
//                                            }));
//                                          }else{
//                                            Navigator.of(context).pop();
//                                          }
//                                        })
//                                );
//
//                                MessageUtil.alertMessageScreen(context,
//                                    lista[0],
//                                    lista[1],
//                                    actions);

                              });



//


                            }
                            else{
                              setState(() {
                                _activeContinuarButton = true;
                              });
                            }
                          }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }


  Widget _verifyCep() {
    if (_cepController.text.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text('CEP',
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .accentColor
                      .withOpacity(0.5),
                  fontSize: 12.0
              ),
            ),
            TextFormField(
              controller: _cepController,
              enabled: false,
              style: TextStyle(color: Configuration.colorWrite2),
              decoration: InputDecoration(
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                hintText: '',
                hintStyle: TextStyle(
                    fontSize: 15.0
                ),
                disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme
                            .of(context)
                            .accentColor.withOpacity(0.5)
                    )
                ),
              ),
            )

          ]
      );
    }else{
      return SizedBox(height: 10.0);
    }
  }
}
