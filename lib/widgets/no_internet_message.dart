import 'package:appfastdelivery/util/configuration.dart';
import 'package:flutter/material.dart';

class NoInternetMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.signal_wifi_off,
            color: Configuration.colorDefault,
            size: 100,
          ),
          Text('Verifique sua conexão com a intenet, por favor.',
            style: TextStyle(fontSize: 16),)
        ],
      ),
    );
  }
}

class NoInternetMessageBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      color: Colors.red,
      child: Text(
        "Sem conexão com a internet",
        style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

