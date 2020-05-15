import 'package:flutter/material.dart';

class NotificacaoUtils {
  static void NovaNotificacao(context, String texto, Icon icone) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
//            title: Text(texto),
            content: Container(
                width: 160,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text(texto, style: TextStyle(fontWeight: FontWeight.w500,color: Colors.deepOrangeAccent),),
                  Padding(padding:  EdgeInsets.all(20)),
                  icone
                ],
            )),
            actions: <Widget>[
              FlatButton(
                color: Colors.deepOrange,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.deepOrangeAccent,
                child: Text("Entendi"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
