//WALTERLY
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:flutter/material.dart';
import 'package:appfastdelivery/dao/bairro_dao.dart';
import 'package:appfastdelivery/util/configuration.dart';


class BairroListPage extends StatefulWidget {


  List<Bairro> lista;
  BairroListPage.internal(this.lista);


  @override
  _BairroListPageState createState() => _BairroListPageState();
}

class _BairroListPageState extends State<BairroListPage> {
  BairroDao _bairroDao;
  List<Bairro> _bairros;

  @override
  void initState() {
    super.initState();
    _bairroDao = BairroDao();
    _bairros = widget.lista;
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
              IconButton(
                  padding: EdgeInsets.all(0.0),
                  alignment: Alignment(-0.4, 0),
                  color: Colors.green,
                  icon: Icon(Icons.arrow_back,
                    color: Theme
                        .of(context)
                        .accentColor,
                    size: 25.0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),

//              TextField(
//                enabled: false,
//                decoration: InputDecoration(
//                  alignLabelWithHint: true,
//                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//                  hintText: 'Rua, avenida travessa, etc',
//                  hintStyle: TextStyle(
//                      fontSize: 15.0
//                  ),
//                  enabledBorder: UnderlineInputBorder(
//                      borderSide: BorderSide(
//                          color: Theme.of(context).accentColor
//                      )
//                  ),
//                  border: UnderlineInputBorder(
//                      borderSide: BorderSide(
//                          color: Theme.of(context).accentColor
//                      )
//                  ),
//                  focusedBorder: UnderlineInputBorder(
//                      borderSide: BorderSide(
//                          color: Theme.of(context).accentColor
//                      )
//                  ),
//                ),
//
//                onChanged: (value){
//
//                },
//              ),
              SizedBox(height: 10.0,),

//              Container(
//                margin: EdgeInsets.only(top: 20.0),
//                child:
//                Column(
//                  children: <Widget>[
//                    Expanded(
//                        child:
//                        FutureBuilder(
//                          future: _bairroDao.list(),
//                          builder: (BuildContext context, AsyncSnapshot snapshot){
//                            switch (snapshot.connectionState) {
//                              case ConnectionState.waiting:
//                              case ConnectionState.none:
//                                return Center(
//                                  child:  Container(
//                                    width: 200.0,
//                                    height: 200.0,
//                                    alignment: Alignment.center,
//                                    child: CircularProgressIndicator(
//                                      valueColor:
//                                      AlwaysStoppedAnimation<Color>(
//                                          Colors.indigo),
//                                      strokeWidth: 5.0,
//                                    ),
//                                  ),
//                                );
//
//                              default:
//                                if (snapshot.hasError) {
//                                  return Container(
//                                    child: Center(
//                                      child: Text("A Conexão Falhou!"),
//                                    ),
//                                  );
//                                } else {
//                                  return
//                                    ListView.builder(
//                                    itemCount: snapshot.data.length,
//                                      itemBuilder: (BuildContext context, int index){
//                                        return _screenListTile(context, snapshot, index);
//                                      });
//                                }
//                            }
//                          },
//                        )
//                    )


              Expanded(
                  child:
                  ListView.builder(
                      itemCount: _bairros.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _screenListTile2(context, index);
                      })
              )
//                  ],
//                ),
//              ),
            ],
          ),

      ),
    );
  }

  Widget _screenListTile(BuildContext context, AsyncSnapshot snapshot, int index){
    return
      Container(
        padding: EdgeInsets.all(0.0),
//        height: 40.0,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0),
              title: Text(snapshot.data[index].descricao,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(snapshot.data[index].descricao);
              },
            ),

            Divider(
              color: Configuration.colorWrite1,
              indent: 0.0,
              height: 0.0,
            )
          ],
        ),
      );

//        onTap: (){
//
//        };
//    }
  }

  Widget _screenListTile2(BuildContext context, int index){
    return
      Container(
        padding: EdgeInsets.all(0.0),
//        height: 40.0,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0),
              title: Text(_bairros[index].descricao,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(_bairros[index].descricao);
              },
            ),

            Divider(
              color: Configuration.colorWrite1,
              indent: 0.0,
              height: 0.0,
            )
          ],
        ),
      );

//        onTap: (){
//
//        };
//    }
  }



}
