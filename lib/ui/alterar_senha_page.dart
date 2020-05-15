import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:flutter/material.dart';

class AlterarSenhaPage extends StatefulWidget {
  @override
  _AlterarSenhaPageState createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {

  TextEditingController _senhaAntigaController = TextEditingController(text: '');
  TextEditingController _senhaNovaController = TextEditingController(text: '');
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Alterar Senha",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                controller: _senhaAntigaController,
                decoration: InputDecoration(
                  labelText: "Senha Atual",
                  alignLabelWithHint: true,
                  hintText: "Letras, números e caracteres",
                  labelStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0))
                ),
                style: TextStyle(fontSize: 14.0),
                obscureText: true,
                validator: (value){
                  String text = null;
                  if(value.isEmpty){
                    text = "Informe a senha atual!";
                  }
                  if(value.length < 8){
                    text = "A senha deve conter, no mínimo, 8 caracteres";
                  }
                  return text;
                },

              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: _senhaNovaController,
                decoration: InputDecoration(
                  labelText: "Nova Senha",
                  alignLabelWithHint: true,
                  hintText: "Letras, números e caracteres",
                  labelStyle: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0))
                ),
                style: TextStyle(fontSize: 14.0),
                obscureText: true,
                validator: (value){
                  String text = null;
                  if(value.isEmpty){
                    text = "Informe a nova senha!";
                  }
                  if(value.length < 8){
                    text = "A senha deve conter, no mínimo, 8 caracteres";
                  }
                  return text;
                },

              ),
              SizedBox(height: 20.0,),
              SizedBox(
                height: 45.0,
                child: RaisedButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      ClienteDao.internal().alterarSenha(
                          id: Session.getCliente().id,
                          senhaAntiga: _senhaAntigaController.text,
                          novaSenha: _senhaNovaController.text
                      ).then((response){
                        if(response['status'] == 'success'){
                          MessageUtil.alertMessageScreen(context,
                              '',
                              (response['resposta'] as String),
                              [
                                FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]
                          );
                        }else{
                          MessageUtil.alertMessageScreen(context,
                              'ERRO',
                              (response['resposta'] as String),
                              [
                                FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
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
                                  Navigator.of(context).pop();
                                },
                              )
                            ]
                        );

                      });
                    }
                  },
                  color: Theme.of(context).accentColor,
                  textColor: Configuration.colorWrite,
                  child: Text('Alterar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
