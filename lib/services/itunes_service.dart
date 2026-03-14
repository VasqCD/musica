/// Servicio que realiza peticiones HTTP a la API de búsqueda de iTunes.
///
/// Este archivo encapsula toda la lógica de comunicación con la API REST de Apple
/// (iTunes Search API). Siguiendo el patrón de arquitectura limpia, la capa de
/// vistas y controladores no necesita conocer los detalles de HTTP.
///
/// **Flujo de uso:**
/// 1. Se registra con `Get.put(ItunesService())` en [main].
/// 2. [HomeController] lo obtiene con `Get.find<ItunesService>()`.
/// 3. [HomeController] llama a [buscarCanciones] cuando el usuario escribe en la
///    barra de búsqueda o al iniciar la app para cargar canciones populares.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:musica/models/track_model.dart';

/// Proporciona métodos para consultar la API pública de iTunes Search.
///
/// Se registra como singleton en GetX mediante `Get.put(ItunesService())`
/// en [main], por lo que solo existe una instancia durante toda la vida de la app.
class ItunesService {
  /// URL base interna de la API de iTunes Search.
  ///
  /// Es privada (`_url`) porque ninguna parte externa de la app necesita
  /// conocer o modificar este valor. Los parámetros de búsqueda se añaden
  /// como query string en [buscarCanciones].
  static const String _url = 'https://itunes.apple.com/search';

  /// Busca canciones en iTunes y devuelve una lista de [TrackModel].
  ///
  /// Realiza una petición GET asíncrona a la iTunes Search API con los
  /// parámetros especificados y convierte la respuesta JSON en objetos Dart.
  ///
  /// **Parámetros:**
  /// - [consulta]: texto de búsqueda (artista, canción, álbum). Los espacios
  ///   se codifican automáticamente con [Uri.encodeComponent].
  /// - [limite]: número máximo de resultados a devolver. Por defecto 10.
  ///   Se pasa como `limit` en la URL.
  /// - [atributo]: campo de iTunes por el que filtrar (p. ej. `"genreTerm"`,
  ///   `"artistTerm"`). Si es `null` no se añade el parámetro a la URL.
  ///
  /// **Retorna:** `Future<List<TrackModel>>` — lista de canciones encontradas.
  ///
  /// **Lanza:** [Exception] si el servidor responde con un código HTTP distinto
  /// de 200 (p. ej. 404, 500).
  ///
  /// **Llamado desde:**
  /// - [HomeController.cargarPopulares] al iniciar la app.
  /// - [HomeController.buscarCanciones] cuando el usuario escribe en la búsqueda.
  Future<List<TrackModel>> buscarCanciones(
    String consulta, {
    int limite = 10,
    String? atributo,
  }) async {
    // Codifica el texto de búsqueda para usarlo en una URL (reemplaza espacios
    // por %20, etc.) y elimina espacios al inicio/final con trim().
    final termino = Uri.encodeComponent(consulta.trim());

    // Si se proporcionó un atributo, se agrega el parámetro &attribute=... a la URL.
    final atributoParam = atributo != null ? '&attribute=$atributo' : '';

    // Construye la URL completa:
    // https://itunes.apple.com/search?term=rock&entity=song&limit=20&attribute=genreTerm
    final uri = Uri.parse(
        '$_url?term=$termino&entity=song&limit=$limite$atributoParam');

    // Realiza la petición HTTP GET y espera la respuesta (programación asíncrona).
    // `http.get` devuelve un Future<Response> que se resuelve cuando llega la respuesta.
    final respuesta = await http.get(uri);

    // Verifica que la respuesta sea exitosa (código 200 OK).
    // Cualquier otro código indica un error del servidor.
    if (respuesta.statusCode != 200) {
      throw Exception('API Error:${respuesta.statusCode}');
    }

    // Decodifica el cuerpo de la respuesta JSON a un Map de Dart.
    // El cuerpo tiene la forma: { "resultCount": N, "results": [...] }
    final datos = json.decode(respuesta.body) as Map<String, dynamic>;

    // Extrae el arreglo "results". Si la clave no existe o es null,
    // usa una lista vacía como valor por defecto con el operador `?? []`.
    final resultados = datos["results"] as List<dynamic>? ?? [];

    // Convierte cada elemento del arreglo JSON en un objeto TrackModel
    // usando el constructor factory TrackModel.fromJson y devuelve la lista.
    return resultados
        .map((e) => TrackModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
