import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:appfastdelivery/ui/login_email_page.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get_version/get_version.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'cadastrar_cliente_page.dart';
import 'endereco_login_page.dart';

class LoginPage extends StatefulWidget {
  String isVisitant;

  LoginPage({this.isVisitant: ''});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _phoneController = MaskedTextController(mask: '(00) 00000-0000');

  String phoneNumber;
  String codeSms;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _projectVersion;
  final _numberVisitant = '+5500000000000';
  bool active = true;

  initState() {
    super.initState();
    GetVersion.projectVersion.whenComplete(() {
    }).then((version) {
      setState(() {
        this._projectVersion = version;
      });
    }).whenComplete(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/background.png'),
          )),
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).accentColor.withOpacity(0.6),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.all(40.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('images/logo_reverse.png'),
                            )),
                      ),
                      Text(
                        'FastDelivery',
                        style: TextStyle(
                            fontSize: 28.0,
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 60.0,
                        padding: EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: TextField(
                          controller: _phoneController,
                          focusNode: FocusNode(),
                          style: TextStyle(fontSize: 16.0),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 4.0,
                                bottom: 25.0),
                            labelText: "DDD + Celular",
                            alignLabelWithHint: true,
                            hintText: "Entre com DDD + Celular",
                            hintStyle: TextStyle(fontSize: 13.0),
                            labelStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50.0,
                        child: RaisedButton(
                          child: Text(
                            'Acessar',
                            style: TextStyle(
                                color: active
                                    ? Theme.of(context).backgroundColor
                                    : Colors.grey[600],
                                fontSize: 15.0),
                          ),
                          onPressed: active
                              ? () async {
                                  if (_phoneController.text.isEmpty) {
                                    MessageUtil.alertMessageScreen(context, "",
                                        "Informe um número válido!", [
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          setState(() {
                                            active = true;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]);
                                  } else {
                                    setState(() {
                                      active = false;
                                    });
                                    String celular = _phoneController.text;
                                    celular = celular.replaceAll(
                                        RegExp(r'[^\w]+'), "");
                                    celular = '+55' + celular;
                                    this.phoneNumber = celular;
                                    _verificarNumeroTelefone(context);
                                  }
                                }
                              : null,
                        ),
                      ),

                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50.0,
                        child: RaisedButton(
                          child: Text(
                            'Login com E-mail',
                            style: TextStyle(
                                color: active
                                    ? Theme.of(context).backgroundColor
                                    : Colors.grey[600],
                                fontSize: 15.0),
                          ),
                          onPressed: active
                              ? () async {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return LoginEmailPage();
                                  }));
                                }
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50.0,
                        child: FlatButton(
                          child: Text(
                            'Entrar como visitante',
                            style: TextStyle(
                                color: active
                                    ? Theme.of(context).backgroundColor
                                    : Colors.grey[600],
                                fontSize: 15.0),
                          ),
                          onPressed: active
                              ? () async {
                                  ClienteDao.internal()
                                      .getClientFromPhone(
                                          telefone: _numberVisitant)
                                      .then((response) {
                                    print("response: ${response}");
                                    if (response['status'] == 'success') {
                                      Cliente cliente =
                                          Cliente.fromJson(response['cliente']);
                                      Session.setCliente(cliente);
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                          return EnderecoLoginPage();
                                        }),
                                        (routes) => false,
                                      );
                                    } else {
                                      print('Cliente nulo');
                                    }
                                  });
                                }
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Versão: $_projectVersion',
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 13.0,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _verificarNumeroTelefone(BuildContext context) async {
    _auth.currentUser().then((user) {
      if (user != null) {
        _auth.signOut();
      }
    });

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      print('Verificação completada: ${phoneAuthCredential.toString()}');
      _auth.signInWithCredential(phoneAuthCredential).then((user) {
        if (user != null) {
          print('user.uid ${user.uid}');
          print('user.phoneNumber ${user.phoneNumber}');
          Navigator.of(context).pop();
          _verificarCliente();
        } else {
          print(user);
        }
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _verificationFailed(authException);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      setState(() {
        active = true;
      });

      print(' codeAutoRetrievalTimeout - sessão ');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print('verificationId  -  $verificationId');
      dialogOTPSend(context).then((value) {
        print('Sing in: $value');
      });
      setState(() {
        active = true;
      });
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<bool> dialogOTPSend(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return Countdown(
            seconds: 120,
            interval: Duration(milliseconds: 100),
            onFinished: () {
              Navigator.of(context).pop();
              MessageUtil.alertMessageScreen(
                  context,
                  'Fast Delivery',
                  'O tempo limite para o login via SMS expirou. Por favor faça login utilizando email e senha.',
                  [
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LoginEmailPage();
                        }));
                      },
                    )
                  ]);
            },
            build: (context, double time) => AlertDialog(
                title: Text(
                    'Insira o código SMS recebido (${time.floor()} segundos)'),
                content: Container(
                  height: 85.0,
                  child: Column(children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      onChanged: (value) {
                        this.codeSms = value;
                      },
                    ),
                  ]),
                ),
                contentPadding: EdgeInsets.all(10.0),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      setState(() {
                        active = true;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Confirmar'),
                    onPressed: () {
                      _signInWithPhoneNumber();
                    },
                  )
                ]),
          );
        });
  }

  _signInWithPhoneNumber() async {
    try {
      print('iniciou');
      print('SMS: -${codeSms}-');
      print('numero: -${phoneNumber}-');

      print('PhoneAuthProvider.getCredential');
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: this.verificationId,
        smsCode: codeSms,
      );
      print('user');
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      print('user: ${user.uid}');
      print('currentUser');
      final FirebaseUser currentUser = await _auth.currentUser();
      print('currentUser: ${currentUser.uid}');
      print('assert');
      assert(user.uid == currentUser.uid);
      print('TUDO OK');
      Navigator.of(context).pop();
      _verificarCliente();
      print(
          '************************************  USUARIO PERMITIDO   ***************************************************');
    } on PlatformException catch (exception) {
      String title = 'Ocorreu um erro ';
      String subtitle = 'Verifique o código e tente novamente!';

      switch (exception.code) {
        case 'ERROR_INVALID_VERIFICATION_CODE':
          title = 'CÓDIGO DE VERIFICAÇÃO INVÁLIDO';
          subtitle =
              'O código de verificação de sms usado para criar a credencial de autenticação do telefone é inválido. Reenvie o código de verificação sms e use o código de verificação fornecido pelo usuário';
          break;
      }

      List<Widget> actions = List();
      actions.add(FlatButton(
        child: Text('OK'),
        onPressed: () {
          setState(() {
            active = true;
          });
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ));
      MessageUtil.alertMessageScreen(context, title, subtitle, actions);
      print('log - $exception');
    }
  }

  void _verificationFailed(AuthException authException) {
    print(
        'Verificação falhou. Code: ${authException.code}. Message: ${authException.message}');

    switch (authException.code) {
      case 'quotaExceeded':
        _messageError(
            titleError: 'SEU NÚMERO FOI BLOQUEADO!',
            subtitleError:
                'Bloqueamos todos os pedidos deste dispositivo devido a atividades incomuns. Tente novamente mais tarde.');
        break;
      case 'invalidCredential':
        _messageError(
            titleError:
                'O FORMATO DO NÚMERO DE TELEFONE FORNECIDO ESTÁ INCORRETO!',
            subtitleError:
                'Digite o número do telefone em um formato que possa ser analisado no formato E.164 - '
                '(xx) 9xxxx-xxxx.');
        break;
    }
  }

  void _messageError({String titleError, String subtitleError}) {
    MessageUtil.alertSimpleMessageScreen(
        context, titleError, subtitleError, <Widget>[
      FlatButton(
        child: Text('Entendi'),
        onPressed: () {
          setState(() {
            active = true;
          });
          Navigator.of(context).pop();
        },
      )
    ]);
  }

  _verificarCliente() {
//    JsonUtils.buscarCliente(telefone: phoneNumber).then((cliente){
    ClienteDao.internal()
        .getClientFromPhone(telefone: phoneNumber)
        .then((response) {
      print("response: ${response}");
      if (response['status'] == 'success') {
        Cliente cliente = Cliente.fromJson(response['cliente']);
        _verificarCadastro(cliente);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return CadastrarClientePage(Session.getToken(),
                numero: phoneNumber);
          }),
          (routes) => false,
        );
      }
    });
  }

  void _verificarCadastro(Cliente cliente) {
    if ((cliente.login == null || cliente.login.isEmpty) ||
        (cliente.senha == null || cliente.senha.isEmpty)) {
      MessageUtil.alertMessageScreen(
          context,
          'Atualização de Cadastro',
          'Para prosseguir, é necessário atualizar algumas informações sobre seu cadastro nos nossos servidores',
          [
            FlatButton(
              child: Text('Prosseguir'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                    return CadastrarClientePage(Session.getToken(),
                        numero: cliente.telefone, cliente: cliente);
                  }),
                  (routes) => false,
                );
              },
            )
          ]);
    } else {
      print(
          'LoginPage._verificarCadastro =============================================================');
      print('cliente.id: ${cliente.id}');
      print('cliente.nome: ${cliente.nome}');
      print('cliente.telefone: ${cliente.telefone}');
      print('cliente.token: ${cliente.token}');
      print('cliente.login: ${cliente.login}');
      print('cliente.senha ${cliente.senha}');
      print('cliente.saldo ${cliente.saldo}');
      print('cliente.codigoIndicacao ${cliente.codigoIndicacao}');
      print(
          "===========================================================================================\n\n\n");
      Session.setCliente(cliente);
      String token = Session.getToken();
      print('cliente.token: ${cliente.token}');
      print('Session.getToken(): $token');
      if (cliente.token != token) {
        ClienteDao.internal().updateToken(cliente.id, token).then((client) {
          print("client: ${client}");
          if (client != null) {
            client.id = cliente.id;
            Session.setCliente(client);
            print(
                'LoginPage._verificarCadastro - Session.getCliente(): ${Session.getCliente().id} - ${Session.getCliente().nome}');
          }
        }).catchError((error) {
          Session.setCliente(cliente);
        });

      } else {
        Session.setCliente(cliente);
      }
      print('here');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return EnderecoLoginPage();
        }),
        (routes) => false,
      );
    }
  }
}
