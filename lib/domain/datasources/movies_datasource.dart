import 'package:watch_time/domain/entities/entities.dart';

abstract class MoviesDataSource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<Movie> getMoviesById(String id);

  Future<List<Movie>> searchMovies(String query);
  
  Future<List<Video>> getYoutubeVideosById( int movieId );
}
