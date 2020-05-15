import 'package:appfastdelivery/dao/avalicao_dao.dart';
import 'package:appfastdelivery/helper/avaliacao.dart';
import 'package:appfastdelivery/ui/pedidos_page.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class AvaliacaoPage extends StatefulWidget {

  List<Avaliacao> lista;
  final int idPedido;


  AvaliacaoPage.instance(this.lista, this.idPedido);

  @override
  _AvaliacaoPageState createState() => _AvaliacaoPageState(lista, idPedido);
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {

   List<Avaliacao> avaliacoes;
   final int idPedido;
   Comentario comentario;

   _AvaliacaoPageState(this.avaliacoes, this.idPedido);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Avaliação',
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text('Deixe sua avaliação',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: avaliacoes.length,
                  itemBuilder: (context, index){
//                    if(index == avaliacoes.length){
//                      return
//                        SizedBox(
//                        height: 44.0,
//                        width: 50.0,
//                        child: RaisedButton(
//                            child: Text('Enviar', style: TextStyle(fontSize: 18.0),),
//                            textColor: Colors.white,
//                            color: Theme.of(context).accentColor,
//                            onPressed: (){
//
//                              for(Avaliacao avaliacao in avaliacoes){
//                                for(Comentario comentario in avaliacao.comentarios){
//                                  if(comentario.marcado == true){
////                                    print('${comentario.id} - avaliação: ${avaliacao.descricao}');
////                                    print('${comentario.id} - comentario: ${comentario.descricao}');
//
//                                    AvaliacaoDao.internal().sendResult(idPedido, avaliacao.id, comentario.id).then((retorno){
//                                      List<Widget> actions;
//                                      if(retorno){
//                                        actions = List();
//                                        actions.add(FlatButton(
//                                          child: Text('OK'),
//                                          onPressed: (){
//                                            Navigator.of(context).pop();
//                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
//                                              return HomePage();
//                                            }),
//                                              ModalRoute.withName(HomePage.routeName),
//                                            );
//                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                                              return PedidosPage();
//                                            }));
//                                          },
//                                        ));
//                                        MessageUtil.alertMessageScreen(context,
//                                            "Recebimento confirmado ☺",
//                                            "Agradeçemos a preferência!",
//                                            actions);
//
//                                      }else{
//                                        actions = List();
//                                        actions.add(FlatButton(
//                                          child: Text('Entendi'),
//                                          onPressed: (){
//                                            Navigator.of(context).pop();
//                                          },
//                                        ));
//                                        MessageUtil.alertMessageScreen(context,
//                                            "Confirmação de recebimento não finalizada!",
//                                            "Ocorreu um erro ao enviar os resultados da avaliação desse pedido.",
//                                            actions);
//
//                                      }
//                                    });
//                                  }
//                                }
//                              }
//                            }
//                        ),
//                      );
//                    }else{
                      if(avaliacoes[index].tipo == 'OUTROS'){
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text(avaliacoes[index].descricao,
                                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                              _buildCommentOutros(context, avaliacoes[index].comentarios),
                              SizedBox(height: 16.0,),

                            ],
                          ),
                        );
                      }else{
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text(avaliacoes[index].descricao,
                                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                              _buildComment(context, avaliacoes[index].comentarios),
                              SizedBox(height: 16.0,),

                            ],
                          ),
                        );
                      }
//                    }
                  }
              ),
          ),
          SizedBox(
            height: 44.0,
            child: RaisedButton(
                    child: Text('Enviar', style: TextStyle(fontSize: 18.0),),
                    textColor: Colors.white,
                    color: Theme.of(context).accentColor,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.zero
                    ),
                    onPressed: (){

                      for(Avaliacao avaliacao in avaliacoes){
                        for(Comentario comentario in avaliacao.comentarios){
                          if(comentario.marcado == true){
                                    print('${comentario.id} - avaliação: ${avaliacao.descricao}');
                                    print('${comentario.id} - comentario: ${comentario.descricao} marcado: ${comentario.marcado}');

                            AvaliacaoDao.internal().sendResult(idPedido, avaliacao.id, comentario.id).then((retorno){
                              List<Widget> actions;
                              if(retorno){
                                actions = List();
                                actions.add(FlatButton(
                                  child: Text('OK'),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                                      return HomePage();
                                    }),
                                      ModalRoute.withName(HomePage.routeName),
                                    );
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                      return PedidosPage();
                                    }));
                                  },
                                ));
                                MessageUtil.alertMessageScreen(context,
                                    "Recebimento confirmado ☺",
                                    "Agradeçemos a preferência!",
                                    actions);

                              }else{
                                actions = List();
                                actions.add(FlatButton(
                                  child: Text('Entendi'),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ));
                                MessageUtil.alertMessageScreen(context,
                                    "Confirmação de recebimento não finalizada!",
                                    "Ocorreu um erro ao enviar os resultados da avaliação desse pedido.",
                                    actions);

                              }
                            });
                          }
                        }
                      }
                    }
                ),
          ),
        ],
      )
    );
  }
   Widget _buildCommentOutros(BuildContext context, List<Comentario> comentarios) {

     List<Widget> comments = [
     ];

     for(int index = 0; index < comentarios.length; index++){
       comments.add(
           CheckboxListTile(
               title: Text(
                 comentarios[index].descricao,
                 style: TextStyle(
                     fontSize: 12.0,
                     fontWeight: FontWeight.bold),
               ),
               controlAffinity: ListTileControlAffinity.leading,
               selected: comentarios[index] == comentario,
               value: comentarios[index].marcado,
               onChanged: (value){
//                 print(value);
                 setState(() {
                   if(comentario == null){
                     comentarios[index].marcado = value;
                     comentario = comentarios[index];
                   }

                   if(comentario != comentarios[index]){
                     comentario.marcado = false;
                     comentarios[index].marcado = value;
                     comentario =  comentarios[index];
                   }else{
                     print('não deu');
                     comentarios[index].marcado = value;
                     comentario = comentarios[index];
                   }

                 });
               }
           )
       );
     }

     return Padding(
       padding: EdgeInsets.symmetric(vertical: 10.0),
       child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: comments
       ),
     );
   }

  Widget _buildComment(BuildContext context, List<Comentario> comentarios) {

    List<Widget> comments = [
    ];

    for(int index = 0; index < comentarios.length; index++){
    comments.add(
        InkWell(
          onTap: (){

            setState(() {
              for(int indice = 0; indice < comentarios.length; indice++){
                if(indice < index){
                  comentarios[indice].ativo = true;
                  comentarios[indice].marcado = false;
                }else if(indice > index){
                  comentarios[indice].ativo = false;
                  comentarios[indice].marcado = false;
                }else{
                  comentarios[indice].ativo = true;
                  comentarios[indice].marcado = true;
                }
//                print('$indice - ${comentarios[indice].ativo} marcado: ${comentarios[indice].marcado} \n');
              }
            });
          },
          child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[

                comentarios[index].ativo == true
                      ?
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).accentColor,
                  )
                      :
                  Icon(
                    Icons.favorite_border,
                    color: Colors.grey[800],
                  ),
                  SizedBox(height: 15.0,),
                  Text(
                    comentarios[index].descricao,
                    style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(0.5),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),

                ],
              )),
        )
    );

    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: comments
      ),
    );
  }
}





