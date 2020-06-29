import '../helper/endereco.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;

const kGoogleApiKey = "AIzaSyC8T8CYT3jo3nUzrOXgXNPDMEcqU6_QI90";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

Future<List<List<String>>> buscarEnderecosPorNome(String pesquisa) async {
  var enderecos = List<List<String>>();
  PlacesSearchResponse retorno =
      await _places.searchByText(pesquisa, language: "pt-BR");
  enderecos.add(List<String>());
  enderecos.add(List<String>());

  retorno.results.forEach((endereco) {
    enderecos[0].add(endereco.placeId);
    enderecos[1].add(endereco.formattedAddress);
  });
  return enderecos;
}

Future<List<String>> buscarEnderecosPorLocalizacao() async {
  var enderecos = List<List<String>>();
  enderecos.add(List<String>());
  enderecos.add(List<String>());
  var location = new loc.Location();

  loc.LocationData currentLocation = await location.getLocation();
  PlacesSearchResponse retorno = await _places.searchNearbyWithRankBy(
      Location(currentLocation.latitude, currentLocation.longitude), "distance",
      type: 'route', language: 'pt-BR');

  List<String> lista = List<String>();
  lista.add(retorno.results[0].placeId);
  String endereco = await enderecoFormatado(retorno.results[0].placeId);
  lista.add(endereco);
  return lista;
}

Future<String> enderecoFormatado(String placeId) async {
  String endereco;
  await _places.getDetailsByPlaceId(placeId, language: "pt-BR").then((det) {
    endereco = det.result.formattedAddress;
  });
  return endereco;
}

Future<EnderecoPedido> buscarEnderecoPorID(String id) async {
  print('getDetailsByPlaceId');
  EnderecoPedido endereco = EnderecoPedido();
  final detalhes = _places.getDetailsByPlaceId(id, language: "pt-BR");
  await detalhes.then((det) {
    var addressComponents = det.result.addressComponents;

    for (int i = 0; i < addressComponents.length; i++) {
      switch (addressComponents[i].types[0]) {
        case 'route':
          endereco.rua = addressComponents[i].longName;
          break;
        case 'postal_code':
          endereco.cep = addressComponents[i].longName;
          break;
        case 'sublocality_level_1':
          endereco.bairro = addressComponents[i].longName;
          break;
        case 'administrative_area_level_2':
          endereco.cidade = addressComponents[i].longName;
          break;
        case 'administrative_area_level_1':
          endereco.estado = addressComponents[i].longName;
          endereco.uf = addressComponents[i].shortName;
          break;
      }
    }
  });
  return endereco;
}
