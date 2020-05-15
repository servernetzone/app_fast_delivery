
import 'package:flutter/material.dart';
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:appfastdelivery/util/configuration.dart';



class QuestionCidadePage extends StatefulWidget {
  final EnderecoPedido endereco;

  QuestionCidadePage(this.endereco);

  @override
  _QuestionCidadePageState createState() => _QuestionCidadePageState();
}

class _QuestionCidadePageState extends State<QuestionCidadePage> {
  EnderecoPedido _endereco;


  @override
  void initState() {
    super.initState();
    _endereco = widget.endereco;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FastDelivery',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).accentColor,
      ),

      body: Center(
        child:
        Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[

              SizedBox(height: 30.0,),

              Icon(Icons.location_city,
                color: Configuration.colorAccent1,
                size: 80.0,
              ),

              SizedBox(height: 30.0,),
              Text('Ainda não estamos atendendo em ${_endereco.cidade} '
                  '${_endereco.uf != ''
                  ? ' - ${_endereco.uf}'
                  : '' }',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0,),

              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[


                      Padding(
                        padding: EdgeInsets.only(bottom: 6.0),
                        child:  RaisedButton(
//                              color: Color.fromRGBO(36, 36, 143, 1.0),
                            child: Text("Voltar",
                                style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0)),
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(5.0),
//                              ),
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }
                        ),
                      ),




                    ],
                  )),







            ],
          ),
        )
      ),



    );
  }
}
