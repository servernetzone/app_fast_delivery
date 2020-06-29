import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_image/network.dart';

abstract class ImageUtil {
//  static NetworkImageWithRetry loadWithRetry(String url){
//    return NetworkImageWithRetry(url);
//  }
  static loadWithRetry(String url) {
    return CachedNetworkImageProvider(url);
  }

  static load(String url) {
    return CachedNetworkImageProvider(url);
  }
}
