import 'package:watch_time/config/constants/environment.dart';
import 'package:watch_time/domain/datasources/movies_datasource.dart';
import 'package:watch_time/domain/entities/movie.dart';
import 'package:watch_time/domain/entities/video.dart';
import 'package:watch_time/infrastructure/mappers/movie_mapper.dart';
import 'package:watch_time/infrastructure/mappers/video_mapper.dart';
import 'package:watch_time/infrastructure/models/models.dart';
import 'package:watch_time/infrastructure/models/moviedb/movie_details.dart';
import 'package:watch_time/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDbDatasource extends MoviesDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDbKey,
      'language': 'en',
    },
  ));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromMap(json);
    final List<Movie> movies = movieDbResponse.results
        .where((movieDb) => movieDb.posterPath != 'no-poster')
        .map((movieDb) => MovieMapper.movieDbToEntitiy(movieDb))
        .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
    });
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular', queryParameters: {
      'page': page,
    });
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', queryParameters: {
      'page': page,
    });
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated', queryParameters: {
      'page': page,
    });
    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMoviesById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) {
      throw Exception('Movie with ID: $id not found');
    }

    final movieDb = MovieDetails.fromMap(response.data);
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDb);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    // This condition will prevent us to do more requests when we modify the query
    // value from a custom one back to an empty string.
    if (query.isEmpty) return [];

    final response = await dio.get('/search/movie', queryParameters: {
      'query': query,
    });
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideosReponse.results) {
      if (moviedbVideo.site == 'YouTube') {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }
}
