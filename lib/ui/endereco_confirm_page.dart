import 'package:appfastdelivery/util/configuration.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/ui/pedidos_page.dart';
import 'cliente_page.dart';
import 'favoritos_page.dart';



class EnderecoConfirmPage extends StatefulWidget {
  @override
  _EnderecoConfirmPageState createState() => _EnderecoConfirmPageState();
}

class _EnderecoConfirmPageState extends State<EnderecoConfirmPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FastDelivery",
          style: TextStyle(fontSize: 25.0,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
//        color: Colors.green,
        child: Center(
          child: Column(
            children: <Widget>[
              Icon(Icons.my_location,
                color: Configuration.colorDefault2,
                size: 70.0,
              ),

              SizedBox(height: 30.0,),

              Text('Ei, onde você está?',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0
                ),

              ),
              SizedBox(height: 30.0,),
              Text('Informe onde o pedido deve ser entregue, '
                  'iremos te mostrar as melhores opções.',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 12.0
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0,),
              Text('Informe abaixo',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0
                ),

              ),
              SizedBox(height: 35.0,),
              Icon(Icons.keyboard_arrow_down,
                color: Configuration.colorDefault1,
                size: 40.0,
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 105.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                color: Theme.of(context).accentColor,
                height: 60.0,
                child:
                RawMaterialButton(
                    child:
                    Padding(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Entregar onde?',
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0
                                ),
                              ),
                              Text('Informe o endereço de entrega',
                                style: TextStyle(
                                    color: Configuration.colorDefault1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0
                                ),
                              ),


                            ],
                          ),

                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 7.0),
                    ),
                    onPressed: () {










                    }
                ),

              ),

              Container(
                  height: 45.0,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.home,
                                  color: Theme.of(context).accentColor),
                              onPressed: () {
                                print("Ja esta nessa tela");
                              }),
                          IconButton(
                              icon: Icon(Icons.favorite,
                                  color: Theme.of(context).accentColor),
                              onPressed: () {
                                //Navigator.of(context).pop();
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return FavoritosPage();
                                }));
                              }),
                          IconButton(
                              icon: Icon(Icons.list,
                                  color: Theme.of(context).accentColor),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return PedidosPage();
                                }));
                              }),
                          IconButton(
                              icon: Icon(Icons.account_circle,
                                  color: Theme.of(context).accentColor),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ClientePage();
                                }));
                              }),
                        ],
                      ))),
            ],
          ),
        )


      ),

    );
  }
}

