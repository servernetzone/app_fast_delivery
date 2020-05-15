import 'package:appfastdelivery/ui/endereco_confirm_page.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/ui/home_page.dart';
import 'package:appfastdelivery/ui/login_page.dart';
import 'package:appfastdelivery/util/json_utils.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'helper/cliente.dart';
import 'helper/pedido.dart';
import 'helper/parceiro.dart';
import 'ui/endereco_login_page.dart';

class Home12 extends StatefulWidget {
  @override
  _Home12State createState() => _Home12State();
}




class _Home12State extends State<Home12> {
  Cliente c =  Session.getCliente();
  Future<Endereco> _futureEndereco;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String token = "";


  @override
  void initState() {
    super.initState();


    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print("foi 3");
        print(message['notification']);
        print("onLaunch: $message");

      },
      onMessage: (Map<String, dynamic> message) async {
        print("foi 2 teste");
        print(message['notification']['body']);
        print("onMenssage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("foi 1");
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging .getToken (). then ((token2) {
      setState(() {
        token = token2;
        Session.setToken(token);
      });

      print(token);
//        Session.setCliente(Cliente(0 ,'teste', '02938475690', '20948576', token));
    });


    _futureEndereco = initFutureEnderecoCliente();
  }

  Future<Endereco> initFutureEnderecoCliente(){
    return Session.getEnderecoCienteInFuture();
  }


  @override
  Widget build(BuildContext context) {
    return _autenticarCliente(context);
  }


  Widget _autenticarCliente(BuildContext context){
//    if(Session.getCliente() != null || c != null){ antigo
    if(Session.getCliente() != null || c != null){
      if(Session.getCliente().token != token){
        Session.getCliente().token = token;
        print("é aki: ${Session.getCliente().id}");
        JsonUtils.atualizarCliente(cliente: Session.getCliente()).then((cliente){
          Session.setCliente(cliente);
        });
      }
      print('Session.getCliente().login: ${Session.getCliente().login}');
      print('Session.getCliente().senha: ${Session.getCliente().senha}');

//      if(){
//
//      }else{
        return FutureBuilder(
            future: _futureEndereco,
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
                        valueColor:
                        AlwaysStoppedAnimation<
                            Color>(Theme.of(context).accentColor),
                        strokeWidth: 5.0,
                      ),
                    ),
                  );

                default:
                  print(snapshot.data);
                  if (snapshot.hasData){
//                  print(snapshot.data);
                    if(snapshot.data != null){
                      print('endereço não é nulo - HomePage()');
                      return HomePage();
                    }else{
                      print('endereço é nulo -  EnderecoLoginPage()');
                      return EnderecoLoginPage();
                    }

                  }else{
                    print('entrou aki -  EnderecoLoginPage()');
                    return EnderecoLoginPage();
                  }
              }
            }
        );
//      }
    }else{
      return  LoginPage();
    }
  }

}
