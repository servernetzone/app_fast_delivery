//WALTERLY
import 'package:appfastdelivery/ui/login_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/produto_dao.dart';
import 'package:appfastdelivery/dao/variacao_dao.dart';
import 'package:appfastdelivery/helper/adicional.dart';
import 'package:appfastdelivery/helper/carrinho.dart';
import 'package:appfastdelivery/helper/produto.dart';
import 'package:appfastdelivery/helper/variacao.dart';
import 'package:appfastdelivery/ui/variacoes_show_page.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'cadastrar_cliente_page.dart';

class ProdutoShowPage extends StatefulWidget {
  final Produto produto;

  ProdutoShowPage(this.produto);

  @override
  _ProdutoShowPageState createState() => _ProdutoShowPageState();
}

class _ProdutoShowPageState extends State<ProdutoShowPage> {
  VariacaoDao _variacaoDao = VariacaoDao();
  ProdutoDao produtoDao = ProdutoDao();

  List<Variacao> variacoesEscolhidas;
  List<Adicional> adicionais;
  List<int> listaValores = List();

  Variacao variacao = null;
  Produto _produto;
  ItemCarrinho _item;
  bool valor;
  int _values = 0;
  String _descricao = "";
  int _quantidade = 1;
  int _maxLines = 3;
  int count;

  TextEditingController observacaoController = TextEditingController();

  @override
  void initState() {
    variacoesEscolhidas = List();
    _produto = widget.produto;
    super.initState();
  }

  String _verificarMultiplos(AsyncSnapshot snapshot, int index) {
    if (snapshot.data[index].isMultiple) {
      return "No minimo: ${snapshot.data[index].minimo} No máximo: ${snapshot.data[index].maximo}";
    } else {
      return "Escolha uma opção";
    }
  }

  Future<List<Variacao>> _changeList(int id) async {
    _produto.variacoes = await _variacaoDao.list(id);
    return _produto.variacoes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
//            backgroundColor: Colors.indigo,
            centerTitle: true,
            title: Text(''),
          ),
          SliverToBoxAdapter(
              child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 300.0,
                    height: 200.0,
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                ImageUtil.loadWithRetry('${_produto.imagem}'),
                            fit: BoxFit.cover)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "${_produto.descricao}",
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Text(
                      _produto.promocao == true
                          ? "De: R\$ ${_produto.preco}"
                          : '',
                      style: TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                      _produto.promocao == true
                          ? "Por: R\$ ${FormatUtil.doubleToPrice(_produto.precoComDesconto)}"
                          : "R\$: ${_produto.preco}",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: _produto.promocao == true
                              ? Colors.green[800]
                              : Colors.black)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                  child: Text("${_produto.observacao}",
                      style: TextStyle(fontSize: 14.0)),
                ),
              ],
            ),
          )),
          FutureBuilder(
              future: _changeList(_produto.id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return SliverToBoxAdapter(
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
                    );
                  default:
                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Container(
                          child: Center(
                            child: Text("A Conexão Falhou! :(",
                                style: TextStyle(fontSize: 20.0)),
                          ),
                        ),
                      );
                    } else {
                      return _screenListVariacoes(context, snapshot);
                    }
                }
              }),
          SliverToBoxAdapter(
              child: Container(
            color: Colors.white,
            child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: OutlineButton(
                          child:
//                              Padding(
//                                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                                child:
                              Text("Quantidade: $_quantidade",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Configuration.colorDefault4,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0)),
//                              ),
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () {
                            _screenSelect();
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: TextField(
                        controller: observacaoController,
                        maxLines: 4,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(230, 230, 230, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(230, 230, 230, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            labelText: 'Observações:',
                            labelStyle: TextStyle(
                                color: Configuration.colorDefault4,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                            alignLabelWithHint: true,
                            hintText: 'Alguma observação...',
                            hintStyle: TextStyle(fontSize: 13.0)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: RaisedButton(
//                              color: Color.fromRGBO(36, 36, 143, 1.0),
                          child: Text(
                              Session.getCliente().id == 1070
                                  ? 'Login'
                                  : "Adicionar ao carrinho",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(5.0),
//                              ),
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          onPressed: Session.getCliente().id == 1070
                              ? () async {
                                  await MessageUtil.alertMessageScreen(
                                      context,
                                      'Valide seus dados',
                                      'Para prosseguir é necessário fazer login ou realizar seu cadastrar no aplicativo.',
                                      [
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Login'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Session.clearCliente();
                                            Session.clearEnderecoCliente();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                              return LoginPage();
                                            }), (routes) => false);
                                          },
                                        )
                                      ]);
                                }
                              : () {
                                  _validate(context);
                                }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: OutlineButton(
                          child: Text("Voltar",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor),
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(5.0),
//                              ),
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ],
                )),
          ))
        ],
      ),
    );
  }

  Widget _screenListVariacoes(BuildContext context, AsyncSnapshot snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          listaValores.add(-1);
          return Container(
//            color: Colors.white,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${snapshot.data[index].descricao}".toUpperCase(),
                  style: TextStyle(
                    color: Configuration.colorDefault4,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0),
                  child: Text(
                    _verificarMultiplos(snapshot, index),
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ),
                Container(
//                  color: Colors.white,
                  child: _screenListAdicionais(context, snapshot, index),
                )
              ],
            ),
          );
        },
        childCount: snapshot.data.length,
      ),
    );
  }

  Widget _screenListAdicionais(
      BuildContext context, AsyncSnapshot snapshot, int index) {
    if (snapshot.data[index].isMultiple == false) {
      return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: snapshot.data[index].adicionais.length,
          itemBuilder: (context, indice) {
            return Container(
              child:
//            Row(
//              children: <Widget>[
                  RadioListTile(
                title: Text(
                  snapshot.data[index].adicionais[indice].descricao,
                  style: TextStyle(fontSize: 14.5),
                ),
                activeColor: Configuration.colorDefault4,
                value: snapshot.data[index].adicionais[indice].id,
                groupValue: listaValores[index],
                onChanged: (value) {
                  setState(() {
//                    snapshot.data[index].adicionais[indice].selected = 1;
                    listaValores[index] = value;
                    Variacao variacao = snapshot.data[index];
                    for (Adicional adicional in variacao.adicionais) {
                      if (adicional.id ==
                          snapshot.data[index].adicionais[indice].id) {
                        if (adicional.selected) {
                          adicional.selected = false;
//                          print(adicional.selected);
                        } else {
                          adicional.selected = true;
//                          print(adicional.selected);
                        }
                      }
                    }

                    Variacao variacaoAtiva = _isListVariacao(variacao.id);
                    if (variacaoAtiva != null) {
                      for (Variacao variacaoAux in variacoesEscolhidas) {
                        if (variacaoAtiva.id == variacaoAux.id) {
                          variacoesEscolhidas.remove(variacaoAux);
                          print("removeu e");
                          break;
                        }
                      }
                      variacoesEscolhidas.add(variacao);
                      print("adicionou\n");
                    } else {
                      variacoesEscolhidas.add(variacao);
                      print("adicionou\n");
                    }

//                    if(variacoesEscolhidas.isNotEmpty){
//                      for(Variacao vari in variacoesEscolhidas){
//                        if(vari != null){
//                          print("${vari.descricao}");
//                          print("**************************************************");
//                          for(Adicional adicional in vari.adicionais){
//                            print("${adicional.id} - ${adicional.descricao} : ${adicional.selected}");
//
//                          }
//                        }else{
//                          print("objeto nulo");
//                        }
//
//                      }
//                    }
//                      for(Adicional adicional in variacao.adicionais){
//                          print(adicional.id);
//                          print(adicional.descricao);
//                          print(adicional.selected);
//                        }
//                    print(snapshot.data[index].adicionais[indice].id);
//                    print(snapshot.data[index].adicionais[indice].descricao);
//                    print(snapshot.data[index].adicionais[indice].selected);
                  });
                },
                secondary: Text(
                  "R\$ ${snapshot.data[index].adicionais[indice].valor}"
                      .replaceAll('.', ','),
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              ),
//              ],
//            )
            );
          });
    } else {
      _descricao = "";
      _descricao = _concatenarDescricao(snapshot.data[index]);
      return ListTile(
        title: Text(
          _descricao,
          style: TextStyle(fontSize: 14.0),
          maxLines: _maxLines,
        ),
        trailing: Container(
          padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.navigate_next),
              Text("Selecionar",
                  style: TextStyle(
                      fontSize: 12.0, color: Configuration.colorDefault4))
            ],
          ),
        ),
        onTap: () async {
          if (variacoesEscolhidas.isNotEmpty) {
            Variacao variacaoAuxiliar =
                _isListVariacao(snapshot.data[index].id);
            if (variacaoAuxiliar != null) {
              variacao = variacaoAuxiliar;
            } else {
              variacao = snapshot.data[index];
            }
          } else {
            variacao = snapshot.data[index];
          }

          dynamic variacaoNew = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return VariacoesShowPage(variacao, "${_produto.descricao}");
          }));
//          print(variacaoNew);
//          print(variacaoNew is int);
//          print(variacaoNew is Variacao);

          if (variacaoNew is Variacao) {
            for (Variacao variacaoAux in variacoesEscolhidas) {
              if (variacaoNew.id == variacaoAux.id) {
                variacoesEscolhidas.remove(variacaoAux);
                print("removeu e");
                break;
              }
            }
            variacoesEscolhidas.add(variacaoNew);

            print("adicionou");
//            for(Variacao v in variacoesEscolhidas){
//              print("\n\n Variação: ${v.descricao}");
//              for(Adicional a in v.adicionais){
//                print("adicional: "+a.descricao+" - ${a.selected}");
//              }
//            }

          } else if (variacaoNew is int) {
            if (variacoesEscolhidas.isNotEmpty) {
              for (Variacao variacaoAux in variacoesEscolhidas) {
                if (variacaoNew == variacaoAux.id) {
                  variacoesEscolhidas.remove(variacaoAux);
                  print("removeu e");
                  break;
                }
              }
            }
          }

//          for(Variacao v in variacoesEscolhidas){
//              print("\n\n Variação: ${v.descricao}");
//              for(Adicional a in v.adicionais){
//                print("adicional: "+a.descricao+" - ${a.selected}");
//              }
//          }
        },
      );
    }
  }

  String _concatenarDescricao(Variacao variacao) {
    String descricao = "";
    if (variacoesEscolhidas.isEmpty) {
      for (Adicional adicionalAuxiliar in variacao.adicionais) {
        if (variacao.adicionais.elementAt(variacao.adicionais.length - 1) ==
            adicionalAuxiliar) {
          descricao = "$descricao ${adicionalAuxiliar.descricao}";
        } else {
          descricao = "$descricao ${adicionalAuxiliar.descricao}, ";
        }
      }
      _maxLines = 3;
    } else {
      _maxLines = 0;
      Variacao variacaoNew = _isListVariacao(variacao.id);
      if (variacaoNew != null) {
        for (Adicional adicionalAuxiliar in variacaoNew.adicionais) {
          if (variacaoNew.adicionais
                  .elementAt(variacaoNew.adicionais.length - 1) ==
              adicionalAuxiliar) {
            if (adicionalAuxiliar.selected == true) {
              descricao = "$descricao ${adicionalAuxiliar.descricao}";
              _maxLines++;
            }
          } else {
            if (adicionalAuxiliar.selected == true) {
              descricao = "$descricao ${adicionalAuxiliar.descricao}\n\n";
              _maxLines++;
              _maxLines++;
            }
          }
//            print(_maxLines);
        }
      } else {
        for (Adicional adicionalAuxiliar in variacao.adicionais) {
          if (variacao.adicionais.elementAt(variacao.adicionais.length - 1) ==
              adicionalAuxiliar) {
            descricao = "$descricao ${adicionalAuxiliar.descricao}";
          } else {
            descricao = "$descricao ${adicionalAuxiliar.descricao}, ";
          }
        }
        _maxLines = 3;
      }
    }
    return descricao;
  }

  Variacao _isListVariacao(int id) {
    for (Variacao variacaoOld in variacoesEscolhidas) {
      if (variacaoOld.id == id) {
        return variacaoOld;
      }
    }
    return null;
  }

  _screenSelect() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.only(top: 50.0, bottom: 70.0),
              color: Color.fromRGBO(36, 36, 143, 0.5),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 380.0,
//                          color: Colors.green,
                    child: SimpleDialog(
                      title: Text(
                        "Quantidade",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.indigo, fontSize: 18.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      children: _listScreenSelect(),
                    ),
                  ),
                  Container(
                    width: 240.0,
                    child: OutlineButton(
                        child: Text("Fechar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(200, 200, 200, 1.0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        onPressed: () {
                          setState(() {
                            _quantidade = 1;
                          });
                          Navigator.pop(context);
                        }),
                  )
                ],
              ));
        });
  }

  List<Widget> _listScreenSelect() {
    List<Widget> listSelect = List();
    for (int i = 1; i <= 50; i++) {
      listSelect.add(
        SimpleDialogOption(
          child: Text(
            '$i',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              _quantidade = i;
            });
            Navigator.pop(context);
          },
        ),
      );
    }
    return listSelect;
  }

  bool _verifyVariationSelected(Variacao variacaoProduto) {
    if (variacoesEscolhidas.isNotEmpty) {
      for (Variacao variacaoEscolhida in variacoesEscolhidas) {
        if (variacaoProduto.id == variacaoEscolhida.id) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  int _countAdicionaisSelected(Variacao variacaoProduto) {
    int count = 0;
    if (variacoesEscolhidas.isNotEmpty) {
      for (Variacao variacaoEscolhida in variacoesEscolhidas) {
        if (variacaoProduto.id == variacaoEscolhida.id) {
          for (Adicional adicional in variacaoEscolhida.adicionais) {
            if (adicional.selected) {
              count++;
            }
          }
        }
      }
      return count;
    }
    return count;
  }

  Variacao _verifyVariation(List<Variacao> variacoesProduto) {
    for (Variacao variacao in variacoesProduto) {
//      if(variacao.minimo >= 1 && !_verifyVariationSelected(variacao)){
//        return variacao;
//      }

      int count = _countAdicionaisSelected(variacao);
//      print('LOG[variacao.minimo] - ${variacao.minimo}');
//      print('LOG[count] - $count');
      if (count < variacao.minimo) {
        return variacao;
      }
    }
    return null;
  }

  double _calcularValorProdutos(List<AdicionalEscolhido> adicionais) {
    double valor = 0.0;
    List<String> variacoesAnalisadas = [];

//    if(variacoesEscolhidas.isNotEmpty){
    for (AdicionalEscolhido adicional in adicionais) {
      if (adicional.valorTotal == 'somatotal') {
        valor += double.parse(adicional.valor);
      } else {
        if (!variacoesAnalisadas.contains(adicional.descricaoVariacao)) {
          double maiorValor = double.parse(adicional.valor);
          adicionais.forEach((a) {
            if (a.id != adicional.id &&
                a.descricaoVariacao == adicional.descricaoVariacao &&
                double.parse(a.valor) > double.parse(adicional.valor)) {
              maiorValor = double.parse(a.valor);
            }
          });
          variacoesAnalisadas.add(adicional.descricaoVariacao);
          valor += maiorValor;
        }
      }
//          print(valor);
    }
    return valor;
  }

  List<AdicionalEscolhido> _obterListaAdicionais() {
    List<AdicionalEscolhido> lista = List();
    for (Variacao variacao in variacoesEscolhidas) {
      for (Adicional adicional in variacao.adicionais) {
//        print(adicional.descricao);
        if (adicional.selected) {
          lista.add(AdicionalEscolhido(adicional.id, adicional.descricao,
              variacao.descricao, adicional.valor, variacao.valorTotal));
        }
      }
    }
    print('OBTEVE A LISTA------------------------------');
    return lista;
  }

//  List<EscolhaAdicional> _montarEscolhasAdicionais(List<Adicional> adicionais){
//    List<EscolhaAdicional> lista = List();
//    for(Adicional adicional in adicionais){
//        lista.add(EscolhaAdicional(adicional.id));
//
//    }
//    return lista;
//  }

  _validate(BuildContext context) {
    Variacao variacaoVerified = _verifyVariation(_produto.variacoes);
    if (variacaoVerified != null) {
//          print('entrou aqui');
      List<Widget> actions = List();
      actions.add(FlatButton(
        child: Text('OK'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ));
      MessageUtil.alertMessageScreen(
          context,
          "Você precisa selecionar, pelo menos ${variacaoVerified.minimo} ${variacaoVerified.descricao.toLowerCase()}",
          "",
          actions);
    } else {
      String texto;
      List<AdicionalEscolhido> adicionais = _obterListaAdicionais();
      double valorItem = (_produto.promocao
              ? _produto.precoComDesconto
              : double.parse(_produto.valorProduto)) +
          _calcularValorProdutos(adicionais);

      setState(() {
        texto = observacaoController.text;
      });

      _item = ItemCarrinho(_produto.id, _produto.descricao, _produto.imagem,
          _quantidade, valorItem, "não especificado", texto, adicionais);

      List<ItemCarrinho> lista = Session.getListaItens();
      lista.add(_item);
      Session.getPersistence().save(lista, Session.getIdParceiro());

//
//          print("**************************************************");
//          print("idParceiro: ${Session.getIdParceiro()}\n");
//          print("id: ${_item.descricaoProduto}\n");
//          print("quantidade: ${_item.quantidade}\n");
//          print("valor: ${_item.valor}\n");
//          print("observacao: ${_item.observacao}\n");
//
////          if(variacoesEscolhidas.isNotEmpty){
//            for(AdicionalEscolhido adicional in _item.adicionaisEscolhidos){
//              if(adicional != null){
//                print("_______________________________________________________");
//                print("${adicional.descricao}\n");
////                for(Adicional adicional in vari.adicionais){
////                  print("${adicional.id} - ${adicional.descricao} : ${adicional.selected}");
////
////                }
//              }else{
//                print("objeto nulo");
//              }
//
////            }
//          }

      Navigator.of(context).pop();
    }
  }
//   _fillInObject(){
//    _produto.variacoes =

//    if(variacoesEscolhidas.isNotEmpty){
//      for(Variacao vari in variacoesEscolhidas){
//        if(vari != null){
//          print("**************************************************");
//          print("${vari.descricao}\n");
//          for(Adicional adicional in vari.adicionais){
//            print("${adicional.id} - ${adicional.descricao} : ${adicional.selected}");
//
//          }
//        }else{
//          print("objeto nulo");
//        }
//
//      }
//    }
//  }

}
