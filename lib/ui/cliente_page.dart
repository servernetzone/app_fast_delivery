import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/nav.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:flutter/material.dart';

import 'alterar_senha_page.dart';
import 'login_page.dart';

class ClientePage extends StatefulWidget {
  ClientePage({PageStorageKey<String> key}) : super(key: key);

  ClientePage.key(key) : super(key: key);

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage>
    with AutomaticKeepAliveClientMixin<ClientePage> {
  bool get wantKeepAlive => true;
  TextEditingController _senhaAntigaController =
      TextEditingController(text: '');
  TextEditingController _senhaNovaController = TextEditingController(text: '');

  @override
  void initState() {
    Cliente cliente = Session.getCliente();
    ClienteDao.internal().getSaldo(cliente.id).then((response) {
      cliente.saldo = (response['saldo'] as num)?.toDouble();
      Session.setCliente(cliente);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Cliente Page');

    return Session.getCliente().id == 1070
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.insert_emoticon,
                  color: Theme.of(context).accentColor,
                  size: 60,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Você está logado como ${Session.getCliente().nome.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).accentColor,
//                  fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Para realizar pedidos, cadastre seus dados pessoais ou faça login com uma conta.',
                  style: TextStyle(
                    fontSize: 15.0,
//                  fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 42.0,
                  child: RaisedButton(
                    child: Text('Fazer login'),
                    textColor: Configuration.colorWrite,
                    onPressed: () {
                      Session.clearCliente();
                      Session.clearEnderecoCliente();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (routes) => false);
                    },
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.insert_emoticon,
                        color: Theme.of(context).accentColor,
                        size: 40,
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          'Nome: ${Session.getCliente().nome}',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold),
                          softWrap: true,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.phone,
                        color: Theme.of(context).accentColor,
                        size: 40,
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          'Tel: ${Session.getCliente().telefone}',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold),
                          softWrap: true,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.contact_mail,
                        color: Theme.of(context).accentColor,
                        size: 40,
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                          child: Text(
                        'CPF: ${Session.getCliente().cpf}',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                        softWrap: true,
                        maxLines: 3,
                      )),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Theme.of(context).accentColor,
                        size: 40,
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          'E-mail: ${Session.getCliente().login}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          maxLines: 3,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    children: <Widget>[
//                Icon(Icons.code, color: Theme.of(context).accentColor,size: 40,),
//                SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          'Código de Indicação: ${Session.getCliente().codigoIndicacao == null ? '' : Session.getCliente().codigoIndicacao}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
//                Icon(Icons.attach_money, color: Theme.of(context).accentColor,size: 40,),
//                SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          'Saldo de indicação: ${FormatUtil.doubleToPrice(Session.getCliente().saldo)}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Cliente cliente = Session.getCliente();
                          ClienteDao.internal()
                              .getSaldo(cliente.id)
                              .then((response) {
                            cliente.saldo =
                                (response['saldo'] as num)?.toDouble();
                            Session.setCliente(cliente);
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.refresh),
//                  textColor: Theme.of(context).accentColor,
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return AlterarSenhaPage();
                          }));
                        },
                        child: Text('Alterar senha'),
                        textColor: Theme.of(context).accentColor,
                        color: Configuration.colorWrite,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  RaisedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return WillPopScope(
                            onWillPop: () async => false,
                            child: AlertDialog(
                              title: Text('Fast Delivery'),
                              content: Text('Deseja realmente sair?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'CANCELAR',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'SIM',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    pop(context);
                                    Session.logout();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return LoginPage();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Sair'),
                    textColor: Theme.of(context).bottomAppBarColor,
                    color: Configuration.colorRed,
                  ),
                ],
              ),
            ),
          );
  }

  void _alterarSenha(BuildContext context, List<Widget> actions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
          color: Theme.of(context).accentColor.withOpacity(0.5),
          child: AlertDialog(
              title: Text('Alterar senha'),
              titleTextStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor),
              content: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _senhaAntigaController,
                      decoration: InputDecoration(
                        labelText: "Senha Atual",
                        alignLabelWithHint: true,
                        hintText: "Letras, números e caracteres",
                        labelStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                      style: TextStyle(fontSize: 14.0),
                      validator: (value) {
                        String text = null;
                        if (value.isEmpty) {
                          text = "Você esqueceu de preencher aqui!";
                        }
                        if (value.length < 8) {
                          text = "A senha deve conter, no mínimo, 8 caracteres";
                        }
                        return text;
                      },
                    ),
                    TextFormField(
                      controller: _senhaAntigaController,
                      decoration: InputDecoration(
                        labelText: "Senha Atual",
                        alignLabelWithHint: true,
                        hintText: "Letras, números e caracteres",
                        labelStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                      style: TextStyle(fontSize: 14.0),
                      validator: (value) {
                        String text = null;
                        if (value.isEmpty) {
                          text = "Você esqueceu de preencher aqui!";
                        }
                        if (value.length < 8) {
                          text = "A senha deve conter, no mínimo, 8 caracteres";
                        }
                        return text;
                      },
                    ),
                  ],
                ),
              ),
              actions: actions),
        );
      },
    );
  }
}
