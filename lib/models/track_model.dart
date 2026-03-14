

// To parse this JSON data, do
//
//     final trackModel = trackModelFromJson(jsonString);

import 'dart:convert';

TrackModel trackModelFromJson(String str) => TrackModel.fromJson(json.decode(str));

String trackModelToJson(TrackModel data) => json.encode(data.toJson());

class TrackModel {
    String wrapperType;
    String kind;
    int artistId;
    int collectionId;
    int trackId;
    String artistName;
    String collectionName;
    String trackName;
    String collectionCensoredName;
    String trackCensoredName;
    String artistViewUrl;
    String collectionViewUrl;
    String trackViewUrl;
    String previewUrl;
    String artworkUrl60;
    String artworkUrl100;
    double collectionPrice;
    double trackPrice;
    String collectionExplicitness;
    String trackExplicitness;
    int discCount;
    int discNumber;
    int trackCount;
    int trackNumber;
    int trackTimeMillis;
    String country;
    String currency;
    String primaryGenreName;

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
