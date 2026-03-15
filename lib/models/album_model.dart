// To parse this JSON data, do
//
//     final albumModel = albumModelFromJson(jsonString);

import 'dart:convert';

AlbumModel albumModelFromJson(String str) => AlbumModel.fromJson(json.decode(str));

String albumModelToJson(AlbumModel data) => json.encode(data.toJson());

class AlbumModel {
    int resultCount;
    List<Result> results;

    AlbumModel({
        required this.resultCount,
        required this.results,
    });

    factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
        resultCount: json["resultCount"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "resultCount": resultCount,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    WrapperType wrapperType;
    String? artistType;
    String artistName;
    String? artistLinkUrl;
    int artistId;
    int? amgArtistId;
    String primaryGenreName;
    int? primaryGenreId;
    CollectionType? collectionType;
    int? collectionId;
    String? collectionName;
    String? collectionCensoredName;
    String? artistViewUrl;
    String? collectionViewUrl;
    String? artworkUrl60;
    String? artworkUrl100;
    double? collectionPrice;
    CollectionExplicitness? collectionExplicitness;
    int? trackCount;
    String? copyright;
    Country? country;
    Currency? currency;
    DateTime? releaseDate;
    String? contentAdvisoryRating;

    Result({
        required this.wrapperType,
        this.artistType,
        required this.artistName,
        this.artistLinkUrl,
        required this.artistId,
        this.amgArtistId,
        required this.primaryGenreName,
        this.primaryGenreId,
        this.collectionType,
        this.collectionId,
        this.collectionName,
        this.collectionCensoredName,
        this.artistViewUrl,
        this.collectionViewUrl,
        this.artworkUrl60,
        this.artworkUrl100,
        this.collectionPrice,
        this.collectionExplicitness,
        this.trackCount,
        this.copyright,
        this.country,
        this.currency,
        this.releaseDate,
        this.contentAdvisoryRating,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        wrapperType: wrapperTypeValues.map[json["wrapperType"]]!,
        artistType: json["artistType"],
        artistName: json["artistName"],
        artistLinkUrl: json["artistLinkUrl"],
        artistId: json["artistId"],
        amgArtistId: json["amgArtistId"],
        primaryGenreName: json["primaryGenreName"],
        primaryGenreId: json["primaryGenreId"],
        collectionType: collectionTypeValues.map[json["collectionType"]]!,
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        collectionCensoredName: json["collectionCensoredName"],
        artistViewUrl: json["artistViewUrl"],
        collectionViewUrl: json["collectionViewUrl"],
        artworkUrl60: json["artworkUrl60"],
        artworkUrl100: json["artworkUrl100"],
        collectionPrice: json["collectionPrice"]?.toDouble(),
        collectionExplicitness: collectionExplicitnessValues.map[json["collectionExplicitness"]]!,
        trackCount: json["trackCount"],
        copyright: json["copyright"],
        country: countryValues.map[json["country"]]!,
        currency: currencyValues.map[json["currency"]]!,
        releaseDate: json["releaseDate"] == null ? null : DateTime.parse(json["releaseDate"]),
        contentAdvisoryRating: json["contentAdvisoryRating"],
    );

    Map<String, dynamic> toJson() => {
        "wrapperType": wrapperTypeValues.reverse[wrapperType],
        "artistType": artistType,
        "artistName": artistName,
        "artistLinkUrl": artistLinkUrl,
        "artistId": artistId,
        "amgArtistId": amgArtistId,
        "primaryGenreName": primaryGenreName,
        "primaryGenreId": primaryGenreId,
        "collectionType": collectionTypeValues.reverse[collectionType],
        "collectionId": collectionId,
        "collectionName": collectionName,
        "collectionCensoredName": collectionCensoredName,
        "artistViewUrl": artistViewUrl,
        "collectionViewUrl": collectionViewUrl,
        "artworkUrl60": artworkUrl60,
        "artworkUrl100": artworkUrl100,
        "collectionPrice": collectionPrice,
        "collectionExplicitness": collectionExplicitnessValues.reverse[collectionExplicitness],
        "trackCount": trackCount,
        "copyright": copyright,
        "country": countryValues.reverse[country],
        "currency": currencyValues.reverse[currency],
        "releaseDate": releaseDate?.toIso8601String(),
        "contentAdvisoryRating": contentAdvisoryRating,
    };
}

enum CollectionExplicitness {
    EXPLICIT,
    NOT_EXPLICIT
}

final collectionExplicitnessValues = EnumValues({
    "explicit": CollectionExplicitness.EXPLICIT,
    "notExplicit": CollectionExplicitness.NOT_EXPLICIT
});

enum CollectionType {
    ALBUM
}

final collectionTypeValues = EnumValues({
    "Album": CollectionType.ALBUM
});

enum Country {
    USA
}

final countryValues = EnumValues({
    "USA": Country.USA
});

enum Currency {
    USD
}

final currencyValues = EnumValues({
    "USD": Currency.USD
});

enum WrapperType {
    ARTIST,
    COLLECTION
}

final wrapperTypeValues = EnumValues({
    "artist": WrapperType.ARTIST,
    "collection": WrapperType.COLLECTION
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
