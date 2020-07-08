import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/ui/cadastrar_cliente_page.dart';
import 'package:appfastdelivery/ui/home_page.dart';
import 'package:appfastdelivery/ui/login_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'helper/cliente.dart';
import 'helper/pedido.dart';
import 'ui/endereco_login_page.dart';

final ThemeData kDefaultTheme = ThemeData(
    accentColor: Configuration.colorDefault,
    //
    primaryColor: Configuration.colorDefault,
//  primaryColorBrightness: Brightness.light,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      color: Configuration.colorDefault,
      textTheme: TextTheme(
        title: TextStyle(color: Colors.white),
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Configuration.colorDefault),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Configuration.colorDefault),
    primaryIconTheme: IconThemeData(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white // icones do body
        ),
    accentIconTheme: IconThemeData(color: Colors.white // icones flutuantes
        ),
    buttonTheme: ButtonThemeData(
      buttonColor: Configuration.colorDefault,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
//    textTheme: ButtonTextTheme.accent
    ),
    textTheme: TextTheme(
      button: TextStyle(color: Colors.white),
//      title: TextStyle(color: Colors.white), // titulos de Texts,
//      body1: TextStyle(color: Colors.white)
    ),

//accentColorBrightness: Brightness.dark,
    accentTextTheme: TextTheme(
//    title: TextStyle(color: Colors.white),
      button: TextStyle(color: Colors.white),
//    subtitle: TextStyle(color: Colors.white),
//    body1: TextStyle(color: Colors.white),
//    body2: TextStyle(color: Colors.white),
//    caption: TextStyle(color: Colors.white),
//    display1: TextStyle(color: Colors.white),
//    display2: TextStyle(color: Colors.white),
//    display3: TextStyle(color: Colors.white),
//    display4: TextStyle(color: Colors.white),
//    headline: TextStyle(color: Colors.white),
//    overline: TextStyle(color: Colors.white),
//    subhead: TextStyle(color: Colors.white),
    ),
    cardTheme: CardTheme(color: Colors.white, elevation: 1.0));

final ThemeData kIOSTheme = ThemeData();

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _path;


  initDynamicLinks() async {
    print('initDynamicLinks');
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri deeplink = data?.link;
    
    if (deeplink != null) {
      setState(() {
        _path = deeplink.path;
      });
    }
  }

  Cliente c = Session.getCliente();
  Future<Endereco> _futureEndereco;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//  String token = "";

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print("foi 3 - onLaunch");
        print(message['notification']);
        print("onLaunch: $message");
      },
      onMessage: (Map<String, dynamic> message) async {
        print("foi 2 - onMessage");
        print(message['notification']['body']);
        print("onMenssage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("foi 1 - onResume");
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((token) {
      setState(() {
        Session.setToken(token);
      });
      print("Token: ${Session.getToken()}");
    });

    _futureEndereco = initFutureEnderecoCliente();
  }

  Future<Endereco> initFutureEnderecoCliente() {
    return Session.getEnderecoCienteInFuture();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _autenticarCliente(context),
//      home: LoginEmailPage(),
      title: 'FastDelivery',
      theme: kDefaultTheme,
//      theme: Theme.of(context).platform == TargetPlatform.android
//          ? kDefaultTheme
//          : kIOSTheme,
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _autenticarCliente(BuildContext context) {
    if (Session.getCliente() != null || c != null) {
      print(
          'Main._autenticarCliente =============================================================\n');
      print('Session.getCliente().id: ${Session.getCliente().id}');
      print('Session.getCliente().nome: ${Session.getCliente().nome}');
      print('Session.getCliente().cpf: ${Session.getCliente().cpf}');
      print('Session.getCliente().telefone: ${Session.getCliente().telefone}');
      print('Session.getCliente().saldo: ${Session.getCliente().saldo}');
      print(
          'Session.getCliente().codigoIndicacao: ${Session.getCliente().codigoIndicacao}');
      print('Session.getCliente().login: ${Session.getCliente().login}');
      print('Session.getCliente().senha: ${Session.getCliente().senha}');
      print(
          "\n====================================================================================\n\n\n");

      if (Session.getCliente().id == 1070) {
        Session.clearCliente();
        Session.clearEnderecoCliente();
        return LoginPage();
      } else {
        String token = Session.getToken();

        if (Session.getCliente().token != token) {
          print('Tokens diferentes. Session.getCliente().token != token:');
          print('cliente.token: ${Session.getCliente().token}');
          print('Session.getToken(): $token');
          ClienteDao.internal()
              .updateToken(Session.getCliente().id, token)
              .then((client) {
            print("client: ${client}");
            if (client != null) {
              client.id = Session.getCliente().id;
              Session.setCliente(client);
              print(
                  'LoginPage._verificarCadastro - Session.getCliente(): ${Session.getCliente().id} - ${Session.getCliente().nome}');
            }
          }).catchError((error) {
//            Session.setCliente(cliente);
          });
//          Cliente cliente = Session.getCliente();
//          cliente.token = token;
//          print("Cliente id: ${cliente.id}");
//          JsonUtils.atualizarCliente(cliente: cliente).then((cliente){
//            print("Atualizou o token: ${cliente.token}");
//            Session.setCliente(cliente);
//          });
        } else {
          print('Tokens iguais. Session.getCliente().token == token \n\n');
        }

        if ((Session.getCliente().login == null ||
                Session.getCliente().login.isEmpty) ||
            (Session.getCliente().senha == null ||
                Session.getCliente().senha.isEmpty)) {
          return UpdateClientePage(Session.getCliente());
        } else {
          return FutureBuilder(
              future: _futureEndereco,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Scaffold(
                      body: Center(
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).accentColor),
                            strokeWidth: 5.0,
                          ),
                        ),
                      ),
                    );

                  default:
//                print(snapshot.data);
                    if (snapshot.hasData) {
//                  print(snapshot.data);
                      if (snapshot.data != null) {
                        return HomePage.path(_path);
                      } else {
                        return EnderecoLoginPage();
                      }
                    } else {
                      return EnderecoLoginPage();
                    }
                }
              });
        }
      }
    } else {
      return LoginPage();
    }
  }

  void _verificarCadastro(Cliente cliente, BuildContext context) {
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
  }
}

class UpdateClientePage extends StatefulWidget {
  final Cliente cliente;

  UpdateClientePage(this.cliente);

  @override
  _UpdateClientePageState createState() => _UpdateClientePageState();
}

class _UpdateClientePageState extends State<UpdateClientePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Atualização de Cadastro',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 30.0),
                Text(
                  'Para prosseguir, é necessário atualizar algumas informações sobre seu cadastro nos nossos servidores',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15.0),
                FlatButton(
                  child: Text('Prosseguir'),
                  textColor: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return CadastrarClientePage(Session.getToken(),
                            numero: widget.cliente.telefone,
                            cliente: widget.cliente);
                      }),
                      (routes) => false,
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
