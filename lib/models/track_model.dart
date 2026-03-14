/// Modelo de datos que representa una canción (track) obtenida de la API de iTunes.
///
/// Este archivo define la clase [TrackModel] y dos funciones auxiliares para
/// convertir entre JSON (texto) y objetos Dart.
///
/// **Flujo de uso:**
/// 1. [ItunesService] hace una petición HTTP a iTunes.
/// 2. La respuesta JSON se decodifica y cada elemento se convierte en un [TrackModel]
///    usando [TrackModel.fromJson].
/// 3. Los objetos [TrackModel] se almacenan en los [RxList] del [HomeController].
/// 4. Las vistas ([CardTrack], [DescriptionTrack]) leen las propiedades del modelo
///    para mostrar la información al usuario.

// Para convertir un String JSON a TrackModel puedes usar:
//     final trackModel = trackModelFromJson(jsonString);

import 'dart:convert';

/// Convierte un String JSON en un objeto [TrackModel].
///
/// [str] debe ser el cuerpo completo de la respuesta JSON de un solo track.
/// Usa [json.decode] para parsear el String y luego llama a [TrackModel.fromJson].
///
/// **Llamado desde:** pruebas unitarias o cuando se necesita parsear un solo JSON.
TrackModel trackModelFromJson(String str) =>
    TrackModel.fromJson(json.decode(str));

/// Convierte un objeto [TrackModel] a su representación JSON en String.
///
/// Usa [json.encode] sobre el mapa generado por [TrackModel.toJson].
///
/// **Llamado desde:** pruebas unitarias o cuando se necesita serializar un track.
String trackModelToJson(TrackModel data) => json.encode(data.toJson());

/// Representa una canción individual devuelta por la API de iTunes.
///
/// Cada instancia de esta clase corresponde a un objeto dentro del arreglo
/// `"results"` de la respuesta JSON de iTunes Search API.
///
/// Las propiedades más usadas en la UI son:
/// - [trackName]: nombre de la canción (mostrado en [CardTrack] y [DescriptionTrack]).
/// - [artistName]: nombre del artista.
/// - [artworkUrl60]: URL de la portada pequeña (usada en la lista de canciones).
/// - [artworkUrl100]: URL de la portada mediana (ampliada a 600x600 en el reproductor).
/// - [previewUrl]: URL del audio de 30 segundos que reproduce [PlayerController].
/// - [trackTimeMillis]: duración total en milisegundos (mostrada en [CardTrack]).
class TrackModel {
  /// Tipo de contenedor del resultado (p. ej. "track").
  String wrapperType;

  /// Tipo de media (p. ej. "song", "music-video").
  String kind;

  /// Identificador único del artista en iTunes.
  int artistId;

  /// Identificador único del álbum en iTunes.
  int collectionId;

  /// Identificador único de la canción en iTunes.
  int trackId;

  /// Nombre del artista tal como aparece en iTunes.
  String artistName;

  /// Nombre del álbum sin censura.
  String collectionName;

  /// Nombre de la canción sin censura.
  String trackName;

  /// Nombre del álbum con posibles reemplazos por contenido explícito.
  String collectionCensoredName;

  /// Nombre de la canción con posibles reemplazos por contenido explícito.
  String trackCensoredName;

  /// URL para ver la página del artista en iTunes Store.
  String artistViewUrl;

  /// URL para ver el álbum en iTunes Store.
  String collectionViewUrl;

  /// URL para ver la canción en iTunes Store.
  String trackViewUrl;

  /// URL de la vista previa de audio (30 segundos). Usada por [PlayerController].
  String previewUrl;

  /// URL de la imagen de portada del álbum en tamaño 60×60 px.
  /// Usada en la lista de canciones ([CardTrack]).
  String artworkUrl60;

  /// URL de la imagen de portada del álbum en tamaño 100×100 px.
  /// En [DescriptionTrack] se sustituye "100x100" por "600x600" para
  /// obtener una imagen de mayor resolución.
  String artworkUrl100;

  /// Precio del álbum completo en la tienda.
  double collectionPrice;

  /// Precio individual de la canción en la tienda.
  double trackPrice;

  /// Indica si el álbum contiene contenido explícito ("explicit", "cleaned", "notExplicit").
  String collectionExplicitness;

  /// Indica si la canción contiene contenido explícito.
  String trackExplicitness;

  /// Número total de discos del álbum.
  int discCount;

  /// Número de disco al que pertenece esta canción dentro del álbum.
  int discNumber;

  /// Número total de canciones en el álbum.
  int trackCount;

  /// Número de posición de la canción dentro del álbum.
  int trackNumber;

  /// Duración de la canción en milisegundos. Usada en [CardTrack] para
  /// mostrar el tiempo en formato "mm:ss".
  int trackTimeMillis;

  /// País de la tienda iTunes donde está disponible el track (p. ej. "USA").
  String country;

  /// Moneda de los precios (p. ej. "USD").
  String currency;

  /// Género musical principal de la canción (p. ej. "Rock", "Pop").
  String primaryGenreName;

  /// Constructor con todos los campos requeridos.
  ///
  /// Se llama principalmente desde [TrackModel.fromJson] cuando se parsea
  /// la respuesta de la API.
  TrackModel({
    required this.wrapperType,
    required this.kind,
    required this.artistId,
    required this.collectionId,
    required this.trackId,
    required this.artistName,
    required this.collectionName,
    required this.trackName,
    required this.collectionCensoredName,
    required this.trackCensoredName,
    required this.artistViewUrl,
    required this.collectionViewUrl,
    required this.trackViewUrl,
    required this.previewUrl,
    required this.artworkUrl60,
    required this.artworkUrl100,
    required this.collectionPrice,
    required this.trackPrice,
    required this.collectionExplicitness,
    required this.trackExplicitness,
    required this.discCount,
    required this.discNumber,
    required this.trackCount,
    required this.trackNumber,
    required this.trackTimeMillis,
    required this.country,
    required this.currency,
    required this.primaryGenreName,
  });

  /// Crea un [TrackModel] a partir de un mapa JSON.
  ///
  /// Este constructor de fábrica (factory) se llama dentro de [ItunesService]
  /// para convertir cada elemento del arreglo `"results"` de la respuesta HTTP
  /// en un objeto Dart tipado.
  ///
  /// [json] es un `Map<String, dynamic>` con las claves de la API de iTunes.
  ///
  /// **Llamado desde:** [ItunesService.buscarCanciones]
  factory TrackModel.fromJson(Map<String, dynamic> json) => TrackModel(
        wrapperType: json["wrapperType"],
        kind: json["kind"],
        artistId: json["artistId"],
        collectionId: json["collectionId"],
        trackId: json["trackId"],
        artistName: json["artistName"],
        collectionName: json["collectionName"],
        trackName: json["trackName"],
        collectionCensoredName: json["collectionCensoredName"],
        trackCensoredName: json["trackCensoredName"],
        artistViewUrl: json["artistViewUrl"],
        collectionViewUrl: json["collectionViewUrl"],
        trackViewUrl: json["trackViewUrl"],
        previewUrl: json["previewUrl"],
        artworkUrl60: json["artworkUrl60"],
        artworkUrl100: json["artworkUrl100"],
        collectionPrice: json["collectionPrice"]?.toDouble(),
        trackPrice: json["trackPrice"]?.toDouble(),
        collectionExplicitness: json["collectionExplicitness"],
        trackExplicitness: json["trackExplicitness"],
        discCount: json["discCount"],
        discNumber: json["discNumber"],
        trackCount: json["trackCount"],
        trackNumber: json["trackNumber"],
        trackTimeMillis: json["trackTimeMillis"],
        country: json["country"],
        currency: json["currency"],
        primaryGenreName: json["primaryGenreName"],
      );

  /// Convierte este objeto [TrackModel] de vuelta a un mapa JSON.
  ///
  /// Útil para serializar el modelo cuando se necesita almacenarlo localmente
  /// o enviarlo a otro servicio.
  ///
  /// **Llamado desde:** [trackModelToJson]
  Map<String, dynamic> toJson() => {
        "wrapperType": wrapperType,
        "kind": kind,
        "artistId": artistId,
        "collectionId": collectionId,
        "trackId": trackId,
        "artistName": artistName,
        "collectionName": collectionName,
        "trackName": trackName,
        "collectionCensoredName": collectionCensoredName,
        "trackCensoredName": trackCensoredName,
        "artistViewUrl": artistViewUrl,
        "collectionViewUrl": collectionViewUrl,
        "trackViewUrl": trackViewUrl,
        "previewUrl": previewUrl,
        "artworkUrl60": artworkUrl60,
        "artworkUrl100": artworkUrl100,
        "collectionPrice": collectionPrice,
        "trackPrice": trackPrice,
        "collectionExplicitness": collectionExplicitness,
        "trackExplicitness": trackExplicitness,
        "discCount": discCount,
        "discNumber": discNumber,
        "trackCount": trackCount,
        "trackNumber": trackNumber,
        "trackTimeMillis": trackTimeMillis,
        "country": country,
        "currency": currency,
        "primaryGenreName": primaryGenreName,
      };
}
