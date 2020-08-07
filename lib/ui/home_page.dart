import 'package:appfastdelivery/dao/cliente_dao.dart';
import 'package:appfastdelivery/dao/parceiro_dao.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/helper/parceiros_model.dart';
import 'package:appfastdelivery/ui/parceiro_page.dart';
import 'package:appfastdelivery/ui/pedidos_page.dart';
import 'package:appfastdelivery/ui/update_version_page.dart';
import 'package:appfastdelivery/util/configuration.dart';
import 'package:appfastdelivery/util/message_util.dart';
import 'package:appfastdelivery/widgets/no_internet_message.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:appfastdelivery/ui/parceiros_page.dart';
import 'package:provider/provider.dart';
import 'cliente_page.dart';
import 'package:appfastdelivery/ui/buscar_parceiro_page.dart';

import 'favoritos_page.dart';

class HomePage extends StatefulWidget {
  static final String routeName = '/Home';
  String path;

  bool goToPedidosPage;

  HomePage({this.goToPedidosPage = false});

  HomePage.path(this.path, {this.goToPedidosPage = false});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  int _currentIndex;
  ParceiroDao parceiroDao = ParceiroDao();
  var clienteDao;
  static Future<List<Parceiro>> parceiros;
  String _title;

  final PageStorageBucket bucket = PageStorageBucket();

  List<String> titles = ['FastDelivery', 'Favoritos', 'Meus pedidos', 'Perfil'];

  String get path => widget.path;
  List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    clienteDao = ClienteDao();
    verificarVersao();
    _title = titles[0];
    parceiros = _buscarParceiros();
    pages = [
      ParceirosPage(widget.path),
      FavoritosPage(
        key: PageStorageKey('favoritos_page'),
      ),
      PedidosPage(
        key: PageStorageKey('pedidos_page'),
      ),
      ClientePage(
        key: PageStorageKey('cliente_page'),
      ),
    ];
    _verificarPath(parceiros);
    if (widget.goToPedidosPage) {
      _changePage(2);
    }
  }

  _buscarParceiros() {
    parceiros = Provider.of<ParceirosModel>(context, listen: false)
        .getParceiros()
        .then((parceiros) => _verificarPath(parceiros));
  }

  _verificarPath(parceiros) async {
    print(path);
    if (path != null) {
      int id = int.parse(path.replaceAll('/', ''));
      Parceiro parceiroLink;
      parceiros.forEach((element) {
        if (element.id == id) {
          parceiroLink = element;
        }
      });
      if (parceiroLink != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ParceiroPage(parceiroLink);
        }));
      } else {
        MessageUtil.alertMessageScreen(context, 'Fast Delivery',
            'O parceiro não está disponível na sua localidade', [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);
      }
    }
  }

  _changePage(index) {
    setState(() {
      _title = titles[index];
      _currentIndex = index;
    });
  }

  verificarVersao() {
    print(
        '**************** iniciou controle de versão ***********************');
    clienteDao.getVersion().then((response) async {
      String projectCode = await GetVersion.projectCode;
      int code = int.parse(projectCode);
      if (code < response['cod32']) {
        print('versões diferentes! atualizar');
        print('code < response[cod32] = $code < ${response['cod32']}');
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return UpdateVesionPage();
        }));
      } else {
        print(
            'versões iguais ou maior. code >= response[cod32] = $code >= ${response['cod32']}');
      }
    });
    print('*****************************************************************');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              _title,
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
              if (_currentIndex == 0)
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return BuscarParceiroPage();
                    }));
                  },
                )
            ],
          ),
          body: ConnectivityWidget(
            builder: (context, isOnline) {
              return isOnline
                  ? IndexedStack(index: _currentIndex, children: pages)
                  : NoInternetMessage();
            },
            onlineCallback: _buscarParceiros,
            offlineBanner: NoInternetMessageBanner()),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 100,
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            selectedItemColor: Theme.of(context).accentColor,
            unselectedItemColor: Configuration.colorDefault2,
            onTap: (index) => _changePage(index),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                title: Text('Início'),
                icon: Icon(Icons.home),
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                title: Text('Favoritos'),
                icon: Icon(Icons.favorite),
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                title: Text('Pedidos'),
                icon: Icon(Icons.list),
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                title: Text('Perfil'),
                icon: Icon(Icons.account_circle),
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
