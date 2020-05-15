//import 'package:flutter/material.dart';
//import 'package:appfastdelivery/dao/produto_dao.dart';
//import 'package:appfastdelivery/dao/variacao_dao.dart';
//import 'package:appfastdelivery/helper/adicional.dart';
//import 'package:appfastdelivery/helper/produto.dart';
//import 'package:appfastdelivery/helper/variacao.dart';
//import 'package:appfastdelivery/ui/variacoes_show_page.dart';
//
//class Teste extends StatefulWidget {
//  @override
//  _TesteState createState() => _TesteState();
//}
//
//
//class _TesteState extends State<Teste> {
//  VariacaoDao _variacaoDao = VariacaoDao();
//
//  List<Variacao> variacoesEscolhidas;
//  List<Adicional> adicionais;
//  List<int> listaValores = List();
//
//  Variacao variacao = null;
//  Produto _produto;
//  bool valor;
//  int _values = 0;
//  String _descricao = "";
//
//  int count;
//
//
//  @override
//  void initState() {
//    variacoesEscolhidas = List();
//
////    _variacaoDao.list(1).then((lista) {
////      variacoes = lista;
////
////    });
//    super.initState();
//  }
//
//
//  String _verificarMultiplos(AsyncSnapshot snapshot, int index){
//    if(snapshot.data[index].isMultiple) {
//      return "Minimo: ${snapshot.data[index].minimo} Máximo: ${snapshot.data[index].maximo}";
//    }else{
//      return "Escolha uma opção";
//    }
//  }
//
////  void setSelectedAdicional(Adicional adicional){
////    setState(() {
////      selectedAdicional = adicional;
////
////    });
////  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: CustomScrollView(
//        slivers: <Widget>[
//
//          FutureBuilder(
////            future: ,
//              builder: (BuildContext context, AsyncSnapshot snapshot){
//                switch (snapshot.connectionState) {
//                  case ConnectionState.waiting:
//                  case ConnectionState.none:
//                    return Center(
//                      child: Container(
//                        width: 200.0,
//                        height: 200.0,
//                        alignment: Alignment.center,
//                        child:
//                        CircularProgressIndicator(
//                          valueColor:
//                          AlwaysStoppedAnimation<
//                              Color>(
//                              Colors.indigo),
//                          strokeWidth: 5.0,
//                        ),
//                      ),
//                    );
//
//                  default:
//                    if (snapshot.hasError) {
//                      return Container(
//                        child: Center(
//                          child: Text(
//                              "A conexão falhou!"),
//                        ),
//                      );
//                    } else {
//
//                    }
//                }
//              }
//          ),
//
//
//
//
//
//
//
//
//          SliverAppBar(
//            backgroundColor: Colors.indigo,
//            centerTitle: true,
//            title: Text(''),
//
////              leading: IconButton(
////                icon: Icon(Icons.filter_1),
////              )
//          ),
//          SliverToBoxAdapter(
//              child:
//              Container(
//                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
//                color: Colors.white,
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Align(
//                      alignment: Alignment.topCenter,
//                      child: Container(
//                        width: 300.0,
//                        height: 200.0,
//                        margin: EdgeInsets.only(bottom: 10.0),
//                        decoration: BoxDecoration(
//                            image: DecorationImage(
//                                image: NetworkImage(
//                                    "http://157.230.213.184/media/produtos/produto1.jpg"),
//                                fit: BoxFit.cover)),
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
//                      child: Text(
//                        "Barato do dia (Só a vista, no Dinheiro)",
//                        style: TextStyle(fontSize: 22.0, color: Colors.black),
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//                      child: Text("R\$ 8,99",
//                          style: TextStyle(
//                              fontSize: 20.0, fontWeight: FontWeight.bold)),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
//                      child: Text(
//                          "sssssssssssssssssssssssssssssssssssssssssssssssssssssssssss"
//                              "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
//                              "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS",
//                          style: TextStyle(fontSize: 14.0)),
//                    ),
//                  ],
//                ),
//              )),
////
////        Container(height: 200.0, color: Colors.black,),
////            SliverGrid(
////              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
////                maxCrossAxisExtent: 200.0,
////                mainAxisSpacing: 10.0,
////                crossAxisSpacing: 10.0,
////                childAspectRatio: 4.0,
////              ),
////              delegate: SliverChildBuilderDelegate(
////                    (BuildContext context, int index) {
////                  return Container(
////                    alignment: Alignment.center,
////                    color: Colors.teal[100 * (index % 9)],
////                    child: Text('grid item $index'),
////                  );
////                },
////                childCount: 20,
////              ),
////            )
//
//          FutureBuilder(
//              future: _variacaoDao.list(1),
//              builder: (context, snapshot) {
//                switch (snapshot.connectionState) {
//                  case ConnectionState.waiting:
//                  case ConnectionState.none:
//                    return SliverToBoxAdapter(
//                      child: Container(
//                        width: 200.0,
//                        height: 200.0,
//                        alignment: Alignment.center,
//                        child: CircularProgressIndicator(
//                          valueColor:
//                          AlwaysStoppedAnimation<Color>(Colors.indigo),
//                          strokeWidth: 5.0,
//                        ),
//                      ),
//                    );
//                  default:
//                    if (snapshot.hasError) {
//                      return Container(
//                        child: Center(
//                          child: Text("A Conexão Falhou!",
//                              style: TextStyle(
//                                  fontSize: 20.0, color: Colors.grey)),
//                        ),
//                      );
//                    } else {
//                      return
//                        SliverList(
//                          delegate: SliverChildBuilderDelegate(
//                                (BuildContext context, int index) {
//                              listaValores.add(-1);
//                              return Container(
//                                color: Colors.white,
//                                alignment: Alignment.topLeft,
//                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Text(
//                                      "${snapshot.data[index].descricao}"
//                                          .toUpperCase(),
//                                      style: TextStyle(
//                                        color: Colors.indigo,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 15.0,
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: EdgeInsets.only(left: 5.0),
//                                      child: Text(
//                                        _verificarMultiplos(snapshot, index),
//                                        style: TextStyle(
//                                            color: Colors.grey, fontSize: 13.0),
//                                      ),
//                                    ),
//                                    Container(
//                                      color: Colors.white,
////                                      height: 50.0,
//                                      child:
////                                    Column(
////                                      children:
////                                        _makeRadios(context, snapshot, index),
//                                      _screenListAdicionais(context, snapshot, index),
//
////                                    )
////
//                                    )
//                                  ],
//                                ),
//                              );
//                            },
//                            childCount: snapshot.data.length,
//                          ),
//                        );
//                    }
//                }
//              }),
//
////         SliverToBoxAdapter(
////           child:
////         )
//        ],
//      ),
//    );
//  }
//
//  Widget _screenListAdicionais(
//      BuildContext context, AsyncSnapshot snapshot, int index) {
//    if (snapshot.data[index].isMultiple == false) {
//      return ListView.builder(
//          shrinkWrap: true,
//          physics: ClampingScrollPhysics(),
//          itemCount: snapshot.data[index].adicionais.length,
//          itemBuilder: (context, indice) {
//            return Container(
//              child:
////            Row(
////              children: <Widget>[
//              RadioListTile(
//                title: Text(snapshot.data[index].adicionais[indice].descricao),
//                activeColor: Colors.indigo,
//                value: snapshot.data[index].adicionais[indice].id,
//                groupValue: listaValores[index],
//                onChanged: (value) {
//                  setState(() {
////                    snapshot.data[index].adicionais[indice].selected = 1;
//                    listaValores[index] = value;
//                    print(value);
//                    print("${listaValores[index]}");
//                  });
//                },
//                secondary: Text("R\$ ${snapshot.data[index].adicionais[indice].valor}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14.0),),
//              ),
////              ],
////            )
//            );
//          });
//    } else {
//      _descricao = "";
//      _descricao = _concatenarAdicionais(snapshot.data[index], false);
//
//      return ListTile(
//        title: Text(_descricao,
//          maxLines: 3,
//        ),
//        leading: Container(
//          child: Column(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              Icon(Icons.navigate_next),
//              Text("selecionar", style: TextStyle(fontSize: 10.0, color: Colors.indigo))
//
//            ],
//          ),
//        ),
//
//        onTap: () async{
//
//          if(variacoesEscolhidas.isNotEmpty){
//            Variacao variacaoAuxiliar  = _verificarVariacao(snapshot.data[index].id);
//            if(variacaoAuxiliar != null){
//              variacao = variacaoAuxiliar;
//            }else{
//              variacao = snapshot.data[index];
//            }
//          }else{
//            variacao = snapshot.data[index];
//          }
//          dynamic variacaoNew = await Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return VariacoesShowPage(variacao , "prato fitness");
//          }));
////          print(variacaoNew);
////          print(variacaoNew is int);
////          print(variacaoNew is Variacao);
//
//          if(variacaoNew is Variacao){
//            for(Variacao variacaoAux in variacoesEscolhidas){
//              if(variacaoNew.id == variacaoAux.id){
//                variacoesEscolhidas.remove(variacaoAux);
//                print("removeu e");
//                break;
//              }
//            }
//            variacoesEscolhidas.add(variacaoNew);
////            variacao = variacaoNew;
//            setState(() {
//              _descricao = _concatenarAdicionais(variacaoNew, true);
//            });
//
//            print("adicionou");
////            for(Variacao v in variacoesEscolhidas){
////              print("\n\n Variação: ${v.descricao}");
////              for(Adicional a in v.adicionais){
////                print("adicional: "+a.descricao+" - ${a.selected}");
////              }
////            }
//
//          }else if(variacaoNew is int){
//            if(variacoesEscolhidas.isNotEmpty){
//              for(Variacao variacaoAux in variacoesEscolhidas){
//                if(variacaoNew == variacaoAux.id){
//                  variacoesEscolhidas.remove(variacaoAux);
//                  print("removeu e");
//                  break;
//                }
//              }
//            }
//          }
//
//          for(Variacao v in variacoesEscolhidas){
//            print("\n\n Variação: ${v.descricao}");
//            for(Adicional a in v.adicionais){
//              print("adicional: "+a.descricao+" - ${a.selected}");
//            }
//          }
//
//
//
//
//        },
//
//      );
//    }
//  }
//
////  Widget _screenListAdicionais(
////      BuildContext context, AsyncSnapshot snapshot, int index) {
////    if (snapshot.data[index].isMultiple == false) {
////      variacoes = snapshot.data[index].adicionais;
////      return ListView.builder(
////          shrinkWrap: true,
////          physics: ClampingScrollPhysics(),
////          itemCount: snapshot.data[index].adicionais.length,
////          itemBuilder: (context, indice) {
////            return Container(
////              child:
//////            Row(
//////              children: <Widget>[
////              RadioListTile(
////                value: adicional,
////
////
////              ),
//////              ],
//////            )
////            );
////          });
////    } else {
////      return ListTile(
////        title: Text("Bacon, Barbecue"),
////
////        onTap: (){
////
////        },
////
////      );
////    }
////  }
//
//
////
//
////
////Variacao _checkInListVariation(Variacao variacao, List<Variacao> variacoes){
////  for(Variacao variacaoAux in variacoesEscolhidas){
////    if(variacao.id == variacaoAux.id){
////     return variacaoAux;
////
////    }
////  }
////  return null;
////}
//
//
//
//  String _concatenarAdicionais(Variacao variacao, bool isModified){
//    if(variacao != null){
//      for(Adicional adicionalAuxiliar in variacao.adicionais){
//        if(isModified){
//          _descricao = "$_descricao ${adicionalAuxiliar.descricao} \n\n";
//        }else{
//          _descricao =  "$_descricao ${adicionalAuxiliar.descricao}, ";
//        }
//      }
//      return _descricao;
//    }else{
//      return null;
//    }
//  }
//
//  Variacao _verificarVariacao(int id){
//    for(Variacao variacaoOld in variacoesEscolhidas){
//      if(variacaoOld.id == id){
//        return variacaoOld;
//      }
//    }
//    return null;
//  }
//
//
//
//}
//
//
//
//
//
////  Widget _screenListAdicionais(
////      BuildContext context, AsyncSnapshot snapshot, int index) {
////    if (snapshot.data[index].isMultiple == false) {
////      variacoes = snapshot.data[index].adicionais;
////      return ListView.builder(
////          shrinkWrap: true,
////          physics: ClampingScrollPhysics(),
////          itemCount: snapshot.data[index].adicionais.length,
////          itemBuilder: (context, indice) {
////            return Container(
////              child:
//////            Row(
//////              children: <Widget>[
////              RadioListTile(
////                value: adicional,
////
////
////              ),
//////              ],
//////            )
////            );
////          });
////    } else {
////      return ListTile(
////        title: Text("Bacon, Barbecue"),
////
////        onTap: (){
////
////        },
////
////      );
////    }
////  }
//
////
//
////
////Variacao _checkInListVariation(Variacao variacao, List<Variacao> variacoes){
////  for(Variacao variacaoAux in variacoesEscolhidas){
////    if(variacao.id == variacaoAux.id){
////     return variacaoAux;
////
////    }
////  }
////  return null;
////}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////MAIN
//
//
//
//
//
//
//
//
//
//
//
////
////  var data = await http.get(('http://157.230.213.184/mobile/parceiros/1/'), headers: {'Accept': 'application/json'});
////  var jsonDataList = json.decode(utf8.decode(data.bodyBytes))[0]["categorias"];
////  List<Categoria> categorias = List();
////
////  for (var jsonData in jsonDataList) {
////    Categoria categoria = Categoria(jsonData['pk'], jsonData['descricao'], jsonData['imagem'], jsonData['status']);
////    print(categoria.descricao);
////    categorias.add(categoria);
////  }
////
////  for (Categoria c in categorias) {
////    print(c.id);
////    print(c.descricao);
////  }
//
//
//
//
////  var data = await http.get(('http://192.168.1.13:8000/mobile/categorias/3/subcategorias/'), headers: {'Accept': 'application/json'});
////  var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
////  List<SubCategoria> subCategorias = List();
////
//////  print(jsonDataList);
////  for (var jsonData in jsonDataList) {
//////    SubCategoria subCategoria = SubCategoria(jsonData['pk'], jsonData['descricao'], jsonData['imagem'], jsonData['status']);
////    print(jsonData);
//////    subCategorias.add(subCategoria);
////  }
//
////  for (SubCategoria c in subCategorias) {
////    print("subcategoria: "+c.descricao);
////  }
//
//
//
////    var data = await http.get(('http://192.168.1.13:8000/mobile/categoria/1/produtos/'), headers: {'Accept': 'application/json'});
////    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
////    List<Produto> produtos = List();
////
//////    print(jsonDataList);
////
////    for (var jsonData in jsonDataList) {
//////      print(jsonData);
////      Produto produto = Produto(jsonData['pk'], jsonData['descricao'], jsonData['imagem'], jsonData['valorProduto'],
////          jsonData['situacao'], jsonData['observacao']);
////
//////        print(categoria.descricao);
////      produtos.add(produto);
////    }
////
////    for(Produto p in produtos ){
////      print(p.descricao);
////    }
//
////  var data = await http.get((Factory.internal().getUrl()+'produtos/1/variacoes/'), headers: {'Accept': 'application/json'});
////  var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
////  List<Variacao> variacoes = List();
////
//////    print(jsonDataList);
////  for (var jsonData in jsonDataList) {
////    List<Adicional> adicionais = [];
////
////    for(var jsonDataAdicionais in jsonData['adicionais']){
//////      print(jsonDataAdicionais['descricao']);
////      Adicional adicional = Adicional(
////          jsonDataAdicionais['id'],
////          jsonDataAdicionais['descricao'],
////          jsonDataAdicionais['status'],
////          jsonDataAdicionais['valor']
////      );
////      adicionais.add(adicional);
////    }
//////    print("printouuuuu: "+jsonData['adicionais']);
////
////    Variacao variacao = Variacao(jsonData['pk'], jsonData['descricao'], jsonData['min'], jsonData['max'], jsonData['ativo'], adicionais);
////    variacoes.add(variacao);
////  }
////
////  for (Variacao c in variacoes) {
////    print(c.descricao);
////    for(var a in c.adicionais){
////      print(a.descricao);
////
////    }
////  }
////
////  VariacaoDao _variacaoDao = VariacaoDao();
////  _variacaoDao.list(1).then((lista){
////    for (Variacao c in lista) {
////      print(c.descricao);
////      for(var a in c.adicionais){
////        print(a.descricao);
////
////      }
////    }
////  });
//















































//
//
//
//Container(
////                   color: Colors.green,
//height: 30.0,
//margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
//padding: EdgeInsets.all(0.0),
//child:  Row(
//mainAxisAlignment: MainAxisAlignment.start,
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget>[
//Icon(Icons.location_on,
//size: 20.0,
//color: Theme.of(context).accentColor,
//),
//
//Container(
////                           color: Colors.purple,
//width: 280.0,
//padding: EdgeInsets.all(0.0),
//margin: EdgeInsets.all(0.0),
//child: Text('Enviar para ${Session.getEnderecoCiente().rua}, ${Session.getEnderecoCiente().numero} - '
//' ${Session.getEnderecoCiente().bairro} - ${Session.getEnderecoCiente().cidade}',
//maxLines: 1,
//softWrap: false,
//overflow: TextOverflow.ellipsis,
//style: TextStyle(
//color: Theme.of(context).accentColor,
//fontWeight: FontWeight.bold,
//fontSize: 13.0),
//textAlign: TextAlign.start,
//),
//),
//
//Icon(Icons.keyboard_arrow_down,
//size: 20.0,
//color: Theme.of(context).accentColor,
//),
//],
//),



//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: <Widget>[
//                                         Icon(Icons.location_on,
//                                           size: 20.0,
//                                           color: Theme.of(context).accentColor,
//                                         ),
//
//                                         Container(
////                           color: Colors.purple,
//                                           width: 280.0,
//                                           padding: EdgeInsets.all(0.0),
//                                           margin: EdgeInsets.all(0.0),
//                                           child: Text('Enviar para ${Session.getEnderecoCiente().rua}, ${Session.getEnderecoCiente().numero} - '
//                                               ' ${Session.getEnderecoCiente().bairro} - ${Session.getEnderecoCiente().cidade}',
//                                             maxLines: 1,
//                                             softWrap: false,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                                 color: Theme.of(context).accentColor,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 13.0),
//                                             textAlign: TextAlign.start,
//                                           ),
//                                         ),
//
//                                         Icon(Icons.keyboard_arrow_down,
//                                           size: 20.0,
//                                           color: Theme.of(context).accentColor,
//                                         ),
//                                       ],
//                                     ),
//);

