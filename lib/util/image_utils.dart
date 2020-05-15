import 'package:flutter/material.dart';
//import 'package:flutter_image/network.dart';

abstract class ImageUtil{

//  static NetworkImageWithRetry loadWithRetry(String url){
//    return NetworkImageWithRetry(url);
//  }

  static NetworkImage loadWithRetry(String url){
    return NetworkImage(url);
  }

  static NetworkImage load(String url){
    return NetworkImage(url);
  }


}
