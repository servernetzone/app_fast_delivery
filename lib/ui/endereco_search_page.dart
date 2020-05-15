//WALTERLY
import 'package:appfastdelivery/dao/cidade_dao.dart';
import 'package:appfastdelivery/helper/cidade.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/places_google_maps_dao.dart';
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:appfastdelivery/ui/question_cidade_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:location/location.dart';

import 'endereco_new_page.dart';

class EnderecoSearchPage extends StatefulWidget {

  bool flag = false;
  bool statusPage = false;
  EnderecoSearchPage.internal(this.flag);
  EnderecoSearchPage({this.statusPage});

  @override
  _EnderecoSearchPageState createState() => _EnderecoSearchPageState();
}

class _EnderecoSearchPageState extends State<EnderecoSearchPage> {
  List<String> enderecosFormatado = List<String>();
  EnderecoPedido endereco = EnderecoPedido();
  CidadeDao cidadeDao = CidadeDao();
  List<String> idEnderecos = List<String>();
  List<String> localizacao;
  bool localizacaoAtivada = true;

  @override
  void initState() {
    super.initState();
    verificarStatusLocation();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(20.0),
          color: Theme.of(context).backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      color: Configuration.colorWrite1,
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).accentColor,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
              Text(
                'Novo endereço',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                onChanged: (value) {
                  buscarEnderecosPorNome(value).then((onValue) {
                    setState(() {
                      idEnderecos = onValue[0];
                      enderecosFormatado = onValue[1];
                    });
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cidade, Endereço ou CEP',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor)),
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor)),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: enderecosFormatado.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return _screenListTile(context, index);
                },
              )),
            ],
          )),
    );
  }

  Widget _screenListTile(BuildContext context, int index) {
    return ListTile(
      leading: Container(
        width: 40.0,
        height: 40.0,
        alignment: Alignment.center,
        child: getIcon(index),
      ),
      title: getTitle(index),
      subtitle: getSubtitle(index),
      onTap: () async {
        Cidade cidade = null;
        if (index != 0) {
          buscarEnderecoPorID(idEnderecos[index - 1]).then((endereco) {
            print("entrou aki");
            print(endereco.cidade);

            cidadeDao.get(endereco.cidade).whenComplete((){
              print('iniciou');
            }).then((city){
              print('colocou cidade');
              cidade = city;

//
            }).whenComplete((){
              print('terminou');
              if(cidade != null){
//                if(endereco.cidade.toUpperCase() == cidade.descricao){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return EnderecoNewPage(endereco, cidade: cidade, statusPage: widget.statusPage,);
                  }));
//                }else{
//                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                    return QuestionCidadePage(endereco);
//                  }));
//                }
              }else{
//                print("cidade é null");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return QuestionCidadePage(endereco);
                }));
              }
            });
            //Usar este endereço
          });
        } else {
          if (localizacao != null) {
            EnderecoPedido endereco = await buscarEnderecoPorID(localizacao[0]);
            print("agora entrou aki");
//            print(endereco.cidade);
            cidadeDao.get(endereco.cidade).whenComplete((){
              print('iniciou');
            }).then((city){
               cidade = city;

//
            }).whenComplete((){
              print('terminou');
              if(cidade != null){
                 if(endereco.cidade.toUpperCase() == cidade.descricao){
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                     return EnderecoNewPage(endereco, cidade: cidade, statusPage: widget.statusPage);
                   }));
                 }else{
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                     return QuestionCidadePage(endereco);
                   }));
                 }
               }else{
                 print("cidade é null");
               }
            });

//            FutureBuilder(
//              future: cidadeDao.get(endereco.cidade),
//              builder: (BuildContext context, AsyncSnapshot snapshot){
//                if(snapshot.hasError){
//                  return Container();
//                }else{
//                  cidade = snapshot.data;
//                  if(cidade != null){
//                    if(endereco.cidade.toUpperCase() == cidade.descricao){
//                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                        return EnderecoNewPage(endereco, cidade: cidade);
//                      }));
//                    }else{
//                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                        return QuestionCidadePage(endereco);
//                      }));
//                    }
//                  }else{
//                    print("cidade é null");
//                  }
//                  return Container();
//                }
//              },
//            );



          } else {
            setState(() {
              localizacaoAtivada = true;
              verificarStatusLocation();
            });
          }
        }

//           return FutureBuilder<EnderecoPedido>(
//            future: buscarEnderecoPorID(idEnderecos[index]  ),
//            // ignore: missing_return
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              switch(snapshot.connectionState){
//                case ConnectionState.none:
//                case ConnectionState.waiting:
//                  print("Entrou no switch");
//                  break;
//                default:
//                  if(snapshot.hasError){
//                    print("Erro ao carregar");
//                  }else{
//                    print(snapshot.data);
//                  }
//              }
//            },
//          );
      },

//        onTap:  (){
//          EnderecoPedido enderecoPedido;
//          buscarEnderecoPorID(idEnderecos[index]).then((endereco) {
//            enderecoPedido = endereco;
//            print(endereco);
//            //Usar este endereço
//          });
//          Navigator.of(context).push(MaterialPageRoute(builder: (context){
//            return EnderecoNewPage(enderecoPedido);
//          }));
//
//        }
    );

//              onTap: (){
//                EnderecoPedido enderecoPedido = EnderecoPedido.instance();
//                enderecoPedido.cidade = 'Patos';
//                enderecoPedido.uf = 'pb';
//                enderecoPe]
//        }));
//      },
//    );
////    }
  }

  getIcon(int index) {
    if (index == 0) {
      return Icon(
        Icons.location_searching,
        size: 25.0,
        color: Theme.of(context).accentColor,
      );
    } else {
      return Icon(
        Icons.location_on,
        size: 25.0,
        color: Theme.of(context).accentColor,
      );
    }
  }

  getTitle(int index) {
    if (index == 0) {
            return Text('Usar Minha Localização', style: TextStyle(fontSize: 13.0,color: Theme.of(context).accentColor));

    } else {
      return Text(
        enderecosFormatado[index - 1],
        style: TextStyle(fontSize: 13.0),
      );
    }
  }

  Widget getSubtitle(int index) {
    if (localizacaoAtivada && index == 0) {

      if (localizacao == null) {
        return FutureBuilder<List<String>>(
          future: buscarEnderecosPorLocalizacao(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child:Row(
                    children: <Widget>[
                      Container(
                        width: 15.0,
                        height: 15.0,
                        alignment: Alignment.center,
                        child:
                        CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<
                              Color>(
                              Colors.indigo),
                          strokeWidth: 2.0,
                        ),
                      ),
                      Text("  Carregando Localização..."),
                    ],
                  ),
                );
              default:
                if (snapshot.hasData) {
                  localizacao = snapshot.data;
                  return Text(snapshot.data[1],
                      style: TextStyle(fontSize: 13.0));
                } else
                  return Text("Localização não encontrada");
            }
          },
        );
      }else{
        return Text(localizacao[1]);
      }
    } else {
      return null;
    }
  }

  verificarStatusLocation() async {
    await Future.delayed(Duration(seconds: 5));

    var ativo = await Location().serviceEnabled();
    if (!ativo) {
      localizacaoAtivada = false;
    }
    setState(() {});
  }
}
