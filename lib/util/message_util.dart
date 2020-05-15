import 'package:flutter/material.dart';
abstract class MessageUtil{

  static Future<void> alertMessageScreen(BuildContext context ,String title, String subtitle, List<Widget> actions) {
    return showDialog(
        context: context,
//        barrierDismissible: false,
        builder: (BuildContext context) {
          return
            Container(
                padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                color: Theme.of(context).accentColor.withOpacity(0.5),
                child:
                AlertDialog(
                    title: Text('$title'),
                    titleTextStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('$subtitle',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                    actions: actions
                )
            );

        }
    );
  }


  static void alertSimpleMessageScreen(BuildContext context, String title, String subtitle, List<Widget> actions){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
                    title: Text('${title}'),
                    titleTextStyle: TextStyle(fontSize: 16.0, color: Color.fromRGBO(36, 36, 143, 1.0)),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('${subtitle}',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                    actions: actions
                );

        }
    );
  }


  static void alertConfirmScreen(BuildContext context ,String title, String subtitle, List<Widget> actions){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            Container(
                padding: EdgeInsets.only(top: 50.0, bottom: 70.0),
                color: Theme.of(context).accentColor.withOpacity(0.5),
                child:
                AlertDialog(
                    title: Text('$title'),
                    titleTextStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('$subtitle',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                    actions: actions
                )
            );

        }
    );
  }


}
