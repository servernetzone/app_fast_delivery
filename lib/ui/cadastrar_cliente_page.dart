import 'dart:convert';

import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:appfastdelivery/ui/endereco_login_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:masked_text/masked_text.dart';
import 'package:appfastdelivery/helper/cliente2.dart';
import 'package:appfastdelivery/util/json_utils.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';



class CadastrarClientePage extends StatefulWidget {
  final String token;
  final String numero;
  final Cliente cliente;
  final String status;

  CadastrarClientePage(this.token,{this.numero, this.cliente, this.status : ''});

  @override
  _CadastrarClientePageState createState() => _CadastrarClientePageState();
}

class _CadastrarClientePageState extends State<CadastrarClientePage> {
  String _token;

  TextEditingController _nameController = TextEditingController(text: '');
  MaskedTextController _cpfController = MaskedTextController(text: '', mask: '000.000.000-00');
  TextEditingController _phoneController = MaskedTextController(text: '', mask: '(00) 00000-0000');
  TextEditingController _loginController = TextEditingController(text: '');
  TextEditingController _senhaController = TextEditingController(text: '');
  MaskedTextController _codigoController = MaskedTextController(text: '', mask: '@@@@@@@@');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();
  bool active = true;

  @override
  void initState() {
    super.initState();
    _token = widget.token;
    print(widget.numero);
    if(widget.numero == null){
      _phoneController.text = '';
    }else{
      _phoneController.text = widget.numero.contains('+55')
          ? widget.numero.replaceAll('+55', '')
          : widget.numero;
    }

    if(widget.cliente != null){
      _nameController.text = widget.cliente.nome;
      _cpfController.text = widget.cliente.cpf;
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  margin: EdgeInsets.only(bottom: 0.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: AssetImage("images/logo.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Text('FastDelivery',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0),
                ),
                SizedBox(height: 20.0,),
              ],
            ),

            TextFormField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration:
              InputDecoration(
                labelText: "Nome",
                alignLabelWithHint: true,
                hintText: "Nome + Sobrenome",
                labelStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
              ),
              style: TextStyle(fontSize: 15.0),
              validator: (value){
                String text = null;
                if(value.isEmpty){
                  text = "Você esqueceu de preencher aqui!";
                }
                List<String> nomes = value.split(" ");
                if(nomes.length <= 1 || nomes.length > 5){
                  text = 'É esperado um nome e sobrenome!';
                }
                return text;
              },
            ),
            SizedBox(height: 10.0,),
            TextFormField(
              controller: _cpfController,
              decoration:
              InputDecoration(
                labelText: "CPF",
                alignLabelWithHint: true,
                hintText: "Digite seu CPF",
                labelStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
              ),
              style: TextStyle(fontSize: 15.0),
              keyboardType: TextInputType.number,
              validator: (value){
                String text = null;
                if(value.isEmpty){
                  text = "Você esqueceu de preencher aqui!";
                }
                if(value == "000.000.000-00"){
                  text = 'É esperado um cpf válido!';
                }
                if(value.length < 14){
                  text = 'É esperado um cpf válido!';
                }
                return text;
              },
            ),
            SizedBox(height: 10.0,),
            TextFormField(
              controller: _phoneController,
              decoration:
              InputDecoration(
                labelText: "Telefone",
                alignLabelWithHint: true,
                hintText: "(00) 00000-0000",
                labelStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
              ),
              style: TextStyle(fontSize: 15.0),
              keyboardType: TextInputType.phone,
              validator: (value){
                String text = null;
                if(value.isEmpty){
                  text = "Você esqueceu de preencher aqui!";
                }
                if(value.length < 15){
                  text = "Este número de telefone é inválido";
                }

                if(value == '(00) 00000-0000'){
                  text = "Este número de telefone é inválido";
                }
                return text;
              },

            ),
            SizedBox(height: 10.0,),
            TextFormField(
              controller: _loginController,
              decoration:
              InputDecoration(
                labelText: "E-mail",
                alignLabelWithHint: true,
                hintText: "example@gmail.com",
                labelStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
              ),
              style: TextStyle(fontSize: 15.0),
              validator: (value){
                String text = null;
                if(value.isEmpty){
                  text = "Você esqueceu de preencher aqui!";
                }
                if(!value.contains("@")){
                  text = "Digite um e-mail válido";
                }
                return text;
              },
            ),
            SizedBox(height: 10.0,),
            TextFormField(
              controller: _senhaController,
              decoration:
              InputDecoration(
                labelText: "Senha",
                alignLabelWithHint: true,
                hintText: "Letras, números e caracteres",
                labelStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
              ),
              style: TextStyle(fontSize: 15.0),
              obscureText: true,
              validator: (value){
                String text = null;
                if(value.isEmpty){
                  text = "Você esqueceu de preencher aqui!";
                }
                if(value.length < 8){
                  text = "A senha deve conter, no mínimo, 8 caracteres";
                }
                return text;
              },

            ),
            SizedBox(height: 10.0,),
            TextFormField(
              controller: _codigoController,
              decoration:
              InputDecoration(
                labelText: "Código de indicação",
                alignLabelWithHint: true,
                hintText: "Digite seu código de indicação aqui",
                labelStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[800])),
              ),
              style: TextStyle(fontSize: 15.0),
//              keyboardType: TextInputType.number,
              validator: (value){
//                if(value.isEmpty){
//                  return "Você esqueceu de preencher aqui!";
//                }
//                if(value.length != 8){
//                  return 'o código deve ter exatamente 8 digitos!';
//                }
                return null;
              },
            ),
            SizedBox(height: 10.0,),

            Container(
              height: 50.0,
              margin: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                  child: Text("Cadastrar",
                    style: TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                  textColor: Theme.of(context).backgroundColor,
                  color: Theme.of(context).accentColor,
                  onPressed: active == false ? null : () {
                    if(_formKey.currentState.validate()){
                      setState(() {
                        active = false;
                      });
                      String celular = _phoneController.text;
                      celular = celular.replaceAll(RegExp(r'[^\w]+'), "");
                      print('codigoIndicador.text: ${_codigoController.text.toUpperCase()}');
                      Cliente cliente = Cliente(
                          0,
                          _nameController.text,
                          _cpfController.text,
                          '+55$celular',
                          _token,
                          _loginController.text,
                          _senhaController.text,
                        codigoIndicador: _codigoController.text.toUpperCase()
                      );

                      if(widget.cliente == null){
                        ClienteDao.internal().sendCliente(cliente: cliente).then((response){
                          if(response['status'] == 'success'){
                            Cliente cliente = Cliente.fromJson(response['cliente']);
                            print('cliente: $cliente');
                            print('cliente.id: ${cliente.id}');
                            print('cliente.codigoIndicacao: ${cliente.codigoIndicacao}');
                            print('cliente.saldo: ${cliente.saldo}');
                            Session.setCliente(cliente);
                            if(widget.status == 'cadastrar'){
                              print("NOVO CLIENTE (em visitante): ${cliente.nome}");
                              Navigator.of(context).pop();
                            }else{
                              print("NOVO CLIENTE (em login): ${cliente.nome}");
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                                return EnderecoLoginPage();
                              }),(routes){
                                return false;
                              });
                            }
                          }else{
                            MessageUtil.alertMessageScreen(context,
                                'ERRO',
                                ( response['resposta'] as String),
                                [
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      setState(() {
                                        active = true;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ]
                            );
                          }

                        }).catchError((error){
                          print('error $error');
                          MessageUtil.alertMessageScreen(context,
                              'ERRO',
                              'Ocorreu um erro ao enviar os dados para o servidor. Tente novamente mais tarde.',
                              [
                                FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    setState(() {
                                      active = true;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]
                          );

                        });
                      }else{
                        cliente.id = widget.cliente.id;
                        ClienteDao.internal().editCliente(
                          cliente: cliente
                        ).then((response){
                          if(response['status'] == 'success'){
                            Cliente cliente = Cliente.fromJson(response['cliente']);
                            Session.setCliente(cliente);
                            print("CLIENTE: ------- ${cliente.nome}");
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                              return EnderecoLoginPage();
                            }),(routes){
                              return false;
                            });
                          }else{
                            MessageUtil.alertMessageScreen(context,
                                'ERRO',
                                (response['resposta'] as String),
                                [
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      setState(() {
                                        active = true;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ]
                            );
                          }
                        }).catchError((error){
                          print('error $error');
                          MessageUtil.alertMessageScreen(context,
                              'ERRO',
                              'Ocorreu um erro ao atualizar os dados no servidor. Tente novamente mais tarde.',
                              [
                                FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    setState(() {
                                      active = true;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]
                          );

                        });
                      }



                    }

                  }),
            )

          ],
        ),
      )

    );
  }








}











