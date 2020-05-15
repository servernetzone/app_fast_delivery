import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Teste extends StatefulWidget {
  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  var _phoneController = MaskedTextController(mask: '(00) 00000-0000');



  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
////      resizeToAvoidBottomInset: false,
//        body:
//        Center(
//          child:
//          Column(
//            mainAxisSize: MainAxisSize.max,
//            children: <Widget>[
//              Expanded(
//                flex: 2,
//                child: Container(
//                  color: Colors.red,
//                  height: 800.0,
//                ),
//              ),
//              Container(
//                color: Colors.blue,
//                height: 100,
//                width: 50,
//              ),
//              Expanded(
//                flex: 1,
//                child: Container(
//                  color: Colors.red,
//                  height: 100,
//                ),
//              ),
//            ],
//          ),
//        )
//
//
//
//
////        Container(
////        decoration: BoxDecoration(
////                            color: Colors.purple,
////                            image: DecorationImage(
////                              image: AssetImage('images/background.png'),
////                            )),
////          child:
////          SingleChildScrollView(
////            child:
////              Column(
////                mainAxisAlignment: MainAxisAlignment.center,
////                children: <Widget>[
//////                  Container(
//////                    color: Colors.green,
//////                    alignment: Alignment.center,
//////                    margin: EdgeInsets.all(40.0),
//////                    child: Center(
//////                      child: Column(
//////                        mainAxisAlignment: MainAxisAlignment.center,
//////                        children: <Widget>[
//////                          Container(
//////                            width: 150.0,
//////                            height: 150.0,
//////                            decoration: BoxDecoration(
//////                                shape: BoxShape.rectangle,
//////                                image: DecorationImage(fit: BoxFit.cover,
//////                                  image: AssetImage('images/logo_reverse.png'),
//////                                )),
//////                          ),
//////                          Text('FastDelivery',
//////                            style: TextStyle(
//////                                fontSize: 28.0,
//////                                color: Theme.of(context).backgroundColor,
//////                                fontWeight: FontWeight.bold),
//////                          ),
//////
//////                          Container(
//////                            height: 70.0,
//////                            padding:  EdgeInsets.only(left: 10.0, right: 10.0),
//////                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//////                            decoration: BoxDecoration(
//////                                color: Theme.of(context).backgroundColor,
//////                                borderRadius: BorderRadius.circular(5.0)
//////                            ),
//////                            child: TextField(
//////                              controller: _phoneController,
//////                              focusNode: FocusNode(),
//////                              keyboardType: TextInputType.phone,
//////                              decoration: InputDecoration(
//////                                labelText: "DDD + Celular",
//////                                alignLabelWithHint: true,
//////                                hintText: "Entre com DDD + Celular",
//////                                hintStyle: TextStyle(fontSize: 13.0),
//////                                labelStyle: TextStyle(color: Colors.red,
//////                                    fontWeight: FontWeight.bold,
//////                                    fontSize: 15.0),
//////                                enabledBorder: InputBorder.none,
//////                                focusedBorder: InputBorder.none,
//////                              ),
//////                            ),
//////
//////                          ),
//////
//////
//////                          Container(
//////                            width: 300.0,
//////                            height: 50.0,
//////                            child: RaisedButton(
//////                                child: Text('Acessar'),
//////                                onPressed: (){
//////
//////                                  String celular =  _phoneController.text;
//////                                  celular= celular.replaceAll(RegExp(r'[^\w]+'), "");
//////                                  celular = '+55'+celular;
//////
//////
//////
//////
//////
//////
//////
//////                                }),
//////                          )
//////
//////                        ],
//////                      ),
//////                    ),
//////                  ),
////
////
////
//////                  Stack(
//////                    alignment: Alignment.center,
//////                    children: <Widget>[
////////                      Container(
//////////                  height: 500.0,
////////
////////                      ),
//////
//////
//////
////////              Container(
////////                color: Colors.green,
////////                alignment: Alignment.center,
////////                margin: EdgeInsets.all(40.0),
////////                child: Center(
////////                  child: Column(
////////                    mainAxisAlignment: MainAxisAlignment.center,
////////                    children: <Widget>[
////////                      Container(
////////                        width: 150.0,
////////                        height: 150.0,
////////                        decoration: BoxDecoration(
////////                            shape: BoxShape.rectangle,
////////                            image: DecorationImage(fit: BoxFit.cover,
////////                              image: AssetImage('images/logo_reverse.png'),
////////                            )),
////////                      ),
////////                      Text('FastDelivery',
////////                        style: TextStyle(
////////                            fontSize: 28.0,
////////                            color: Theme.of(context).backgroundColor,
////////                            fontWeight: FontWeight.bold),
////////                      ),
////////
////////                      Container(
////////                        height: 70.0,
////////                        padding:  EdgeInsets.only(left: 10.0, right: 10.0),
////////                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
////////                        decoration: BoxDecoration(
////////                            color: Theme.of(context).backgroundColor,
////////                            borderRadius: BorderRadius.circular(5.0)
////////                        ),
////////                        child: TextField(
////////                          controller: _phoneController,
////////                          focusNode: FocusNode(),
////////                          keyboardType: TextInputType.phone,
////////                          decoration: InputDecoration(
////////                            labelText: "DDD + Celular",
////////                            alignLabelWithHint: true,
////////                            hintText: "Entre com DDD + Celular",
////////                            hintStyle: TextStyle(fontSize: 13.0),
////////                            labelStyle: TextStyle(color: Colors.red,
////////                                fontWeight: FontWeight.bold,
////////                                fontSize: 15.0),
////////                            enabledBorder: InputBorder.none,
////////                            focusedBorder: InputBorder.none,
////////                          ),
////////                        ),
////////
////////                      ),
////////
////////
////////                      Container(
////////                        width: 300.0,
////////                        height: 50.0,
////////                        child: RaisedButton(
////////                            child: Text('Acessar'),
////////                            onPressed: (){
////////
////////                              String celular =  _phoneController.text;
////////                              celular= celular.replaceAll(RegExp(r'[^\w]+'), "");
////////                              celular = '+55'+celular;
////////
////////
////////
////////
////////
////////
////////
////////                            }),
////////                      )
////////
////////                    ],
////////                  ),
////////                ),
////////              ),
//////                    ],
//////                  ),
////                ],
////              )
////
////          )
////
////        )
//
//
//
//
//
//
//
//    );
//  }




  Widget build(BuildContext context) {
       return
         Scaffold(
           body: ListView(
             padding: const EdgeInsets.all(10.0),
             children: <Widget>[
               CustomListItemTwo(
                 thumbnail: Container(
                   decoration: const BoxDecoration(color: Colors.pink),
                 ),
                 title: 'Flutter 1.0 Launch',
                 subtitle:
                 'Flutter continues to improve and expand its horizons.'
                     'This text should max out at two lines and clip',
                 author: 'Dash',
                 publishDate: 'Dec 28',
                 readDuration: '5 mins',
               ),
               CustomListItemTwo(
                 thumbnail: Container(
                   decoration: const BoxDecoration(color: Colors.blue),
                 ),
                 title: 'Flutter 1.2 Release - Continual updates to the framework',
                 subtitle: 'Flutter once again improves and makes updates.',
                 author: 'Flutter',
                 publishDate: 'Feb 26',
                 readDuration: '12 mins',
               ),
             ],
           ),
         );
     }
}
class CustomListItemTwo extends StatelessWidget {
     CustomListItemTwo({
       Key key,
       this.thumbnail,
       this.title,
       this.subtitle,
       this.author,
       this.publishDate,
       this.readDuration,
     }) : super(key: key);

     final Widget thumbnail;
     final String title;
     final String subtitle;
     final String author;
     final String publishDate;
     final String readDuration;

     @override
     Widget build(BuildContext context) {
       return Padding(
         padding: const EdgeInsets.symmetric(vertical: 10.0),
         child: SizedBox(
           height: 100,
           child: Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               AspectRatio(
                 aspectRatio: 1.0,
                 child: thumbnail,
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                   child: _ArticleDescription(
                     title: title,
                     subtitle: subtitle,
                     author: author,
                     publishDate: publishDate,
                     readDuration: readDuration,
                   ),
                 ),
               )
             ],
           ),
         ),
       );
     }
   }
class _ArticleDescription extends StatelessWidget {
     _ArticleDescription({
       Key key,
       this.title,
       this.subtitle,
       this.author,
       this.publishDate,
       this.readDuration,
     }) : super(key: key);

     final String title;
     final String subtitle;
     final String author;
     final String publishDate;
     final String readDuration;

     @override
     Widget build(BuildContext context) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Expanded(
             flex: 2,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Text(
                   '$title',
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                   style: const TextStyle(
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                 Text(
                   '$subtitle',
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                   style: const TextStyle(
                     fontSize: 12.0,
                     color: Colors.black54,
                   ),
                 ),
               ],
             ),
           ),
           Expanded(
             flex: 1,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.end,
               children: <Widget>[
                 Text(
                   '$author',
                   style: const TextStyle(
                     fontSize: 12.0,
                     color: Colors.black87,
                   ),
                 ),
                 Text(
                   '$publishDate · $readDuration ★',
                   style: const TextStyle(
                     fontSize: 12.0,
                     color: Colors.black54,
                   ),
                 ),
               ],
             ),
           ),
         ],
       );
     }
   }



