import 'package:appfastdelivery/dao/produto_dao.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/helper/produto.dart';
import 'package:appfastdelivery/ui/carrinho_page.dart';
import 'package:appfastdelivery/ui/produto_show_page.dart';
import 'package:appfastdelivery/util/format_util.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:flutter/material.dart';


//class PromocoesPage extends StatelessWidget {
//
//
//}

class PromocoesPage extends StatefulWidget {
  final Parceiro parceiro;
  PromocoesPage(this.parceiro){
    Session.setParceiro(this.parceiro);
    Session.setIdParceiro(this.parceiro.id);
  }

  @override
  _PromocoesPageState createState() => _PromocoesPageState();
}

class _PromocoesPageState extends State<PromocoesPage> {
  Parceiro _parceiro;
  Future<List<Produto>> futureProdutos;



  @override
  void initState() {
    super.initState();
    _parceiro = widget.parceiro;
    futureProdutos = _initFutureProdutos(_parceiro.id);
  }

  Future<List<Produto>> _initFutureProdutos(int idParceiro) async{
    return await ProdutoDao.internal().listProdutosComPromocao(idParceiro);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_parceiro.nome,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: futureProdutos,
                builder: (BuildContext context, AsyncSnapshot<List<Produto>> snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return  Center(
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                            strokeWidth: 5.0,
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container(
                          child: Center(
                            child: Text("A Conexão Falhou!", style: TextStyle(fontSize: 20.0, color: Colors.grey)),
                          ),
                        );
                      } else {
                        return _listScreen(context, snapshot);

                      }
                  }
                }),
          )

        ],
      ),


      bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 55.0,
              child:
              Padding(
                padding: EdgeInsets.only(top: 0.0),
                child:
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        padding: EdgeInsets.all(2.0),
                        icon: Icon(Icons.home),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    IconButton(
                        padding: EdgeInsets.all(2.0),
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Stack(
                      alignment: Alignment(1.2, 9.0),
                      children: <Widget>[
                        IconButton(
                            padding: EdgeInsets.all(2.0),
                            icon: Icon(Icons.shopping_cart),
                            onPressed: () {
                              Session.setIdParceiro(_parceiro.id);
//                              Session.setNomeParceiro(_parceiro.nome);
                              Session.setParceiro(_parceiro);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return CarrinhoPage(Session.getListaItens());
                              }));

                            }
                        ),


                        _atualizarCarrinho(),
                      ],
                    ),


//                  IconButton(
//                      padding: EdgeInsets.all(2.0),
//                      icon: Icon(Icons.shopping_cart),
//                      onPressed: () {
//                        Navigator.of(context).push(
//                            MaterialPageRoute(builder: (context) {
//                              return CarrinhoPage(Session.getListaItens());
//                            }));
//                      }),
                  ],
                ),
              )
          )
      ),
    );
  }
  Widget _atualizarCarrinho(){
    return FutureBuilder(
        future: Session.getCarrinho(Session.getIdParceiro()),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            print('com dados');
            return snapshot.data.length > 0
                ?
            Container(
              width: 20.0,
              height: 20.0,

              alignment: Alignment.center,
              child: Text('${ snapshot.data.length}',
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .backgroundColor
                ),
              ),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),

            )
                :

            Container();

          }else{
            print('sem dados');
            return Container();
          }
        }
    );
  }


  Widget _listScreen(BuildContext context, AsyncSnapshot<List<Produto>> snapshot){
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context){
                    return ProdutoShowPage(snapshot.data[index]);
//                    return null;
                  }));
            },
            child: ListTile(
              leading: Container(
                width: 73.0,
                height: 75.0,
                decoration:
                BoxDecoration(
                    image: DecorationImage(
                        image: ImageUtil.loadWithRetry(snapshot.data[index].imagem),
                        fit: BoxFit.cover
                    )
                ),

              ),
              title: Text("${snapshot.data[index].descricao}",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                  )),
              subtitle: Text("${snapshot.data[index].observacao}",
                  style: TextStyle(
                    fontSize: 14.0,
                  )),
              trailing: Column(
                children: <Widget>[
                  Text(snapshot.data[index].promocao == true
                      ? "R\$: ${FormatUtil.doubleToPrice(snapshot.data[index].precoComDesconto)}"
                      : "R\$: ${snapshot.data[index].preco}",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: snapshot.data[index].promocao == true
                            ? Colors.green[800]
                            : Colors.black
                    ),
                  ),
                  Text(snapshot.data[index].promocao == true
                      ? "R\$: ${snapshot.data[index].preco}"
                      : "",
                    style: TextStyle(
                        fontSize: 12.0,
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.solid
                    ),
                  ),
                ],
              ),

            ),
          );
        }

    );
  }


}
