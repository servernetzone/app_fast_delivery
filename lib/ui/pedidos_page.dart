import 'package:appfastdelivery/dao/pedido_dao.dart';
import 'package:appfastdelivery/helper/resumopedido.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/util/json_utils.dart';
import 'package:appfastdelivery/util/session.dart';

import 'cliente_page.dart';
import 'pedido_show_page.dart';
import 'favoritos_page.dart';
import 'home_page.dart';

class PedidosPage extends StatefulWidget {
  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  int _idCliente;

  Future<List<ResumoPedido>> _futurePedidos;

  @override
  void initState() {
    super.initState();
    _idCliente = Session.getCliente().id;
    _futurePedidos = _initFutureParceirosFavoritos();
    _atualiza();
  }

  void _atualiza() async {
    await Future.delayed(Duration(seconds: 45));
    if (mounted) {
      setState(() {
        _futurePedidos = _initFutureParceirosFavoritos();
      });
    }
    _atualiza();
  }

  Future<List<ResumoPedido>> _initFutureParceirosFavoritos() async {
    return await PedidoDao.internal().list(_idCliente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meus Pedidos",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _futurePedidos,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
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
                return Container(
                  child: Center(
                    child: Text("Não foi posssivel carregar!"),
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: listResumos(snapshot.data),
                  ),
                );
              }
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
            height: 45.0,
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.home,
                            color: Configuration.colorDefault2),
                        onPressed: () {
//                          Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                        }),
                    IconButton(
                        icon: Icon(Icons.favorite,
                            color: Configuration.colorDefault2),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return FavoritosPage();
                          }));
                        }),
                    IconButton(
                        icon: Icon(Icons.list,
                            color: Theme.of(context).accentColor),
                        onPressed: () {
                        }),
                    IconButton(
                        icon: Icon(Icons.account_circle,
                            color: Configuration.colorDefault2),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ClientePage();
                          }));
                        }),
                  ],
                ))),
      ),
    );
  }

  messageTemplate({String title, IconData icon}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80,
        ),
        Text(title)
      ],
    ));
  }

  listResumos(List resumos) {
//    print(resumos[0].getParceiroImagem);
    if (resumos.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.list,
            size: 80,
            color: Theme.of(context).accentColor,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Seus pedidos aparecerão aqui ",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 16)),
          ),
          Text("Faça seu primeiro pedido agora mesmo ☺",
              style: TextStyle(color: Colors.black, fontSize: 13)),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: resumos.length,
            padding: EdgeInsets.all(5),
            itemBuilder: (context, index) {
//                  print("${resumos[index].id} - ${resumos[index].getParceiroNome}");
              return ListTile(
                  title: Text(
                      resumos[index].codigo +
                          "\n" +
                          resumos[index].getParceiroNome,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor)),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        resumos[index].andamento,
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: resumos[index].cor),
                      ),
                      Text(
                        resumos[index].cancelamento
                            ? 'Cancelamento habilitado'
                            : '',
                        style: TextStyle(
                            fontSize: 12.0, color: Configuration.colorRed2),
                      ),
                    ],
                  ),
                  leading: Container(
                    width: 55.0,
                    height: 55.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: ImageUtil.loadWithRetry(
                                resumos[index].getParceiroImagem))),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(resumos[index].getPreco,
                          style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(resumos[index].getTempo,
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.black)),
//                  Divider(height: 15.0,color: Colors.red),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PedidoShowPage(
                          resumos[index].id, resumos[index].codigo);
                    }));
//                          print("Abre tela do pedido");
                  });
            },
          ))
        ],
      );
    }
  }
}
