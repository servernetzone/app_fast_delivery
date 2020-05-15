import 'package:appfastdelivery/util/configuration.dart';
import 'package:flutter/material.dart';


class UpdateVesionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.update, color: Theme.of(context).accentColor, size: 60.0,),
              SizedBox(height: 20.0),
              Text('Nova versão disponível',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10.0),
              Text('Uma nova versão do FastDelivery está disponível. Por favor, atualize seu app.',
                style: TextStyle(
                    fontSize: 15.0,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
