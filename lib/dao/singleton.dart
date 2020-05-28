


class Factory{

  static final Factory _instance = Factory.internal();
  factory Factory() => _instance;
  Factory.internal();

  final String _ipDefault = 'http://192.168.1.4:8000';
//  final String _ipDefault = 'http://www.appfastdelivery.com';
//  final String _ipDefault = 'http://908cdd6f.ngrok.io/';



// final String _url = 'http://www.appfastdelivery.com/mobile/';
// final String _urlDefault = 'http://www.appfastdelivery.com';
// final String _ip = 'http://www.appfastdelivery.com/';


//  final String _ip = 'http://192.168.1.7:8000/';
//  final String _url = 'http://192.168.1.7:8000/mobile/';
//  final String _urlDefault = 'http://192.168.1.7:8000';

//  final String _ip = 'http://353af27b.ngrok.io/';
//  final String _url = 'http://353af27b.ngrok.io/mobile/';
//  final String _urlDefault = 'http://353af27b.ngrok.io';

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
