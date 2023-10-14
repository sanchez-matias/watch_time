// To parse this JSON data, do
//
//     final movieDbResponse = movieDbResponseFromMap(jsonString);
import 'movie_moviedb.dart';

class MovieDbResponse {
  final Dates? dates;
  final int page;
  final List<MovieFromMovieDb> results;
  final int totalPages;
  final int totalResults;

  MovieDbResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieDbResponse.fromMap(Map<String, dynamic> json) => MovieDbResponse(
        // En esta API pueden no venir las fechas así que cambiamos este parametro
        // para que acepte un null.
        dates: json['dates'] != null ? Dates.fromMap(json["dates"]) : null,
        page: json["page"],
        results: List<MovieFromMovieDb>.from(
            json["results"].map((x) => MovieFromMovieDb.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toMap() => {
        // en caso de que las dates no vengan como respuesta, le mando null en
        // el atributo dates.
        "dates": dates == null ? null : dates!.toMap(),
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Dates {
  final DateTime maximum;
  final DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  Map<String, dynamic> toMap() => {
        "maximum":
            "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
      };
}
