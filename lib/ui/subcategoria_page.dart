import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/subcategoria_dao.dart';
import 'package:appfastdelivery/helper/categoria.dart';
import 'package:appfastdelivery/ui/parceiro_page1.dart';
import 'package:appfastdelivery/ui/produto_page.dart';
import 'package:appfastdelivery/util/session.dart';

import 'carrinho_page.dart';


class SubCategoriaPage extends StatefulWidget {
  final Categoria categoria;

  SubCategoriaPage(this.categoria);

  @override
  _SubCategoriaPageState createState() => _SubCategoriaPageState();
}

class _SubCategoriaPageState extends State<SubCategoriaPage> {
  SubCategoriaDao subCategoriaDao;
  Categoria _categoria;


  @override
  void initState() {
    super.initState();

    this._categoria = widget.categoria;
    subCategoriaDao = SubCategoriaDao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_categoria.descricao.toUpperCase()),
        actions: <Widget>[
        ],
        centerTitle: true,
      ),
//      backgroundColor: Colors.white,

      body: Container(
        child:  Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child:
                  FutureBuilder(
                      future: subCategoriaDao.list(_categoria.id),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return
                              Center(
                                child: Container(
                                  width: 200.0,
                                  height: 200.0,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                                    strokeWidth: 5.0,
                                  ),
                                ),
                              );
                          default:
                            if (snapshot.hasError) {
                              return Container(
                                child: Center(
                                  child: Text("A Conexão Falhou!"),
                                ),
                              );
                            } else {
                              return RefreshIndicator(
                                  child: _gridSubCategorias(context, snapshot),
                                  onRefresh: () async {
                                    setState(() {
                                    });
                                  },
                              );
                            }
                        }
                      }
                  )
              ),
            ],
          ),
        )

      ),

      bottomNavigationBar:
      BottomAppBar(
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return CarrinhoPage(Session.getListaItens());
                          }));
                        }
                    ),


                    _atualizarCarrinho(),
                  ],
                ),

              ],
            ),
          )
        )



//        Container(
//            height: 60.0,
//            child: Padding(
//              padding: EdgeInsets.only(left: 26.0, right: 26.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  IconButton(
//                      icon: Icon(Icons.home),
//                      onPressed: () {
//                        Navigator.pop(context);
//                      }),
//                  IconButton(
//                      icon: Icon(Icons.arrow_back),
//                      onPressed: () {
//                        Navigator.pop(context);
//                      }),
//                  IconButton(
//                      icon: Icon(Icons.shopping_cart),
//                      onPressed: () {
//                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                          return CarrinhoPage(Session.getListaItens());
//                        }));
//                      }),
//                ],
//              ),
//            )),
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

  Widget _gridSubCategorias(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(1.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ProdutoPage.subCategoria(snapshot.data[index]);
              }));

            },
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: ImageUtil.loadWithRetry(snapshot.data[index].image)
                        ),
                        border: Border.all(
                            color: Theme.of(context).accentColor,
                            width: 2.0,
                            style: BorderStyle.solid
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                  ),
                  SizedBox(height: 7.0),
                  Expanded(
                      child: Text(
                        '${snapshot.data[index].descricao}',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),
//                    ),
                      )
                  )
                ],
              ),
            ),
          );
        });
  }


}
