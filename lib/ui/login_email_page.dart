import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:appfastdelivery/ui/cadastrar_cliente_page.dart';
import 'package:appfastdelivery/ui/endereco_login_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:flutter/material.dart';

class LoginEmailPage extends StatefulWidget {
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  var _loginController = new TextEditingController(text: '');
  var _senhaController = new TextEditingController(text: '');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      resizeToAvoidBottomInset: false,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/background.png'),
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).accentColor.withOpacity(0.6),
                            BlendMode.darken
                        )
                    ),
                  ),
                height: MediaQuery.of(context).size.height,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('images/logo_reverse.png'),
                            )),
                      ),
                      Text(
                        'Fast Delivery',
                        style: TextStyle(
                            fontSize: 28.0,
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 60.0,
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: TextFormField(
                          controller: _loginController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            alignLabelWithHint: true,
                            hintText: "Digite seu e-mail",
                            hintStyle: TextStyle(fontSize: 13.0),
                            labelStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0 ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
//                          validator: (value){
//                            String text = null;
//                            if(value.isEmpty){
//                              text = 'Você esqueceu de preencher aqui!';
//                            }
//                            return text;
//                          },

                        ),
                      ),
                      Container(
                          height: 60.0,
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: TextFormField(
                            controller: _senhaController,
                            obscureText: true,
                            focusNode: FocusNode(),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              alignLabelWithHint: true,
                              hintText: "Digite sua senha",
                              hintStyle: TextStyle(fontSize: 13.0),
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
//                            validator: (value){
//                              String text = null;
//                              if(value.isEmpty){
//                                text = 'Você esqueceu de preencher aqui!';
//                              }
//                              return text;
//                            },
                          ),
                       ),
                      SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 30.0,
                          child: FlatButton(
                            onPressed: (){
                              if(_loginController.text.isEmpty || !_loginController.text.contains("@")){
                                MessageUtil.alertMessageScreen(
                                    context,
                                    "",
                                    "Informe um e-mail válido!",
                                    [
                                      FlatButton(
                                        child: Text('Entendi'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]
                                );
                              }else{
                                _recuperarSenha(_loginController.text);
                              }
                            },
                            child: Text('Esqueci minha senha'),
                            textColor: Configuration.colorWrite,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: RaisedButton(
                          child: Text(
                            'Acessar',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            try{
                              _validate();
                              String login = _loginController.text;
                              String senha = _senhaController.text;
                              _login(
                                  login: login,
                                  senha: senha
                              );
                            }on Exception catch(exception){
                              MessageUtil.alertMessageScreen(
                                  context,
                                  "Campos inválidos",
                                  exception.toString().replaceAll('Exception: ', ''),
                                  [
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]
                              );
                            }
                          }
                        ),
                      ),
                      SizedBox(height: 15.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: RaisedButton(
                            child: Text(
                              'Criar Conta',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                return CadastrarClientePage(Session.getToken());
                              }));
                            }
                        ),
                      )


                    ],
                  ),
                ),
              )
            ],
          )
        ],
      )
    );
  }

  void _recuperarSenha(String login){
    ClienteDao.internal().recuperarSenha(
        login: login,
    ).then((response){
      if(response['status'] == 'success'){
        MessageUtil.alertMessageScreen(
            context,
            "Recuperação de senha",
            "${response['resposta'] as String}",
            [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
        );
      }else{
        print(response['resposta']);
        MessageUtil.alertMessageScreen(
            context,
            "Erro ao recuperar senha",
            "${response['resposta'] as String}",
            [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
        );
      }
    }).catchError((error){
      print('ERRO ===== ${error.toString()}');
      MessageUtil.alertMessageScreen(
          context,
          "Erro ao recuperar senha",
          "Não foi possível recuperar sua senha. Tente novamente mais tarde",
          [
            FlatButton(
              child: Text('Entendi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]
      );
    });
  }


  _validate(){
    if(_loginController.text.isEmpty){
      throw Exception('Você esqueceu de informar o e-mail.');
    }
    if(_senhaController.text.isEmpty){
      throw Exception('Você esqueceu de informar a senha.');
    }
    if(_senhaController.text.length < 8){
      throw Exception('A senha deve conter, no mínimo, 8 caracteres.');
    }
  }


  void _login({String login, String senha}){
    ClienteDao.internal().fazerLogin(
      login: login,
      senha: senha
    ).then((response){
      if(response['status'] == 'success'){

        Cliente cliente = Cliente.fromJson(response['cliente']);
        Session.setCliente(cliente);
        String token = Session.getToken();
        if(cliente.token != token){
          ClienteDao.internal().updateToken(cliente.id, token).then((client){
            print("client: ${client}");
            if(client != null){
              client.id = cliente.id;
              Session.setCliente(client);
              print('LoginPage._verificarCadastro - Session.getCliente(): ${Session.getCliente().id} - ${Session.getCliente().nome}');
            }
          }).catchError((error){
            Session.setCliente(cliente);
          });


//          JsonUtils.atualizarCliente(cliente: Session.getCliente()).then((client){
//            if(client != null){
//              client.id = cliente.id;
//              Session.setCliente(client);
//              print('LoginEmailPage._verificarCadastro - Session.getCliente2(): ${Session.getCliente().id} - ${Session.getCliente().nome}');
//            }
//          });
        }else{
          Session.setCliente(cliente);
        }

//        Navigator.of(context).push(MaterialPageRoute(builder: (context){
//          return EnderecoLoginPage();
//        }));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
          return EnderecoLoginPage();
        }), (routes) => false,);

      }else{
        print(response['resposta']);
        MessageUtil.alertMessageScreen(
            context,
            "Erro ao efetuar login",
            "${response['resposta'] as String}",
            [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
        );
      }
    }).catchError((error){
      print('ERRO ===== ${error.toString()}');
      MessageUtil.alertMessageScreen(
          context,
          "Erro ao efetuar login",
          "Não foi possível efetuar o login. Tente novamente mais tarde",
          [
            FlatButton(
              child: Text('Entendi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]
      );
    });
  }


}
