
// Las peticiones rest a la api

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:musica/models/track_model.dart';

class ItunesService {

  static const String _url = 'https://itunes.apple.com/search';

  // peticiones http, o programacino asincrona
  // {int limite = 10}: las llaves hacen que "limite sea opcional"
  Future<List<TrackModel>> buscarCanciones(String consulta, {int limite = 10, String? atributo}) async {
    //Uri es para la url y el trim para limpiar espacios
    final termino = Uri.encodeComponent(consulta.trim());
    //es la url de la peticion
    final atributoParam = atributo != null ? '&attribute=$atributo' : '';
    final uri = Uri.parse('$_url?term=$termino&entity=song&limit=$limite$atributoParam');

    //haciendo la peticion http rest a la api de apple
    final respuesta = await http.get(uri);

    if(respuesta.statusCode != 200){
      throw Exception('API Error:${respuesta.statusCode}' );
    }

    final datos = json.decode(respuesta.body) as Map<String, dynamic>;

    final resultados = datos["results"] as List<dynamic>? ?? [];

    return resultados.map((e) =>
       TrackModel.fromJson(e as Map<String, dynamic>))
       .toList();

  }

}
