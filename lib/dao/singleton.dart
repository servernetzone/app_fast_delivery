
class Factory{

  static final Factory _instance = Factory.internal();
  factory Factory() => _instance;
  Factory.internal();

//  final String _ipDefault = 'http://192.168.1.7:8000';
  final String _ipDefault = 'http://www.appfastdelivery.com';


String getUrl(){
  return '$_ipDefault/mobile/';
}

String getIp(){
  return '$_ipDefault/';
}

  String getUrlDefault(){
    return _ipDefault;
  }
}
